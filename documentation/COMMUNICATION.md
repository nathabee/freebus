
# Notifications and Communication

<!-- TOC -->
- [Notifications and Communication](#notifications-and-communication)
  - [Installing an EMAILING system on a server](#installing-an-emailing-system-on-a-server)
    - [REQUIREMENTS](#requirements)
    - [Setting Up an SMTP Server Postfix](#setting-up-an-smtp-server-postfix)
    - [Using Aliases for Forwarding](#using-aliases-for-forwarding)
    - [DKIM](#dkim)
    - [Authentication and Security](#authentication-and-security)
    - [Receiving Emails in Mailboxes ](#receiving-emails-in-mailboxes)
    - [Install Dovecot](#install-dovecot)
    - [Configure Dovecot for Virtual Mailboxes](#configure-dovecot-for-virtual-mailboxes)
    - [Configure Postfix to Deliver Emails to Dovecot](#configure-postfix-to-deliver-emails-to-dovecot)
    - [Testing the Setup](#testing-the-setup)
    - [Accessing the Mailboxes](#accessing-the-mailboxes)
    - [Summary](#summary)
  - [Test Email Configuration](#test-email-configuration)
    - [Sending a Test Email from the Command Line](#sending-a-test-email-from-the-command-line)
    - [Use Online Tools to Test SPF, DKIM, and DMARC](#use-online-tools-to-test-spf-dkim-and-dmarc)
    - [Verify DNS Records Using MXToolbox](#verify-dns-records-using-mxtoolbox)
    - [Check the Mail Log on Your Server](#check-the-mail-log-on-your-server)
    - [Send Email to Common Providers example Gmail](#send-email-to-common-providers-example-gmail)
    - [Common Troubleshooting Tips](#common-troubleshooting-tips)
    - [Summary](#summary)
  - [Configure Django to Use Postfix](#configure-django-to-use-postfix)
    - [Configure Django to Use Postfix](#configure-django-to-use-postfix)
    - [Test Sending Emails](#test-sending-emails)
<!-- TOC END -->




## Installing an EMAILING system on a server

### REQUIREMENTS

**In the example bellow, we will install an emailing system for the domain nathabee.de**

To set up multiple email addresses that you can use to send and receive emails, you need:

1. **SMTP Server**: A way to **send** outgoing emails.
2. **Mailboxes**: A way to **receive** emails, which usually involves managing mailboxes for each email address.
3. **Email Aliases**: You might want aliases to forward emails, depending on how you manage multiple addresses.


If you want multiple email addresses like `evaluation@nathabee.de`, `freebus@nathabee.de`, and `admin@nathabee.de` (the latest will be forwarded to an external adresse) to support different applications hosted on your cloud, there are several implications for your setup, particularly in terms of configuring your **SMTP server** and managing **mailboxes**. Below, I will guide you on what changes you need to make to achieve this. 

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

 



![Email Diagram](https://nathabee.de/freebus/blob/main/documentation/png/emailArchitecture.png)

 

Here are the components that you need to configure in more detail:

### Setting Up an SMTP Server Postfix

You can use **Postfix** as your SMTP server to manage outgoing emails. Here's what you'll need to do:

1. **Install Postfix**:
   ```bash
   sudo apt-get update
   sudo apt-get install postfix
   ```
   
2. **Configure Postfix for Multiple Domains and Addresses**:
   - Postfix can be configured to send emails on behalf of multiple addresses (`evaluation@nathabee.de`, `freebus@nathabee.de`, etc.).
   - Edit `/etc/postfix/main.cf` to set up your domain:
     ```
     myhostname = mail.nathabee.de
     mydomain = nathabee.de
     myorigin = $mydomain
     inet_interfaces = all
     mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
     ```
   - **Virtual Mailboxes**: If you want to have multiple email addresses, you should use **virtual mailboxes**. This allows you to manage many email addresses (`evaluation`, `freebus`, etc.) without creating system users for each email.

3. **Setting Up Virtual Mailboxes**:
   - You need to add virtual mailbox support in **Postfix**.
   - Edit `/etc/postfix/main.cf` and add:
     ```
     virtual_alias_domains = nathabee.de
     virtual_alias_maps = hash:/etc/postfix/virtual
     ```
   - Create or edit `/etc/postfix/virtual`:
     ```
     evaluation@nathabee.de    evaluation_mailbox  ### not that to correct
     freebus@nathabee.de       freebus_mailbox  ## not that to correct
     ```
   - **Map mailboxes to folders**: After editing the virtual file, run:
     ```bash
     postmap /etc/postfix/virtual
     ```
   - **Reload Postfix**:
     ```bash
     sudo systemctl restart postfix
     ```

      

   - **add in /etc/hosts**:
     ```bash
      127.0.0.1 mail.nathabee.de
     ```



### Using Aliases for Forwarding

If you don't need individual mailboxes for each address and just want emails to be **forwarded** to a single address (like an admin’s email):

1. **Edit `/etc/postfix/virtual`** to create aliases:
   ``` 
   admin@nathabee.de        <my email admin>@gmail.com  # Forward to an external address
   ```
2. **Postmap** and **Reload Postfix** as before:
   ```bash
   postmap /etc/postfix/virtual
   sudo systemctl reload postfix
   ```
This way, you can receive all application-specific emails in a single admin mailbox.


### DKIM

Now that you've set up **Postfix**, the **DNS records (A, MX, SPF, DMARC)**, the next step is to configure **DKIM (DomainKeys Identified Mail)** using **OpenDKIM** to sign outgoing emails. This will add a layer of authenticity to your emails and help prevent them from being flagged as spam. Additionally, I'll explain how to create a **PTR record (Reverse DNS)** for your server's IP address, which is also crucial for good email deliverability.

Let's start with **OpenDKIM** for DKIM, followed by configuring the **PTR record**.

#### Setting Up DKIM Using OpenDKIM

**OpenDKIM** is an open-source implementation of DKIM that integrates well with **Postfix**. DKIM adds a digital signature to outgoing emails, which can be verified by the recipient's email server to ensure the authenticity of the email.

#### Step-by-Step Guide to Setting Up OpenDKIM

##### Step 1: Install OpenDKIM
First, install **OpenDKIM** and **OpenDKIM tools**:

```bash
sudo apt-get update
sudo apt-get install opendkim opendkim-tools
```

##### Step 2: Configure OpenDKIM

1. **Edit the OpenDKIM Configuration** (`/etc/opendkim.conf`):

   Open the **OpenDKIM** configuration file in your preferred editor:
   ```bash
   sudo nano /etc/opendkim.conf
   ```
   
   Make sure the following lines are set (add them if they’re not present):
   ```bash
   AutoRestart             Yes
   AutoRestartRate         10/1h
   Syslog                  Yes
   SyslogSuccess           Yes
   LogWhy                  Yes

   UMask                   002

   Domain                  nathabee.de
   KeyFile                 /etc/opendkim/keys/nathabee.de/default.private
   Selector                default
   Mode                    sv
   SubDomains              Yes

   Socket                  inet:12301@localhost
   OversignHeaders         From
   ```

   **Explanation**:
   - **Domain**: Specifies your domain name (`nathabee.de`).
   - **KeyFile**: Path to the private key that will be used for signing emails.
   - **Selector**: `default` is used as the selector, which is a way to identify the DKIM key.
   - **Socket**: This tells **OpenDKIM** how to communicate with **Postfix**. It listens on port `12301` on localhost.

##### Step 3: Integrate OpenDKIM with Postfix

1. **Create a Socket Directory** for OpenDKIM to communicate with Postfix:

   ```bash
   sudo mkdir -p /var/spool/postfix/opendkim
   sudo chown opendkim:opendkim /var/spool/postfix/opendkim
   ```

2. **Configure the Socket for OpenDKIM**:
   
   Edit `/etc/default/opendkim`:
   ```bash
   sudo nano /etc/default/opendkim
   ```

   Find the `SOCKET` line and change it to:

   ```bash
   SOCKET="inet:12301@localhost"
   ```

##### Step 4: Generate DKIM Keys

1. **Create the Key Directory**:

   ```bash
   sudo mkdir -p /etc/opendkim/keys/nathabee.de
   ```

2. **Generate the DKIM Key**:

   ```bash
   sudo opendkim-genkey -b 2048 -d nathabee.de -D /etc/opendkim/keys/nathabee.de -s default -v
   ```

   **Explanation**:
   - **`-b 2048`**: Specifies the key length.
   - **`-d nathabee.de`**: Your domain name.
   - **`-D /etc/opendkim/keys/nathabee.de`**: Directory where keys will be saved.
   - **`-s default`**: Selector name.

   This command will create two files in `/etc/opendkim/keys/nathabee.de`:
   - **`default.private`**: This is your private DKIM key.
   - **`default.txt`**: This contains the public key that you will add to your **DNS**.

3. **Set Permissions** for the Keys:

   ```bash
   sudo chown opendkim:opendkim /etc/opendkim/keys/nathabee.de/default.private
   sudo chmod 400 /etc/opendkim/keys/nathabee.de/default.private
   ```

##### Step 5: Add Public Key to DNS

1. **View the Contents of the `default.txt` File**:

   ```bash
   cat /etc/opendkim/keys/nathabee.de/default.txt
   ```

   You should see something like:
   ```
   default._domainkey IN TXT "v=DKIM1; k=rsa; p=MIIBIjANBgkq..." ; ----- DKIM key default for nathabee.de
   ```

2. **Add the DKIM Record to Your DNS**:

   - **Type**: TXT
   - **Name**: `default._domainkey`
   - **Value**: Everything inside the quotes (`"v=DKIM1; k=rsa; p=MIIBIjANBgkq..."`)

   This record needs to be added via the **YourCloudProvider DNS console** to associate your domain (`nathabee.de`) with this key.

##### Step 6: Configure Postfix to Use OpenDKIM

1. **Edit Postfix Configuration** (`/etc/postfix/main.cf`):

   ```bash
   sudo nano /etc/postfix/main.cf
   ```

2. **Add the Following Lines** to Integrate OpenDKIM:

   ```bash
   milter_default_action = accept
   milter_protocol = 6
   smtpd_milters = inet:localhost:12301
   non_smtpd_milters = inet:localhost:12301
   ```

##### Step 7: Restart Services

1. **Restart OpenDKIM and Postfix**:

   ```bash
   sudo systemctl restart opendkim
   sudo systemctl restart postfix
   ```

2. **Verify That OpenDKIM is Running**:

   You can verify if the services are up and running by checking their statuses:

   ```bash
   sudo systemctl status opendkim
   sudo systemctl status postfix
   ```


 
### Authentication and Security

To ensure the email setup is **secure**:

1. **TLS Encryption**:
   - Configure **Postfix** and **Dovecot** to use **TLS** encryption to secure emails in transit.
   - Obtain an **SSL certificate** (using **Let's Encrypt**, for example) and configure Postfix and Dovecot to use it.

2. **SPF, DKIM, DMARC**:
   - Set up **SPF**, **DKIM**, and **DMARC** in your DNS settings (via YourCloudProvider's DNS console) to authenticate your outgoing emails and improve their deliverability.
   - SPF ensures that only your server is authorized to send emails for your domain.
   - DKIM adds a signature to the email header that verifies its authenticity.
   - DMARC helps receiving servers decide what to do if emails fail SPF or DKIM checks.

To set up email addresses like `evaluation@nathabee.de`, `freebus@nathabee.de`, and `admin@nathabee.de` on your YourCloudProvider cloud instance using your domain (`nathabee.de`), you'll need to configure certain aspects within the **YourCloudProvider console**, specifically in the **DNS** management section. This configuration will ensure that:

- Emails are routed to your server.
- Emails sent from your server are authenticated properly to prevent them from being marked as spam.

Here's a breakdown of what exactly you should do within the YourCloudProvider console:

#### Step-by-Step DNS Configuration Using the YourCloudProvider Console

1. **Log in to Your YourCloudProvider Console**:
   - Log in to YourCloudProvider's cloud console at [console.YourCloudProvider.cloud](https://console.YourCloudProvider.cloud/).
   - Go to the **DNS** section where you manage your domain (`nathabee.de`).

2. **Add an MX Record (Mail Exchange Record)**:
   - **Purpose**: The MX record is used to direct emails for your domain (`nathabee.de`) to your mail server.
   - **What to Do**:
     1. Add an **MX Record** to your domain settings in the YourCloudProvider console.
     2. Use the IP address or the hostname of your YourCloudProvider cloud server as the destination.
     3. Example setup:
        - **Type**: MX
        - **Host**: `@` (represents the root domain, `nathabee.de`)
        - **Value**: `mail.nathabee.de` (this should point to your server where Postfix is running)
        - **Priority**: `10` (use a low value like `10` to make this server a primary email handler)

   - You can create multiple MX records if you have multiple mail servers for failover purposes.

3. **Add an A Record for Your Mail Server**:
   - **Purpose**: Point `mail.nathabee.de` to the correct IP address of your server.
   - **What to Do**:
     1. Add an **A Record** that associates `mail.nathabee.de` with the IP address of your cloud instance.
     2. Example setup:
        - **Type**: A
        - **Host**: `mail`
        - **Value**: `<your-server-ip>` (IP address of your YourCloudProvider cloud instance)
   - This will make `mail.nathabee.de` resolve to your YourCloudProvider cloud server, which is crucial for routing email traffic.

4. **Add an SPF Record (Sender Policy Framework)**:
   - **Purpose**: SPF helps prevent spammers from sending unauthorized emails on behalf of your domain. This tells recipient servers which IP addresses are allowed to send emails on behalf of `nathabee.de`.
   - **What to Do**:
     1. Add a **TXT Record** to specify which servers are allowed to send mail.
     2. Example setup:
        - **Type**: TXT
        - **Host**: `@`
        - **Value**: `"v=spf1 ip4:<your-server-ip> -all"`
        - Replace `<your-server-ip>` with the actual IP address of your YourCloudProvider cloud server.
        - The `-all` part indicates that only the listed IP address is allowed to send email, and all others should be rejected.

5. **Add a DKIM Record (DomainKeys Identified Mail)**:
   - **Purpose**: DKIM adds a digital signature to your outgoing emails, helping recipients verify that the email was sent by you and has not been altered.
   - **What to Do**:
     - After setting up DKIM on your mail server (e.g., with `opendkim`), you will get a **public key** that needs to be added to your DNS.
     - Add a **TXT Record** to the DNS configuration in the YourCloudProvider console:
       - **Type**: TXT
       - **Host**: `default._domainkey`
       - **Value**: `"v=DKIM1; k=rsa; p=<your-public-key-here>"` (replace `<your-public-key-here>` with the actual public key generated on your server)

6. **Add a DMARC Record**:
   - **Purpose**: DMARC tells email receivers what to do if an email fails SPF and/or DKIM checks, providing more information on the legitimacy of emails.
   - **What to Do**:
     1. Add a **TXT Record** for DMARC:
        - **Type**: TXT
        - **Host**: `_dmarc`
        - **Value**: `"v=DMARC1; p=none; rua=mailto:dmarc-reports@nathabee.de"`
        - The **`p=none`** setting means that failed messages will still be delivered but flagged. You can adjust this setting to `reject` or `quarantine` later, once you're confident in the setup.
 
7. **Reverse DNS (rDNS/PTR Record)**:
   - **Purpose**: Reverse DNS is important to prevent your outgoing emails from being marked as spam. It associates your server IP address with a hostname (`mail.nathabee.de`).
   - **What to Do**:
     - In the YourCloudProvider console, look for the **Reverse DNS** or **rDNS** section for your cloud server.
     - Set the **PTR record** for your server IP to point to `mail.nathabee.de`.


A **PTR Record** (Reverse DNS) maps your **IP address** back to a **hostname**, which is the opposite of what an **A record** does. Configuring a **PTR record** is crucial for email servers because many receiving mail servers check for a PTR record as an anti-spam measure.



##### Step-by-Step Guide to Setting Up PTR (Reverse DNS):

1. **Log in to YourCloudProvider Console**:

   - Log in to your YourCloudProvider account where you manage your **cloud server**.
 
2. **Select Your Server**:
   - In the dashboard, locate and click on the server for which you want to set the PTR record.

3. **Navigate to Networking Settings**:
   - Click on the "Networking" tab or section associated with your selected server.

4. **Edit the Reverse DNS Entry**:
   - You'll see a list of your server's IP addresses.
   - Next to the IP address you wish to configure, there should be an option to edit the Reverse DNS (rDNS) entry.
   - Click on the edit icon or link.

5. **Set the PTR Record**:
   - Enter the Fully Qualified Domain Name (FQDN) you want the IP address to resolve to, such as `mail.nathabee.de`.
   - Save or apply the changes.


####  Other consideration
 **SSL/TLS Certificates for Secure Email**:
   - **Purpose**: To secure email traffic, Postfix should be configured to use SSL/TLS certificates.
   - **What to Do**:
     - Obtain an SSL certificate for `mail.nathabee.de`. You can use **Let’s Encrypt** (free SSL certificate provider).
     - Use this SSL certificate in your Postfix and Dovecot configurations for secure connections.

**Email Address Management**:
   - **Aliases vs. Virtual Mailboxes**:
     - You can use **virtual mailboxes** to create independent mailboxes for `evaluation@nathabee.de`, `freebus@nathabee.de`, and `admin@nathabee.de`. This requires you to set up mail folders for each address.
     - Alternatively, you can use **aliases** to forward all emails to a single admin inbox, simplifying the management.

**Webmail Access (Optional)**:
   - You can use **Roundcube** or similar software to provide webmail access for `evaluation`, `freebus`, `admin`, etc.
   - This webmail can be installed on your YourCloudProvider cloud instance and provide an interface where you can access all configured mailboxes.


---



4. **Storing Emails**:
   - If you want to **store** received emails for each address, you need a tool like **Dovecot** or another **IMAP/POP3 server** to manage incoming mailboxes.
   - **Dovecot** can be used alongside Postfix to store received mail in virtual mailboxes, making it accessible through a webmail interface or any email client (Thunderbird, Outlook, etc.).
   ##### Step 8: Test Your DKIM Setup

1. **Send a Test Email** to verify DKIM is working:
   - Send an email to a DKIM verification tool like **mail-tester.com** or **dkimvalidator.com**.
   - They will analyze your email headers and confirm if DKIM is correctly set up.


### Receiving Emails in Mailboxes 


#### Objective Configure MailBox with Dovecot

To **receive emails** and manage mailboxes, you need an **IMAP/POP3 server** like **Dovecot**:


Set up **Dovecot** to handle your **local mailboxes** (`evaluation_mailbox` and `freebus_mailbox`), and the forwarding setup (`admin@nathabee.de` redirects to `<nathabee>@gmail.com`). By the end of this, you will be able to receive emails locally and provide an interface for users to access those emails.

- **Email Addresses**:
  - **evaluation@nathabee.de** and **freebus@nathabee.de** will be stored locally in **mailboxes**.
  - **admin@nathabee.de** will be **redirected** to `<nathabee>@gmail.com`.

- in /etc/postfix/virtual 
     ```
evaluation@nathabee.de    nathabee.de/evaluation/
freebus@nathabee.de       nathabee.de/freebus/
admin@nathabee.de         <nathabee>@gmail.com   <your extern email>
     ```



- **Folder Structure**:
   - Dovecot can create mail folders for each user address, such as:
     ```
     /var/mail/vhosts/nathabee.de/evaluation/
     /var/mail/vhosts/nathabee.de/freebus/
     /var/mail/vhosts/nathabee.de/admin/
     ```

- **Accessing Emails**:
   - You can access these mailboxes via **webmail** (using software like **Roundcube**) or via an email client (e.g., Thunderbird) using **IMAP** or **POP3**.
   - **Webmail**: Install **Roundcube** on your server if you want to provide a web interface for accessing emails.



### Install Dovecot

**Dovecot** will be used as the **IMAP/POP3** server to manage your local mailboxes. This will allow you to access your emails using a **webmail interface** or **email clients** like **Thunderbird**.

Run the following command to install Dovecot:

```bash
sudo apt-get update
sudo apt-get install dovecot-imapd dovecot-pop3d
```

- **dovecot-imapd**: Adds IMAP support so you can access mailboxes remotely (e.g., using Thunderbird).
- **dovecot-pop3d**: Adds POP3 support if you want to download mail to your client and remove it from the server.

### Configure Dovecot for Virtual Mailboxes

Dovecot needs to be configured to handle the **virtual users** and their mailboxes.

#### Step 2.1: Edit `/etc/dovecot/dovecot.conf`

Open the Dovecot configuration file in a text editor:

```bash
sudo nano /etc/dovecot/dovecot.conf
```

Make sure you have the following settings:

- **Enable protocols**:
  ```bash
  protocols = imap pop3
  ```

This line enables both **IMAP** and **POP3** so that users can choose how they wish to access their emails.

#### Step 2.2: Edit `/etc/dovecot/conf.d/10-mail.conf`

This configuration file specifies the mail location for Dovecot.

1. Open the file:

   ```bash
   sudo nano /etc/dovecot/conf.d/10-mail.conf
   ```

2. Set the **mail location** to point to your virtual mailbox directory. Add or modify the following line:

   ```bash
   mail_location = maildir:/var/mail/vhosts/%d/%n
   ```

   **Explanation**:
   - **`%d`**: Domain part of the email address (`nathabee.de`).
   - **`%n`**: Local part of the email address (e.g., `evaluation` or `freebus`).

   This setting tells Dovecot to store emails in the `/var/mail/vhosts` directory under folders named after the domain and the local part of the email address.

#### Step 2.3: Configure Authentication for Virtual Users

1. **Edit `/etc/dovecot/conf.d/10-auth.conf`**:

   ```bash
   sudo nano /etc/dovecot/conf.d/10-auth.conf
   ```

2. Make sure the `auth_mechanisms` setting includes `plain`:

   ```bash
   auth_mechanisms = plain login
   ```

   This allows Dovecot to authenticate users using **plain text** (secure when using SSL/TLS).

3. Uncomment the following line to enable the use of a password file for authentication:

   ```bash
   !include auth-passwdfile.conf.ext
   ```

4. **Create a password file** at `/etc/dovecot/passwd`:

   - Add virtual users to this file:

     ```bash
     sudo nano /etc/dovecot/passwd
     ```

     - Add entries for `evaluation` and `freebus`:

       ```
       evaluation@nathabee.de:{plain}yourpassword1
       freebus@nathabee.de:{plain}yourpassword2
       ```

   - **Permissions**:

     ```bash
     sudo chmod 600 /etc/dovecot/passwd
     sudo chown dovecot:dovecot /etc/dovecot/passwd
     ```

   **Note**: Replace `yourpassword1` and `yourpassword2` with secure passwords.

5. **Configure the User Database** (`/etc/dovecot/conf.d/auth-static.conf.ext`):

   Open the file:

   ```bash
   sudo nano /etc/dovecot/conf.d/auth-static.conf.ext
   ```

   - Add the following configuration to specify where users' home directories and mail directories are located:

     ```bash
     passdb {
       driver = passwd-file
       args = /etc/dovecot/passwd
     }

     userdb {
       driver = static
       args = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n
     }
     ```

   **Explanation**:
   - **`uid=vmail`** and **`gid=vmail`**: Ensures that Dovecot is running with appropriate permissions.
   - The **home directory** for each user is set to their respective folder within `/var/mail/vhosts`.

6. **Verify LMTP Delivery with Dovecot**
Ensure Dovecot is correctly set up to accept LMTP delivery from Postfix. Check the Dovecot LMTP configuration:


   Open the file:

   ```bash
   sudo nano /etc/dovecot/conf.d/10-master.conf

   ```

   - Add the following configuration  :

     ```bash
     service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
         mode = 0600
         user = postfix
         group = postfix
      }
      }

   ```


7.  Create the `vmail` User and Group

You can create a user named `vmail` with the following commands:

1. **Create the `vmail` Group**:

   ```bash
   sudo groupadd -g 5000 vmail
   ```

   - **`-g 5000`**: This assigns a specific group ID (you can use any number that doesn’t conflict with existing group IDs).
   - **`vmail`**: The name of the group.

2. **Create the `vmail` User**:

   ```bash
   sudo useradd -m -d /var/mail -u 5000 -g vmail -s /usr/sbin/nologin vmail
   ```

   - **`-m`**: Creates a home directory for the user.
   - **`-d /var/mail`**: Specifies the home directory for the user (`/var/mail`).
   - **`-u 5000`**: Assigns the user ID (again, you can use another number if `5000` is already taken).
   - **`-g vmail`**: Sets the **primary group** for the user (`vmail`).
   - **`-s /usr/sbin/nologin`**: Specifies that this user **cannot log in** to the system. This is a security measure since `vmail` is just used for mail handling, not for logging in.



#### Step 2.4: Create the Mail Directory Structure

Create the directories for your virtual mailboxes:

```bash
sudo mkdir -p /var/mail/vhosts/nathabee.de/evaluation
sudo mkdir -p /var/mail/vhosts/nathabee.de/freebus
```

Set permissions:

```bash
sudo chown -R vmail:vmail /var/mail/vhosts
sudo chmod -R 770 /var/mail/vhosts
```

### Configure Postfix to Deliver Emails to Dovecot

For **Postfix** to deliver emails to the correct virtual mailbox location, configure it to use **Dovecot LMTP** (Local Mail Transfer Protocol).

1. **Edit `/etc/postfix/main.cf`**:

   ```bash
   sudo nano /etc/postfix/main.cf
   ```

   Add or modify the following lines:

   ```bash
   virtual_transport = lmtp:unix:private/dovecot-lmtp
   virtual_mailbox_domains =  
   virtual_mailbox_maps = hash:/etc/postfix/virtual
   virtual_mailbox_base = /var/mail/vhosts
   ```

2. **Edit `/etc/postfix/master.cf`** to add Dovecot LMTP:

   ```bash
   sudo nano /etc/postfix/master.cf
   ```

   Add:

   ```bash
   dovecot-lmtp unix - - n - - lmtp
   ```

3. **Reload Postfix**:

   ```bash
   sudo systemctl reload postfix
   ```

### Testing the Setup

1. **Send Test Emails**:

   - Send a test email to `evaluation@nathabee.de` and `freebus@nathabee.de`:
     ```bash
     echo "This is a test email for evaluation" | mail -s "Test Mailbox" evaluation@nathabee.de
     echo "This is a test email for freebus" | mail -s "Test Mailbox" freebus@nathabee.de
     ```

2. **Check the Mailboxes**:

   Navigate to the mailbox directories to check for incoming mail:

   ```bash
   ls /var/mail/vhosts/nathabee.de/evaluation/new
   ls /var/mail/vhosts/nathabee.de/freebus/new


   ```

   You should see files inside the `new/` directories for each mailbox, which represent the new email messages.

   Check Email Storage:
   Emails should be stored in /var/mail/vhosts/nathabee.de/freebus/ and similar directories.
   If the directories (cur, new, tmp) do not exist, create them manually with proper ownership and permissions.
   

### Accessing the Mailboxes

#### Option A: Use IMAP/POP3 Client (e.g., Thunderbird)

- **IMAP/POP3 Settings**:
  - **IMAP/POP3 Server**: `nathabee.de`
  - **Username**: `evaluation@nathabee.de` or `freebus@nathabee.de`
  - **Password**: The password you set for each user in `/etc/dovecot/passwd`
  - **IMAP Port**: `143` (unencrypted) or `993` (SSL/TLS)
  - **POP3 Port**: `110` (unencrypted) or `995` (SSL/TLS)

#### Option B: Set Up Webmail Using Roundcube

If you want a **web interface** for accessing emails:

1. **Install Roundcube**:

   ```bash
   sudo apt-get install roundcube roundcube-core roundcube-mysql
   ```

2. **Configure Roundcube**:
   - Access the configuration at `/etc/roundcube/config.inc.php`.
   - Ensure **Dovecot IMAP** settings are configured correctly to access the mailboxes.

3. **Access Webmail**:
   - You can access **Roundcube** by visiting `http://your-server-ip/roundcube`.

### Summary

1. **Install Dovecot** to handle IMAP and POP3 services.
2. **Configure Dovecot** to manage virtual mailboxes by editing `10-mail.conf` and `10-auth.conf` to handle virtual users.
3. **Create virtual mailbox directories** in `/var/mail/vhosts/nathabee.de`.
4. **Configure Postfix** to deliver emails via **Dovecot LMTP**.
5. **Test the setup** by sending emails to `evaluation@nathabee.de` and `freebus@nathabee.de` and checking the corresponding directories.
6. **Access mail** via IMAP/POP3 clients or set up **Roundcube** for webmail access.

This setup ensures that you have local mailboxes for `evaluation@nathabee.de` and `freebus@nathabee.de`, and forwarded emails for `admin@nathabee.de` to `nathabee123@gmail.com`.

---
## Test Email Configuration

After configuring **Postfix**, including all of the necessary **DNS records** (A, MX, SPF, DKIM, DMARC, and PTR), you can perform some testing to ensure that everything is working properly. Below, I'll outline different steps you can take to test both **sending and receiving** emails, as well as verify that all security measures like **SPF, DKIM, and DMARC** are working correctly.

### Sending a Test Email from the Command Line

To test **Postfix**, you can send an email from the command line using the `mail` utility.

#### Install `mailutils` if it's Not Installed
If the `mail` utility isn't installed, you need to install it first:

```bash
sudo apt-get update
sudo apt-get install mailutils
```

#### Send a Test Email
To send a test email:

```bash
echo "This is a test email from Postfix" | mail -s "Test Postfix Setup" freebus@nathabee.com
``` 

- **`-s`**: This specifies the subject line for your email.

**Check if you receive the email** in your inbox. Make sure to also check your **spam folder** to ensure it wasn’t flagged as spam. If it arrives in the spam folder, it may indicate a configuration issue or low trust for your server.

### Use Online Tools to Test SPF, DKIM, and DMARC

To ensure that **SPF, DKIM, and DMARC** are working correctly, you can use some of the following online services:

1. **Mail-Tester.com**:
   - Go to [https://www.mail-tester.com](https://www.mail-tester.com).
   - You will be provided with a unique email address, such as `test-xyz123@mail-tester.com`.
   - Send an email from your server using the `mail` command to that address:
     ```bash
     echo "Testing SPF, DKIM, and DMARC configuration" | mail -s "Email Test" test-xyz123@mail-tester.com
     ```
   - Go back to **Mail-Tester** and click on "Check your score". This tool will analyze your email headers and give you a detailed report on **SPF**, **DKIM**, and **DMARC** compliance as well as general spamminess.

2. **DKIM Validator (dkimvalidator.com)**:
   - Go to [https://www.dkimvalidator.com/](https://www.dkimvalidator.com/).
   - You will see an email address, such as `check-auth@dkimvalidator.com`.
   - Send an email from your server to that address:
     ```bash
     echo "Testing DKIM setup for Postfix" | mail -s "DKIM Test" check-auth@dkimvalidator.com
     ```
   - DKIM Validator will give you a detailed analysis of the DKIM signature, SPF, and whether your email aligns with DMARC.

### Verify DNS Records Using MXToolbox

You can also use **MXToolbox** to verify that all of your DNS records are configured correctly. Go to [https://mxtoolbox.com](https://mxtoolbox.com) and do the following:

1. **Check MX Records**:
   - Enter your domain (`nathabee.de`) in the **MX Lookup** tool to verify that your **MX records** are correctly pointing to your mail server (`mail.nathabee.de`).

2. **Check SPF Record**:
   - Use the **SPF Record Lookup** tool to ensure that your SPF record is valid.

3. **Check DKIM Record**:
   - Use the **DKIM Lookup** tool and enter `default._domainkey.nathabee.de` to verify that your **DKIM public key** is properly published.

4. **Check PTR Record**:
   - Use the **Reverse DNS Lookup** tool by entering your server's **public IP address**. It should return `mail.nathabee.de`.

### Check the Mail Log on Your Server

You can also check the **mail log** to see if there are any errors or issues with the sending process. This log will give you detailed information about the Postfix operations:

```bash
tail -f /var/log/mail.log
```

- You should see details about email delivery, including any errors if something goes wrong.
- You will also see if emails are signed with **DKIM** properly and if they have been delivered to the next destination (e.g., Gmail, Yahoo, etc.).

### Send Email to Common Providers example Gmail

It is also a good idea to send test emails to a variety of popular email providers like:

- **Gmail**
- **Yahoo Mail**
- **Outlook**

Use the following command to send an email:

```bash
echo "Testing email delivery with Postfix" | mail -s "Postfix Test" your-gmail-address@gmail.com
```

Check if the email arrives, and **pay attention** to where it goes—if it lands in **Inbox** or **Spam**. If your emails end up in the spam folder, that could indicate that your domain or IP address still needs some time to build up a good reputation, or there might be minor adjustments needed to your **SPF**, **DKIM**, or **DMARC** configurations.

### Common Troubleshooting Tips

If you run into issues, consider the following:

1. **Mail Logs**: Always start by checking `/var/log/mail.log` for Postfix-specific issues.

2. **DNS Record Propagation**: DNS changes (like SPF, DKIM, and PTR) can take some time to propagate—typically up to 24 hours. If your settings are correct, but you still have issues, it might be worth waiting.

3. **Check SPF, DKIM, and DMARC Errors**: If your email isn’t passing these checks, ensure that:
   - The **SPF record** includes the IP address of your mail server.
   - The **DKIM public key** is properly configured in your DNS.
   - Your **PTR record** resolves back to your domain (`mail.nathabee.de`).

### Summary

- **Step 1**: Send a test email from the server to verify that Postfix is working.
- **Step 2**: Use tools like **Mail-Tester** and **DKIM Validator** to verify **SPF, DKIM, and DMARC**.
- **Step 3**: Verify your DNS records (A, MX, SPF, DKIM, PTR) with **MXToolbox**.
- **Step 4**: Use the **mail log** (`/var/log/mail.log`) to troubleshoot any delivery issues.
- **Step 5**: Send test emails to popular email providers to verify deliverability.

These steps should help you comprehensively test your Postfix setup, identify any issues, and verify that the email configuration is secure, reliable, and delivering correctly.


 --- 



## Configure Django to Use Postfix

You already have a domain (`nathabee.de`) and hosting on a cloud server. This makes it possible to set up email communication without incurring additional recurring costs. After installing and  configure Postfix:

### Configure Django to Use Postfix
   Update the `settings.py` file in your Django project to use Postfix for email sending:

   ```python
   EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
   EMAIL_HOST = 'localhost'
   EMAIL_PORT = 25
   EMAIL_USE_TLS = False
   EMAIL_USE_SSL = False
   DEFAULT_FROM_EMAIL = 'freebus@nathabee.de'  # Replace with a valid email address
   ```

### Test Sending Emails
   You can create a test view or use Django's built-in management commands to send an email:

   ```bash
   python manage.py shell
   ```

   ```python
   from django.core.mail import send_mail
   send_mail('Subject here', 'Here is the message.', 'your_email@nathabee.de', ['recipient@example.com'], fail_silently=False)
   ```
 

