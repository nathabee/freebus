## TLS security

<!-- TOC -->
  - [TLS security](#tls-security)
    - [Configuguration email client on the PC (Thunbird)](#configuguration-email-client-on-the-pc-thunbird)
    - [Configuguration security on the server :](#configuguration-security-on-the-server)
<!-- TOC END -->


### Configuguration email client on the PC (Thunbird)

#### **Incoming Server (POP3) Configuration**:
- **Server Type**: POP3
- **Server**: `nathabee.de`
- **Port**: `995` (SSL/TLS)
- **Connection Security**: SSL/TLS
- **Authentication Method**: Normal Password
- **Username**: `evaluation@nathabee.de` or `freebus@nathabee.de`

#### **Outgoing Server (SMTP) Configuration**:
- **SMTP Server**: `nathabee.de`
- **Port**: `587` (STARTTLS) or `465` (SSL/TLS)
- **Connection Security**: STARTTLS or SSL/TLS
- **Authentication Method**: Normal Password
- **Username**: `evaluation@nathabee.de` or `freebus@nathabee.de`

### Configuguration security on the server :
####  **Open Necessary Ports**:
make sure that the necessary ports are open on your server's **firewall** settings. In you Cloudprovider Console, you need to configure the **firewall settings** to allow the following:
   - Make sure the following ports are open in firewall settings:
     - IMAP: `993` (SSL/TLS)
     - POP3: `995` (SSL/TLS)
     - SMTP: `587` (STARTTLS) and `465` (SSL/TLS)

   These firewall settings will allow incoming connections for secure email access using Thunderbird or any other client.

####  **Configure SSL/TLS for Dovecot**:
    - In Dovecot, you need to enable **SSL/TLS** for secure connections on ports `993` (IMAP) and `995` (POP3).  

   - Edit `/etc/dovecot/conf.d/10-ssl.conf` to ensure SSL/TLS is enabled:
     ```bash
     ssl = required
     ssl_cert = </etc/dovecot/private/dovecot.pem
     ssl_key = </etc/dovecot/private/dovecot.key
     ```
   - Make sure that the `ssl_cert` and `ssl_key` paths are valid and point to your SSL certificate and key.
     
####  **Configure SSL/TLS for Postfix**:
    - Postfix should be configured to use **SSL/TLS** for encrypted outgoing mail.
   - Edit `/etc/postfix/main.cf` with the following settings:
     ```bash
     smtp_tls_security_level = may
     smtpd_tls_security_level = may
     smtp_tls_cert_file = /etc/letsencrypt/live/nathabee.de/fullchain.pem
     smtp_tls_key_file = /etc/letsencrypt/live/nathabee.de/privkey.pem
     smtpd_tls_cert_file = /etc/letsencrypt/live/nathabee.de/fullchain.pem
     smtpd_tls_key_file = /etc/letsencrypt/live/nathabee.de/privkey.pem
     smtpd_tls_auth_only = yes
     ```
 
 
   - If you’re using Let's Encrypt certificates, make sure you set the correct file paths.

4. **Restart Services**:
   - After updating the configuration files, restart **Postfix** and **Dovecot** to apply the changes:
   ```bash
   sudo systemctl restart dovecot
   sudo systemctl restart postfix
   ```
