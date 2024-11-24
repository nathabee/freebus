# TLS security

<!-- TOC -->
- [TLS security](#tls-security)
  - [Configuration email client on the PC (Thunderbird)](#configuration-email-client-on-the-pc-thunderbird)
    - [**Incoming Server (POP3) Configuration**:](#incoming-server-pop3-configuration)
    - [**Outgoing Server (SMTP) Configuration**:](#outgoing-server-smtp-configuration)
  - [Configuration security on the server :](#configuration-security-on-the-server)
    - [**Open Necessary Ports**:](#open-necessary-ports)
    - [**Create certificate if necessary**:](#create-certificate-if-necessary)
    - [**Configure SSL/TLS for Dovecot**:](#configure-ssltls-for-dovecot)
    - [**Configure SSL/TLS for Postfix**:](#configure-ssltls-for-postfix)
    - [**Restart Services**:](#restart-services)
    - [Test](#test)
    - [Firewall and Port overview for the email service](#firewall-and-port-overview-for-the-email-service)
  - [Create certificate](#create-certificate)
  - [smtp and smtpd](#smtp-and-smtpd)
    - [**1. `smtp` (Client Role)**](#1-smtp-client-role)
    - [**2. `smtpd` (Server Role)**](#2-smtpd-server-role)
    - [**Key Differences Between `smtp` and `smtpd`**](#key-differences-between-smtp-and-smtpd)
    - [**Where They Fit in Your Configuration**](#where-they-fit-in-your-configuration)
    - [Example Usage Scenario](#example-usage-scenario)
<!-- TOC END -->


## Configuration email client on the PC (Thunderbird)

### **Incoming Server (POP3) Configuration**:
- **Server Type**: POP3
- **Server**: `nathabee.de`
- **Port**: `995` (SSL/TLS)
- **Connection Security**: SSL/TLS
- **Authentication Method**: Normal Password
- **Username**: `evaluation@nathabee.de` or `freebus@nathabee.de`

### **Outgoing Server (SMTP) Configuration**:
- **SMTP Server**: `nathabee.de`
- **Port**: `587` (STARTTLS) or `465` (SSL/TLS)
- **Connection Security**: STARTTLS or SSL/TLS
- **Authentication Method**: Normal Password
- **Username**: `evaluation@nathabee.de` or `freebus@nathabee.de`

## Configuration security on the server :
###  **Open Necessary Ports**:
make sure that the necessary ports are open on your server's **firewall** settings. In you Cloudprovider Console, you need to configure the **firewall settings** to allow the following:
   - Make sure the following ports are open in firewall settings:
     - IMAP: `993` (SSL/TLS)
     - POP3: `995` (SSL/TLS)
     - SMTP: `587` (STARTTLS) and `465` (SSL/TLS)

   These firewall settings will allow incoming connections for secure email access using Thunderbird or any other client.

- Port configuration is detailled in [**Firewall Configuration**:](#firewall-configuration-on-your-server-provider)

###  **Create certificate if necessary**:
 certificate configuration is detailled in [**Create certificate**:](#create-certificate)

###  **Configure SSL/TLS for Dovecot**:
    - In Dovecot, you need to enable **SSL/TLS** for secure connections on ports `993` (IMAP) and `995` (POP3).  

   - Edit `/etc/dovecot/conf.d/10-ssl.conf` to ensure SSL/TLS is enabled:
     ```bash
     ssl = required
     ssl_cert = </etc/letsencrypt/live/mail.nathabee.de/fullchain.pem
     ssl_key = </etc/letsencrypt/live/mail.nathabee.de/privkey.pem
     ```
   - Make sure that the `ssl_cert` and `ssl_key` paths are valid and point to your SSL certificate and key.
     
###  **Configure SSL/TLS for Postfix**:
  - Postfix should be configured to use **SSL/TLS** for encrypted outgoing mail.
  - Edit `/etc/postfix/main.cf` with the following settings:
```bash
smtp_tls_security_level = may
smtpd_tls_security_level = encrypt
smtp_tls_cert_file = /etc/letsencrypt/live/nathabee.de/fullchain.pem
smtp_tls_key_file = /etc/letsencrypt/live/nathabee.de/privkey.pem
smtpd_tls_cert_file = /etc/letsencrypt/live/nathabee.de/fullchain.pem
smtpd_tls_key_file = /etc/letsencrypt/live/nathabee.de/privkey.pem
smtpd_tls_auth_only = yes
```
 


  **SMTP Authentication for Clients (Port 587)**: Ensure that you have **port 587** configured in `/etc/postfix/master.cf` for clients to send mail securely with TLS. Here's a typical example:
  ```bash
  submission inet n       -       n       -       -       smtpd
    -o syslog_name=postfix/submission
    -o smtpd_tls_security_level=encrypt
    -o smtpd_sasl_auth_enable=yes
    -o smtpd_client_restrictions=permit_sasl_authenticated,reject
  ```

   - If you’re using Let's Encrypt certificates, make sure you set the correct file paths.


###  **Restart Services**:
   - After updating the configuration files, restart **Postfix** and **Dovecot** to apply the changes:
   ```bash
   # if necessary sometime we need to destroy the socker before restart
   sudo rm  /var/spool/postfix/private/dovecot-lmtp

   sudo systemctl restart dovecot
   sudo systemctl restart postfix
   ```


### Test


After restarting, it’s a good idea to verify that everything is working as expected:

1. **Test Incoming and Outgoing Connections**:
   - Use an email client (e.g., **Thunderbird**) to make sure you can send and receive emails securely using **SSL/TLS**.
   - Configure **IMAP (port 993)** or **POP3 (port 995)** for incoming, and **SMTP (port 587)** for outgoing emails.

2. **Check Logs**:
   - If there are issues, you can look at the logs for clues:
     - **Postfix Logs**: `/var/log/mail.log`
     - **Dovecot Logs**: `/var/log/dovecot.log`

3. **Use OpenSSL to Test the Connection**:
   You can also use **openssl** to verify the secure connection to your mail server:
   ```bash
   openssl s_client -connect mail.nathabee.de:587 -starttls smtp
   ```
   This will check if the SMTP server supports **STARTTLS** and that the certificate is served correctly.


### Firewall and Port overview for the email service

#### **Understanding Ingress and Egress in Email Configuration**

- **Ingress (Incoming Traffic)**: 
  - Ingress refers to traffic **coming into** your server from an external client or service.
  - You need to configure ingress rules for **all the ports** that your users or other mail servers need to **connect to your server**.

- **Egress (Outgoing Traffic)**:
  - Egress refers to traffic **going out** of your server to external servers or services.
  - You need to configure egress rules for ports that your server uses to **initiate connections to the outside**.

#### SMTP Traffic and Why You Need Both Ingress and Egress

##### 1. **SMTP (Simple Mail Transfer Protocol) Outgoing - Egress**
- **Sending Emails to Other Servers**: When your mail server sends emails to recipients on other mail servers (like Gmail or Yahoo), your server is the **initiator** of the connection. This is an **egress** action because your server is sending traffic to the outside world.
- **Port 25**: Typically, SMTP uses **Port 25** for outgoing communication between mail servers.

For this purpose, you need to have an **egress firewall rule** that allows your server to connect to **port 25** on external mail servers.

##### 2. **SMTP for Email Clients to Submit Emails - Ingress**
- **Clients Sending Mail to Your Server**: When **users or clients** (like Thunderbird) send email, they need to send that email **to your server** first. This is considered **incoming (ingress)** traffic because your mail server is receiving the request.
- **Port 587 (STARTTLS)** and **Port 465 (SSL/TLS)**: These ports are used for email **submission** by clients. Typically:
  - **Port 587** is used for clients to submit email with **STARTTLS** encryption.
  - **Port 465** is used for clients to submit email using **SSL/TLS**.

You need to have an **ingress firewall rule** that allows clients to connect to your server on **Port 587 or 465** so that your server can accept emails from clients for onward delivery.

#### Summary of Why You Need Both Directions for SMTP:
- **Outgoing (Egress)**: Your mail server sends messages **to other servers** (e.g., when your users send email to Gmail or Yahoo).
  - **Port 25** needs to be open for outgoing SMTP communication.
  
- **Incoming (Ingress)**: Your server **accepts emails from users** or clients when they are submitting email to send out.
  - **Port 587** or **Port 465** needs to be open for clients like Thunderbird to connect to your server to submit an email.

#### **Firewall Configuration on your server provider**

1. **Ingress Rules (Incoming)**
   - **Allow Incoming Client Connections**:
     - **IMAP SSL** (Port 993, **TCP**): For secure incoming email retrieval.
     - **POP3 SSL** (Port 995, **TCP**): For secure incoming email retrieval.
     - **SMTP Submission** (Port 587, **TCP**): For clients submitting email with STARTTLS.
     - **SMTP Submission** (Port 465, **TCP**): For clients submitting email with SSL/TLS.

     - (Optional) **Webmail**:
       - **Port 80** (HTTP), Protocol **TCP**.
       - **Port 443** (HTTPS), Protocol **TCP**.

2. **Egress Rules (Outgoing)**
   - **Allow Outgoing Mail Delivery**:
     - **SMTP (Port 25, TCP)**: Allow your server to send outgoing mail to other servers.


##  Create certificate

0. certificate storage : in **`/etc/letsencrypt/live/mail.nathabee.de/`**:
   - This contains **symbolic links** to the actual certificate files.
   - This makes it easier to reference the latest certificates in your configuration files. Certbot automatically updates these symbolic links whenever the certificate is renewed.

   Files in this directory include:
   - **`privkey.pem`**: The private key for the certificate.
   - **`fullchain.pem`**: The certificate chain that most server software uses.
   - **`chain.pem`**: The CA chain, often used for OCSP stapling.
   - **`cert.pem`**: The end-entity certificate itself. In most configurations, it's better to use `fullchain.pem`.
 
     ```bash
     sudo certbot certonly --standalone -d nathabee.de -d mail.nathabee.de
     ``` 

  this create a unique  certificate for nathabee.de and mail.nathabee.de
  and it is stored in /etc/letsencrypt/live/nathabee.de/

  remarque : we could have created a differente certifcate for mail.nathabee.de , in this case you must reference this certificate  /etc/letsencrypt/live/mail.nathabee.de/ in the configuration files




## smtp and smtpd

The terms **`smtp`** and **`smtpd`** refer to two different roles that **Postfix** performs in the mail delivery process. Both are related to handling **SMTP (Simple Mail Transfer Protocol)**, but they have distinct responsibilities. Let’s break down the difference:

### **1. `smtp` (Client Role)**
- **Purpose**: The **`smtp`** component in **Postfix** is responsible for **sending outgoing email** to **other mail servers**. This means it acts as an **SMTP client**.
- **Role**: When **Postfix** sends an email to another mail server (like Gmail or Yahoo), the **smtp** process is used. This happens after Postfix has decided that the email is ready to be delivered to the final destination.
- **Example Usage**: When your server is delivering an email sent by a user to an external recipient, it will use the `smtp` client to contact the recipient’s mail server.
- **Configuration Directives**: These settings control how Postfix behaves as an **SMTP client** when delivering outbound mail.
  - `smtp_tls_cert_file`: Specifies the certificate file used for outgoing mail encryption.
  - `smtp_tls_security_level = may`: Sets how Postfix behaves regarding TLS when delivering email. The **`may`** value means Postfix will use TLS if the receiving server supports it.

**In Summary**: 
- **`smtp`** in the Postfix configuration refers to how your server **sends** email **to other servers**.
- It acts as an **SMTP client**.
- **Configuration Example**: `smtp_tls_security_level`, `smtp_tls_cert_file`, etc.

### **2. `smtpd` (Server Role)**
- **Purpose**: The **`smtpd`** component in **Postfix** is responsible for **receiving incoming email** from other servers or from clients. It acts as an **SMTP server** (the **d** in `smtpd` stands for **daemon**).
- **Role**: This process handles **inbound email**. It receives messages that are coming from other servers or from authenticated users (like when you send an email using Thunderbird or an email client). `smtpd` listens on the standard SMTP ports (`25`, `587`, `465`).
- **Example Usage**: When someone sends an email to your domain (`nathabee.de`), the **smtpd** daemon listens for incoming SMTP connections and handles those messages, ensuring they are correctly accepted and processed.
- **Configuration Directives**: These settings control how Postfix behaves as an **SMTP server** for incoming email.
  - `smtpd_tls_cert_file`: Specifies the certificate used for incoming mail encryption.
  - `smtpd_tls_auth_only = yes`: Only allows authentication over a secure TLS connection.
  - `smtpd_relay_restrictions`: Controls who is allowed to relay mail through your server.

**In Summary**:
- **`smtpd`** refers to how your server **receives** email from other mail servers or email clients.
- It acts as an **SMTP server**.
- **Configuration Example**: `smtpd_tls_cert_file`, `smtpd_tls_security_level`, etc.

### **Key Differences Between `smtp` and `smtpd`**

| **Aspect**                    | **`smtp` (Client Role)**                      | **`smtpd` (Server Role)**                           |
|-------------------------------|----------------------------------------------|----------------------------------------------------|
| **Role**                      | Sends outgoing email to other servers        | Receives incoming email from other servers/clients |
| **Acts As**                   | SMTP **client**                              | SMTP **server** (daemon)                           |
| **Ports Typically Used**      | Any (initiated by Postfix)                   | 25, 587 (submission), 465 (submission over SSL)    |
| **TLS/SSL Configuration**     | `smtp_tls_*` settings (e.g., `smtp_tls_cert_file`) | `smtpd_tls_*` settings (e.g., `smtpd_tls_cert_file`) |
| **Example Scenario**          | Your server sends an email to Gmail          | Another server sends an email to `nathabee.de`     |
| **Example Configuration**     | `smtp_tls_security_level = may`              | `smtpd_relay_restrictions = permit_mynetworks ...` |

### **Where They Fit in Your Configuration**
- **Incoming Mail** (Handled by `smtpd`):
  - When an email is received by your mail server from another mail server (for instance, someone sending mail to `freebus@nathabee.de`), `smtpd` takes care of the incoming connection.
  - This component is also involved when users send email through your server using their email clients (e.g., **Thunderbird**). In that case, they connect to your server's **submission** port (587), which is also managed by `smtpd`.

- **Outgoing Mail** (Handled by `smtp`):
  - Once an email is processed and needs to be delivered to another recipient, Postfix uses the `smtp` client to connect to the recipient’s mail server.
  - The **`smtp`** client handles how email is sent out to the world from your server, including securely delivering it using **TLS** if supported by the recipient.

### Example Usage Scenario
1. **A User Sends an Email**:
   - A user (e.g., you on Thunderbird) sends an email to someone outside your domain.
   - Thunderbird connects to **port 587** (`submission`), and `smtpd` handles this connection.
   - The email is accepted by your server and queued for delivery.

2. **Postfix Delivers the Email**:
   - Postfix then uses its **smtp** client role to deliver the message to the recipient’s mail server (e.g., `gmail.com`).
   - This outgoing connection is managed by the `smtp` component.
