# Starting and Configuring Thunderbird on Ubuntu

<!-- TOC -->
- [Starting and Configuring Thunderbird on Ubuntu](#starting-and-configuring-thunderbird-on-ubuntu)
  - [Install Thunderbird](#install-thunderbird)
  - [Configure Thunderbird](#configure-thunderbird)
  - [Accessing Emails](#accessing-emails)
  - [Should Thunderbird Be Installed on the Server or Local PC?](#should-thunderbird-be-installed-on-the-server-or-local-pc)
<!-- TOC END -->


Thunderbird is a popular and easy-to-use email client, and it's simple to set up on your local PC running Ubuntu. Here’s how you can do it:

## Install Thunderbird
Thunderbird is likely available in your system's default software repository. You can install it using the terminal:

1. **Open a Terminal** and run the following command:
   ```bash
   sudo apt-get update
   sudo apt-get install thunderbird
   ```
   
2. **Launch Thunderbird**:
   - Once installed, you can start Thunderbird by searching for it in your applications menu or by typing `thunderbird` in the terminal:
     ```bash
     thunderbird &
     ```

## Configure Thunderbird
Now that you have Thunderbird installed, you need to set it up to connect to your mail server.

1. **Open Thunderbird**:
   - You will be greeted with a welcome window. If it’s your first time opening Thunderbird, you’ll see an option to create a new email account or configure an existing one.
   - Choose **"Set Up Existing Email Account"**.

2. **Enter Your Email Details**:
   - Enter the details of the email account you want to set up.
     - **Your name**: (What people will see when you send an email, e.g., "Nathalie Bee")
     - **Email address**: `freebus@nathabee.de` or `evaluation@nathabee.de`
     - **Password**: The password set in `/etc/dovecot/passwd` for that user (e.g., `my_password_citybus`).

3. **Manual Configuration**:
   - Thunderbird will try to automatically configure the settings, but you should click **"Configure manually"** to ensure everything is correct.
   - Fill in the following settings:
     - **Incoming Mail Server** (  POP3):
       - **Protocol**: POP3  
       - **Server**: `nathabee.de`
       - **Port**: Use the port settings based on whether you want encryption or not: 
         - **POP3**: `995` (SSL/TLS)  
       - **Connection security**: Set to `SSL/TLS` for encrypted ports  
       - **Authentication method**: Use **Normal Password**.
       - **Username**: The full email address, e.g., `freebus@nathabee.de`.
     - **Outgoing Mail Server (SMTP)**:
       - **Server**: `nathabee.de`
       - **Port**:   `465` (SSL/TLS).
       - **Connection security**:  `SSL/TLS`.
       - **Authentication method**: **Normal Password**.
       - **Username**: The full email address, e.g., `freebus@nathabee.de`.

4. **Save Settings**:
   - After manually configuring the settings, click **"Done"**.
   - Thunderbird will test the settings, and once it verifies them, your email account should be added successfully.

## Accessing Emails
- **Access Mail**:
  - After setting up the account, Thunderbird will begin syncing emails. You should be able to see your inbox and any other folders from your mail server.
  
## Should Thunderbird Be Installed on the Server or Local PC?
- **Local PC**: 
  - Thunderbird is meant to be used on your **local computer** or **laptop**. This is the easiest and most efficient way to manage your emails.
- **Not on the Server**:
  - You generally **do not install** an email client on your **mail server**. The server is intended to handle backend services, and GUI applications like Thunderbird would consume unnecessary resources.
- **On Your Handy (Mobile Device)**:
  - For mobile devices, use mobile email clients like **K-9 Mail** for Android or the default Mail app for iOS. These apps can be set up similarly by using the IMAP or POP3 settings.
 