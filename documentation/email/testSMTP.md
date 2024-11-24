
# **Test SMTP Authentication Manually**


<!-- TOC -->
- [**Test SMTP Authentication Manually**](#test-smtp-authentication-manually)
  - [**Establish a Secure Connection**](#establish-a-secure-connection)
  - [**Test EHLO/HELO Command**](#test-ehlohelo-command)
  - [**Test Authentication with AUTH LOGIN**](#test-authentication-with-auth-login)
  - [**Send a Test Email Using SMTP Commands**](#send-a-test-email-using-smtp-commands)
  - [**Validate Email Delivery**](#validate-email-delivery)
  - [**Log Monitoring During the Test**](#log-monitoring-during-the-test)
  - [**Test Common Failures**](#test-common-failures)
  - [**Debug Logs for Postfix and Dovecot**](#debug-logs-for-postfix-and-dovecot)
    - [**Check Postfix Logs**](#check-postfix-logs)
    - [**Check Dovecot Logs**](#check-dovecot-logs)
  - [**Automate the Test with a Script**](#automate-the-test-with-a-script)
    - [**Run on the VPS Hosting the Email Server**](#run-on-the-vps-hosting-the-email-server)
    - [**Run from Another Machine**](#run-from-another-machine)
    - [**When to Use Each Option**](#when-to-use-each-option)
    - [**Recommended Approach**](#recommended-approach)
<!-- TOC END -->


---

## **Establish a Secure Connection**
- Use `openssl` to connect securely to the SMTP server on port 587 with STARTTLS.
  
  ```bash
  openssl s_client -connect mail.nathabee.de:587 -starttls smtp
  ```

  **Expected Output:**
  - `220 mail.nathabee.de` (or similar) indicating the server is ready.
  - Details about the server’s certificate (verify no errors or warnings about invalid certificates).

---

## **Test EHLO/HELO Command**
1. Issue the `EHLO` command to initiate a session:
   ```plaintext
   EHLO mail.nathabee.de
   ```

2. **Expected Response:**
   - A list of supported SMTP features, e.g.:
     ```plaintext
     250-mail.nathabee.de
     250-PIPELINING
     250-SIZE 35882577
     250-STARTTLS
     250-AUTH LOGIN PLAIN
     250-ENHANCEDSTATUSCODES
     250-8BITMIME
     250 DSN
     ```

3. **Validation Steps:**
   - Confirm `AUTH` is listed as supported with mechanisms like `LOGIN` or `PLAIN`.
   - Confirm `STARTTLS` is listed (to ensure encryption is available).

---

## **Test Authentication with AUTH LOGIN**
1. Issue the `AUTH LOGIN` command:
   ```plaintext
   AUTH LOGIN
   ```

2. Provide Base64-encoded credentials:
   - Encode your email:
     ```bash
     echo -n "evaluation@nathabee.de" | base64
     ```
   - Encode your password:
     ```bash
     echo -n "yourpassword" | base64
     ```

3. Enter the Base64-encoded email and password as prompted:
   ```plaintext
   AUTH LOGIN
   ZXZhbHVhdGlvbkBuYXRoYWJlZS5kZQ==
   eW91cnBhc3N3b3Jk
   ```

4. **Expected Response:**
   ```plaintext
   235 2.7.0 Authentication successful
   ```

5. **If Authentication Fails:**
   - Check the `smtpd_sasl_auth_enable` setting in Postfix.
   - Verify credentials in the `/etc/dovecot/passwd` file.
   - Monitor the logs (`/var/log/mail.log` and `/var/log/dovecot.log`).

---

## **Send a Test Email Using SMTP Commands**
After successful authentication, simulate sending an email via SMTP:

1. **Specify the Sender:**
   ```plaintext
   MAIL FROM:<evaluation@nathabee.de>
   ```

2. **Specify the Recipient:**
   ```plaintext
   RCPT TO:<your-gmail-address@gmail.com>
   ```

3. **Start the Data Block:**
   ```plaintext
   DATA
   ```

4. **Compose the Message:**
   ```plaintext
   From: evaluation@nathabee.de
   To: your-gmail-address@gmail.com
   Subject: Test Email

   This is a test email sent using openssl SMTP test.
   .
   ```

5. **Expected Response:**
   ```plaintext
   250 2.0.0 OK: queued as <message-id>
   ```

---

## **Validate Email Delivery**
1. Check if the test email appears in the recipient's inbox (e.g., Gmail).
2. Review the email headers:
   - Confirm SPF, DKIM, and DMARC validations passed.
   - Ensure no warnings about missing headers (e.g., `Received-SPF`, `DKIM-Signature`).

---

## **Log Monitoring During the Test**
- Monitor both Postfix and Dovecot logs while performing the test:
  ```bash
  sudo tail -f /var/log/mail.log /var/log/dovecot.log
  ```

---

## **Test Common Failures**
Simulate common issues and verify error handling:
1. **Incorrect Credentials:**
   - Use an incorrect password and expect:
     ```plaintext
     535 5.7.8 Error: authentication failed: authentication failure
     ```

2. **Invalid Recipient:**
   - Specify a nonexistent email (e.g., `nonexistent@example.com`) and expect:
     ```plaintext
     550 5.1.1 User unknown
     ```

3. **Blocked Connection:**
   - Test with a blocked IP or invalid port to confirm proper rejection:
     ```plaintext
     Connection timed out
     ```

---


## **Debug Logs for Postfix and Dovecot**

### **Check Postfix Logs**
Run:
```bash
sudo tail -f /var/log/mail.log
```

### **Check Dovecot Logs**
Run:
```bash
sudo tail -f /var/log/dovecot.log
```

---
## **Automate the Test with a Script**
To simplify repeated testing, we have created a shell script to automate the SMTP test:
 
```bash
scripts/smtp_test.sh
```


You can run the script either **on the VPS hosting the email server** or **from another machine**, but the choice depends on what you want to test. Here’s a breakdown of when to run the script on the VPS versus another machine:

---

### **Run on the VPS Hosting the Email Server**
**Use Case:**
- **Internal Testing:** Verifies that the email server (Postfix, Dovecot) is correctly configured to handle SMTP authentication and email submission locally.

**Advantages:**
1. **No Network Dependency:** Ensures the server is operational without considering external firewalls, DNS, or YourVPSProvider's port 25 block.
2. **Faster Debugging:** Useful during initial setup to validate internal configurations.
3. **Focus on Server Configuration:** Ensures the problem is not with external connectivity.

**How to Run:**
- Use `localhost` or the VPS's private IP as the SMTP server:
```bash
 scripts/smtp_test.sh evaluation@nathabee.de yourpassword recipient@gmail.com localhost
  ```

---

### **Run from Another Machine**
**Use Case:**
- **External Testing:** Verifies that your email server is reachable from the internet, including DNS resolution, firewalls, and port configurations.

**Advantages:**
1. **Tests End-to-End Connectivity:** Confirms that the server is publicly accessible and can handle SMTP requests from external clients.
2. **Validates DNS:** Ensures your MX records, SPF, and other DNS configurations are correctly set.
3. **Simulates Real Email Traffic:** Mimics how external users or servers will interact with your mail server.

**How to Run:**
- Use the public domain name of your mail server (e.g., `mail.nathabee.de`):
```bash
 scripts/smtp_test.sh evaluation@nathabee.de yourpassword recipient@gmail.com mail.nathabee.de
  ```

**Requirements:**
1. Ensure that:
   - The SMTP port (587 or 25) is open in your firewall.
   - YourVPSProvider allows outgoing traffic on the port you're testing (587 or 25).
2. If using port 25 and YourVPSProvider blocks it, use port 587 for submission.

---

### **When to Use Each Option**

| **Scenario**                        | **Run On VPS** | **Run From Another Machine** |
|-------------------------------------|----------------|------------------------------|
| Debugging SMTP authentication       | ✅             | ✅                           |
| Verifying firewall rules            | ❌             | ✅                           |
| Checking DNS records (e.g., MX, A)  | ❌             | ✅                           |
| Testing internal email submission   | ✅             | ❌                           |
| Confirming external email delivery  | ❌             | ✅                           |
| Network issues (e.g., blocked ports)| ❌             | ✅                           |

---

### **Recommended Approach**
1. **Start Testing on the VPS:**
   - Validate that the email server handles SMTP connections and authentication locally.
   - Use `localhost` or the server's private IP.

2. **Move to External Testing:**
   - Test connectivity, DNS, and firewall rules from an external machine.
   - Use the domain name (`mail.nathabee.de`) and simulate real-world conditions.

3. **Monitor Logs:**
   Always monitor the mail server logs during testing:
```bash
   sudo tail -f /var/log/mail.log
   sudo tail -f /var/log/dovecot.log
   ```

Let me know if you encounter specific issues during testing!