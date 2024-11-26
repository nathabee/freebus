# Receiving Emails in Mailboxes 
<!-- TOC -->
- [Receiving Emails in Mailboxes ](#receiving-emails-in-mailboxes)
  - [Objective Configure MailBox with Dovecot](#objective-configure-mailbox-with-dovecot)
  - [Install Dovecot](#install-dovecot)
    - [Configure Dovecot for Virtual Mailboxes](#configure-dovecot-for-virtual-mailboxes)
    - [configure dovecot to use IMAP](#configure-dovecot-to-use-imap)
    - [Configure Postfix to Deliver Emails to Dovecot](#configure-postfix-to-deliver-emails-to-dovecot)
    - [Accessing the Mailboxes with Thunderbird](#accessing-the-mailboxes-with-thunderbird)
    - [Summary](#summary)
<!-- TOC END -->

   - If you want to **store** received emails for each address, you need a tool like **Dovecot** or another **IMAP/POP3 server** to manage incoming mailboxes.
   - **Dovecot** can be used alongside Postfix to store received mail in virtual mailboxes, making it accessible through a webmail interface or any email client (Thunderbird, Outlook, etc.).

## Objective Configure MailBox with Dovecot

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



## Install Dovecot

**Dovecot** will be used as the **IMAP/POP3** server to manage your local mailboxes. This will allow you to access your emails using a **webmail interface** or **email clients** like **Thunderbird**.

Run the following command to install Dovecot:

```bash
sudo apt-get update
sudo apt-get install dovecot-imapd dovecot-pop3d
sudo apt install dovecot-sieve dovecot-lmtpd

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
  protocols = imap pop3 lmtp
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
   #!include auth-system.conf.ext

   
   ```
   make a comment to remove use of system password : we do just want virtual user #/etc/dovecot/conf.d/auth-system.conf.ext 

4. **Create a password file** at `/etc/dovecot/passwd`:

   - has wyour password:
     ```bash
   sudo doveadm pw -s SHA512-CRYPT
   
     ```


   - Add virtual users to this file:

     ```bash
     sudo nano /etc/dovecot/passwd
     ```

     - Add entries for `evaluation` and `freebus`:

       ```
       evaluation@nathabee.de:{SHA512-CRYPT}YOURPASSWORD1
       freebus@nathabee.de:{SHA512-CRYPT}YOURPASSWORD1
       ```

   - **Permissions**:

     ```bash
     sudo chmod 600 /etc/dovecot/passwd
     sudo chown dovecot:dovecot /etc/dovecot/passwd
     ```

   **Note**: Replace `my_password_evaluation` and `my_password_citybus` with secure passwords.



5. **Configure the User Password  access** (`sudo nano /etc/dovecot/conf.d/auth-passwdfile.conf.ext`):

   Open the file:

   ```bash
   sudo nano sudo nano /etc/dovecot/conf.d/auth-passwdfile.conf.ext
   ```

   - Add the following configuration to specify where users' home directories and mail directories are located:

     ```bash
      passdb {
      driver = passwd-file
      args = scheme=CRYPT username_format=%u /etc/dovecot/passwd
      }

      userdb {
      driver = passwd-file
      args = username_format=%u /etc/dovecot/passwd
      default_fields = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n

            }
     ```

   - Ensure the /var/mail/vhosts directory has the correct permissions so that Dovecot can access it without any issues:

     ```bash
     sudo mkdir -p /var/mail/vhosts/nathabee.de/{freebus,evaluation}
      sudo chown -R vmail:vmail /var/mail/vhosts
      sudo chmod -R 770 /var/mail/vhosts
     ```



 
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


8.  Create the `vmail` User and Group

You can create a user named `vmail` with the following commands:

8.1. **Create the `vmail` Group**:

   ```bash
   sudo groupadd -g 5000 vmail
   ```

   - **`-g 5000`**: This assigns a specific group ID (you can use any number that doesn’t conflict with existing group IDs).
   - **`vmail`**: The name of the group.

8.2. **Create the `vmail` User**:

   ```bash
   sudo useradd -m -d /var/mail -u 5000 -g vmail -s /usr/sbin/nologin vmail
   ```

   - **`-m`**: Creates a home directory for the user.
   - **`-d /var/mail`**: Specifies the home directory for the user (`/var/mail`).
   - **`-u 5000`**: Assigns the user ID (again, you can use another number if `5000` is already taken).
   - **`-g vmail`**: Sets the **primary group** for the user (`vmail`).
   - **`-s /usr/sbin/nologin`**: Specifies that this user **cannot log in** to the system. This is a security measure since `vmail` is just used for mail handling, not for logging in.



#### Create the Mail Directory Structure

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

### configure dovecot to use IMAP

Ensure that IMAP is enabled in your Dovecot configuration:

1. Open the Dovecot protocol configuration file:
   ```bash
   sudo nano /etc/dovecot/conf.d/10-master.conf
   ```

2. Look for the `service imap-login` section:
   ```plaintext
   service imap-login {
       inet_listener imap {
           port = 143
       }
       inet_listener imaps {
           port = 993
           ssl = yes
       }
   }
   ```

3. **Ports:**
   - OBSOLETE BY ME : Port `143` for unencrypted IMAP (optional; can be disabled to enforce TLS).
   - Port `993` for encrypted IMAP with SSL/TLS.

4. Save and exit, then restart Dovecot:
   ```bash
   sudo systemctl restart dovecot
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

virtual_transport tells Postfix how to deliver messages for virtual mailboxes (i.e., users that are not system users).
lmtp:unix:private/dovecot-lmtp tells Postfix to use the LMTP (Local Mail Transfer Protocol) over a UNIX socket located at /var/spool/postfix/private/dovecot-lmtp.

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

### Accessing the Mailboxes with Thunderbird

- **IMAP/POP3 Settings**:
  - **IMAP/POP3 Server**: `nathabee.de`
  - **Username**: `evaluation@nathabee.de` or `freebus@nathabee.de`
  - **Password**: The password you set for each user in `/etc/dovecot/passwd`
  - **IMAP Port**: `143`OBSOLETE (unencrypted) or `993` (SSL/TLS)
  - **POP3 Port** OBSOLETE : `110` (unencrypted) or `995` (SSL/TLS)




### Summary

1. **Install Dovecot** to handle IMAP and POP3 services.
2. **Configure Dovecot** to manage virtual mailboxes by editing `10-mail.conf` and `10-auth.conf` to handle virtual users.
3. **Create virtual mailbox directories** in `/var/mail/vhosts/nathabee.de`.
4. **Configure Postfix** to deliver emails via **Dovecot LMTP**.
5. **Test the setup** by sending emails to `evaluation@nathabee.de` and `freebus@nathabee.de` and checking the corresponding directories.
6. **Access mail** via IMAP/POP3 clients or set up **Roundcube** for webmail access.

This setup ensures that you have local mailboxes for `evaluation@nathabee.de` and `freebus@nathabee.de`, and forwarded emails for `admin@nathabee.de` to `nathabee123@gmail.com`.
