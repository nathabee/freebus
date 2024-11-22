# TEST  Configuration Review and TLS Handshake Check

<!-- TOC -->
- [TEST  Configuration Review and TLS Handshake Check](#test--configuration-review-and-tls-handshake-check)
  - [TLS Handshake Check](#tls-handshake-check)
    - [Common Issues:](#common-issues)
  - [Configuration Review](#configuration-review)
    - [What to Look For](#what-to-look-for)
    - [Configuration Summary](#configuration-summary)
<!-- TOC END -->


##  TLS Handshake Check
Since you reported being able to successfully connect via:

```sh
openssl s_client -connect mail.nathabee.de:587 -starttls smtp
```


1. **Check Logs**:
   - Postfix log (`/var/log/mail.log` or `/var/log/maillog`).
   - Dovecot log (`/var/log/dovecot.log` or `/var/log/dovecot-info.log`).

   These logs can provide insights into why the **LMTP** connection is being refused.

2. **Verify the Socket**:
   - Make sure that **Dovecot** is creating the **LMTP socket** properly, and that **Postfix** is able to access it:

   ```bash
   sudo ls -l /var/spool/postfix/private/dovecot-lmtp
   ```



The "openssl" command allows you to initiate a secure connection to your SMTP server, but it won't allow you to send email directly without proper SMTP commands.

After connecting with `openssl s_client`, you need to enter valid SMTP commands manually. Here's a brief outline of what to do next:

1. **Enter EHLO Command**:
   ```
   EHLO mail.nathabee.de
   ```
   This should give you information about the server's capabilities. You'll see something like:
   ```
   250-mail.nathabee.de Hello [your IP address]
   250-STARTTLS
   250 AUTH PLAIN LOGIN
   ```

2. **Authenticate** (if required):
   If your server requires authentication, you will need to log in using the `AUTH` command. For example:
   ```
   AUTH LOGIN
   ```
   After this, it will prompt you for a Base64 encoded username and password. You can generate these values by using:
   ```bash
   echo -n 'your_email_username' | base64
   echo -n 'your_email_password' | base64
   ```
   Then provide the encoded values.

3. **Set the Email Addresses**:
   ```
   MAIL FROM:<youremail@nathabee.de>
   ```
   Followed by:
   ```
   RCPT TO:<recipient@example.com>
   ```

4. **Data Section**:
   Start writing the body of the email:
   ```
   DATA
   ```
   After this command, you can type the email content, including headers:
   ```
   Subject: Test Email
   This is a test email sent via OpenSSL and manual SMTP commands.

   .
   ```
   End the email body with a single dot `.` on a line by itself, which signals the end of the content.

5. **Quit the Session**:
   ```
   QUIT
   ```

### Common Issues:
- **Error 500**: Typically means that the command was incorrect or not recognized by the server. Make sure the SMTP commands are entered exactly.
- **"read R BLOCK"**: Indicates that OpenSSL is waiting for a response from the server. If you see this for a long time, it could indicate a timeout or an issue with the server responding.

Try these commands in sequence, and let me know if you run into specific issues with them.



## Configuration Review


### What to Look For
- **Certificate Chain**: Make sure the **correct certificate chain** is being used, and that no errors related to **certificate verification** are shown during the connection.
- **TLS Versions and Cipher Suites**: Look at the details of the handshake to ensure that strong **TLS versions** and **ciphers** are being used. It’s common to see compatibility issues when certain weaker ciphers or older protocols (such as TLS 1.0) are disabled.

### Configuration Summary
Given the information you've shared, here's how your configuration should look after fixing the issues:

#### `/etc/postfix/main.cf`
```conf
# TLS for incoming connections
smtpd_tls_cert_file = /etc/letsencrypt/live/nathabee.de/fullchain.pem
smtpd_tls_key_file = /etc/letsencrypt/live/nathabee.de/privkey.pem
smtpd_tls_security_level = encrypt
smtpd_tls_auth_only = yes

# TLS for outgoing connections
smtp_tls_CApath = /etc/ssl/certs
smtp_tls_security_level = may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtp_tls_cert_file = /etc/letsencrypt/live/nathabee.de/fullchain.pem
smtp_tls_key_file = /etc/letsencrypt/live/nathabee.de/privkey.pem

# LMTP configuration
virtual_transport = dovecot-lmtp
mailbox_transport = dovecot-lmtp
```

#### `/etc/postfix/master.cf`
Ensure you have the LMTP transport set up correctly:

```conf
dovecot-lmtp unix - - n - - lmtp
  -o lmtp_tls_security_level=none
```
