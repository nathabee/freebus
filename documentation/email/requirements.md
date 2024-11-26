# REQUIREMENTS

<!-- TOC -->
- [REQUIREMENTS](#requirements)
  - [configuration and installation overview](#configuration-and-installation-overview)
  - [Overview of Protocol Roles](#overview-of-protocol-roles)
    - [**Postfix (SMTP)**](#postfix-smtp)
    - [**Dovecot (LMTP)**](#dovecot-lmtp)
    - [**Dovecot (IMAP/POP3)**](#dovecot-imappop3)
    - [**TLS Encryption:**](#tls-encryption)
<!-- TOC END -->


**In the example bellow, we will install an emailing system for the domain nathabee.de**

To set up multiple email addresses that you can use to send and receive emails, you need:

1. **SMTP Server**: A way to **send** outgoing emails.
2. **Mailboxes**: A way to **receive** emails, which usually involves managing mailboxes for each email address.
3. **Email Aliases**: You might want aliases to forward emails, depending on how you manage multiple addresses.


If you want multiple email addresses like `evaluation@nathabee.de`, `freebus@nathabee.de`, and `admin@nathabee.de` (the latest will be forwarded to an external adresse) to support different applications hosted on your cloud, there are several implications for your setup, particularly in terms of configuring your **SMTP server** and managing **mailboxes**. Below, I will guide you on what changes you need to make to achieve this. 


## configuration and installation overview

**Summary of Actions that will be done :**

1. **Installed and Configured Postfix and OpenDKIM**:
   - Configured **Postfix** to use OpenDKIM for signing outgoing emails. 
   - Installed **OpenDKIM** and generated **DKIM keys**.

 
2. **DNS Menu**:
   - Set up an **MX Record** to point email traffic to `mail.nathabee.de`.
   - Set up an **A Record** to resolve `mail.nathabee.de` to your server's IP.
   - Set up a **TXT Record** for **SPF** to specify allowed senders.
   - Set up a **TXT Record** for **DKIM** to add a public key signature for outgoing emails.
   - Set up a **TXT Record** for **DMARC** to define a policy for failed email validation.

3. **Reverse DNS (rDNS)**:
   - Set the **PTR Record** for your cloud server IP to point to `mail.nathabee.de`.


4. **Install Dovecot**:
   - Dovecot will be used as the IMAP/POP3 server to manage your local mailboxes

 


## Overview of Protocol Roles

 

### **Postfix (SMTP)**
- **Role:** Handles the sending and receiving of emails via the Simple Mail Transfer Protocol (SMTP).
- **Inbound Mail:**
  - Postfix receives emails from external mail servers (e.g., Gmail, Outlook) over **SMTP (port 25)**.
  - After receiving an email, Postfix needs to deliver it to the correct local mailbox, which is handled by Dovecot using **LMTP**.
- **Outbound Mail:**
  - Postfix sends emails to external mail servers on behalf of authenticated users (clients or applications) using **SMTP (ports 587 )**.

---

### **Dovecot (LMTP)**
- **Role:** Manages local mail delivery and storage of emails in user mailboxes.
- **Postfix to Dovecot:**
  - **Protocol Used:** Local Mail Transfer Protocol (LMTP).
  - **Purpose:** Postfix hands over received emails to Dovecot via LMTP for storage in local directories (e.g., `/var/mail/vhosts/nathabee.de/username`).
  - **Why LMTP?** LMTP is lightweight, efficient, and natively supported by Dovecot for mail delivery.
- **Configuration:**
  - Postfix needs to be configured to use Dovecot's LMTP service, typically listening on a local Unix socket (e.g., `/var/spool/postfix/private/dovecot-lmtp`).

---

### **Dovecot (IMAP/POP3)**
- **Role:** Provides end-user access to emails stored in mailboxes.
- **Protocols Used:**
  - **IMAP (Internet Message Access Protocol):**
    - Allows users to access and manage their emails directly on the server.
    - Emails remain on the server, enabling multi-device synchronization.
    - Default Port: 143 (STARTTLS) or 993 (SSL/TLS).
  - **POP3 (Post Office Protocol):**
    - Allows users to download emails to their local device, often removing them from the server after download.
    - Default Port: 110 (STARTTLS) or 995 (SSL/TLS).
- **Client Applications:** Users connect to Dovecot via IMAP or POP3 using email clients like Thunderbird, Roundcube, or mobile apps.

---

#### **4. Summary of Protocol Responsibilities**

| **Component** | **Protocol**    | **Role**                                                             | **Default Ports**       |
|---------------|-----------------|----------------------------------------------------------------------|-------------------------|
| Postfix       | SMTP            | Sending/receiving emails to/from external servers or users.          | 25 (inbound), 587 (outbound) |
| Postfix       | LMTP            | Local mail delivery to Dovecot.                                      | Unix socket or TCP (e.g., 24) |
| Dovecot       | IMAP            | End-user access for reading/managing emails on the server.           | 143 (STARTTLS), 993 (SSL/TLS) |

not used in our configuration :
| Dovecot       | POP3            | End-user access for downloading emails to local devices.             | 110 (STARTTLS), 995 (SSL/TLS) |

---

###  **TLS Encryption:**
   - **STARTTLS** or **SSL/TLS** should be configured for all protocols (SMTP, IMAP, POP3, LMTP) to secure communication between clients, servers, and services.

 


![Email Diagram](png/emailArchitecture.png)
 