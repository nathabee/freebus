### REQUIREMENTS

<!-- TOC -->
    - [REQUIREMENTS](#requirements)
    - [Overview of Protocol Roles](#overview-of-protocol-roles)
<!-- TOC END -->


**In the example bellow, we will install an emailing system for the domain nathabee.de**

To set up multiple email addresses that you can use to send and receive emails, you need:

1. **SMTP Server**: A way to **send** outgoing emails.
2. **Mailboxes**: A way to **receive** emails, which usually involves managing mailboxes for each email address.
3. **Email Aliases**: You might want aliases to forward emails, depending on how you manage multiple addresses.


If you want multiple email addresses like `evaluation@nathabee.de`, `freebus@nathabee.de`, and `admin@nathabee.de` (the latest will be forwarded to an external adresse) to support different applications hosted on your cloud, there are several implications for your setup, particularly in terms of configuring your **SMTP server** and managing **mailboxes**. Below, I will guide you on what changes you need to make to achieve this. 


#### configuration and installation overview

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

 


### Overview of Protocol Roles

Let's clarify the relationship between **Postfix**, **Dovecot**, **IMAP**, **POP3**, and **LMTP**:

1. **Postfix to Dovecot**: 
   - **LMTP (Local Mail Transfer Protocol)** is used between **Postfix** and **Dovecot** to **deliver emails to local mailboxes**. This means Postfix uses LMTP to pass incoming mail to Dovecot so it can store it in the appropriate mailbox.
   - The configuration of **LMTP** allows Postfix to hand over messages that it receives to Dovecot, which then writes those messages into the correct local directory on the server.

2. **Dovecot to Users**:
   - **IMAP** or **POP3** is used by **clients** (like Thunderbird, Roundcube, or any mail application) to access the mailbox contents that **Dovecot** manages.
   - **IMAP** (`dovecot-imapd`) allows users to keep their emails on the server and access them from multiple devices.
   - **POP3** (`dovecot-pop3d`) is used when users want to **download** their emails to their local device and potentially remove them from the server.

Thus, **LMTP** is for **internal mail transfer** (Postfix to Dovecot), while **IMAP/POP3** is for **mail access by end users**.




![Email Diagram](png/emailArchitecture.png)
 