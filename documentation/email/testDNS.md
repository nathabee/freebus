# **Test DNS configuration**
<!-- TOC -->
- [**Test DNS configuration**](#test-dns-configuration)
  - [**Using MXToolbox**](#using-mxtoolbox)
    - [**Steps to Test with MXToolbox**](#steps-to-test-with-mxtoolbox)
  - [**Using `dig` on the Command Line**](#using-dig-on-the-command-line)
    - [**Common DNS Queries with `dig`**](#common-dns-queries-with-dig)
  - [**Additional Validations**](#additional-validations)
    - [**Test Email Sending**](#test-email-sending)
    - [**Test Email Receiving**](#test-email-receiving)
  - [**Interpretation of Results**](#interpretation-of-results)
<!-- TOC END -->


## **Using MXToolbox**
MXToolbox is an online tool that provides a suite of DNS tests.

### **Steps to Test with MXToolbox**
1. **Go to the MXToolbox Website:**
   - Visit [MXToolbox](https://mxtoolbox.com).

2. **Perform DNS Tests:**
   - **MX Lookup:**
     - Input your domain (e.g., `nathabee.de`) in the search bar and select **MX Lookup**.
     - This checks if your MX records point to your mail server (e.g., `mail.nathabee.de`).
   - **SPF Lookup:**
     - Select **SPF Record Lookup** and enter `nathabee.de`.
     - Ensure your SPF record is present and correct.
   - **DKIM Lookup:**
     - Input the selector and domain (e.g., `default._domainkey.nathabee.de`) under the **DKIM Lookup** tool.
     - Verify that your DKIM record resolves correctly.
   - **DMARC Lookup:**
     - Select **DMARC Lookup** and input `_dmarc.nathabee.de`.
     - Ensure your DMARC record is valid and properly configured.
   - **Blacklist Check:**
     - Run the **Blacklist Check** for `nathabee.de` to ensure your domain or IP is not on any email blacklists.

3. **Analyze Results:**
   - Ensure all DNS records are correctly configured and there are no warnings or errors.

---

## **Using `dig` on the Command Line**
The `dig` command is a powerful DNS lookup tool available on most Unix/Linux systems.

### **Common DNS Queries with `dig`**
Run the following commands to test your domain:

1. **MX Records:**
   ```bash
   dig MX nathabee.de
   ```
   - This retrieves the mail exchanger records for your domain. Ensure the `ANSWER SECTION` includes the correct mail server (e.g., `mail.nathabee.de`).

2. **SPF Record:**
   ```bash
   dig TXT nathabee.de
   ```
   - Look for the `v=spf1` entry in the output, e.g.:
     ```plaintext
     "v=spf1 mx ip4:159.69.0.127 ~all"
     ```
   - Ensure it allows your mail server's IP.

3. **DKIM Record:**
   ```bash
   dig TXT default._domainkey.nathabee.de
   ```
   - Replace `default` with your DKIM selector if different.
   - Ensure the output includes `v=DKIM1; k=rsa; p=...`.

4. **DMARC Record:**
   ```bash
   dig TXT _dmarc.nathabee.de
   ```
   - Ensure the record specifies a policy like:
     ```plaintext
     "v=DMARC1; p=quarantine; rua=mailto:postmaster@nathabee.de"
     ```

5. **A Record:**
   ```bash
   dig A mail.nathabee.de
   ```
   - This retrieves the IP address of your mail server.

6. **Reverse DNS (PTR) Record:**
   ```bash
   dig -x 159.69.0.127
   ```
   - Replace `159.69.0.127` with your mail server's IP.
   - Ensure the result resolves to your mail server hostname (e.g., `mail.nathabee.de`).

---

## **Additional Validations**

### **Test Email Sending**
1. **Send a Test Email:**
   - Send an email from your domain (`nathabee.de`) to an external address (e.g., Gmail).
2. **Check Email Headers:**
   - Look for `DKIM`, `SPF`, and `DMARC` results in the headers:
     ```plaintext
     Authentication-Results: spf=pass; dkim=pass; dmarc=pass
     ```

### **Test Email Receiving**
- Use [mail-tester.com](https://www.mail-tester.com):
  - Send an email to the provided test address.
  - Analyze the detailed report, which checks SPF, DKIM, DMARC, and blacklist status.

---

## **Interpretation of Results**
- **MX Record:** Should resolve to your mail server (e.g., `mail.nathabee.de`).
- **SPF Record:** Ensure it allows your mail server IP and includes no syntax errors.
- **DKIM Record:** Should return your public key for signing validation.
- **DMARC Record:** Should specify a policy (`p=quarantine` or `p=reject`) and a reporting address (`rua`).
- **Reverse DNS (PTR):** Ensure your IP maps back to `mail.nathabee.de`.
