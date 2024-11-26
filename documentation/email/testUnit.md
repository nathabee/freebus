**Test Email Configuration**

<!-- TOC -->
  - [Test settup for mailbox setup with physical user ](#test-settup-for-mailbox-setup-with-physical-user)
    - [Test alias and redirection to extern email from postfix](#test-alias-and-redirection-to-extern-email-from-postfix)
    - [Test default conf - user evaluation from mail without specifying sender to gmail](#test-default-conf--user-evaluation-from-mail-without-specifying-sender-to-gmail)
  - [Test virtual mailbox](#test-virtual-mailbox)
  - [Testing the Setup with mail](#testing-the-setup-with-mail)
    - [0. **Use OpenSSL to Test the Connection**](#0-use-openssl-to-test-the-connection)
    - [**Send Test Emails**](#send-test-emails)
    - [**Verifying DKIM is Working**](#verifying-dkim-is-working)
    - [*Check the Mailboxes**](#check-the-mailboxes)
  - [Sending a Test Email from the Command Line](#sending-a-test-email-from-the-command-line)
    - [Install `mailutils` if it's Not Installed](#install-mailutils-if-its-not-installed)
    - [Send a Test Email](#send-a-test-email)
  - [Use Online Tools to Test SPF, DKIM, and DMARC](#use-online-tools-to-test-spf-dkim-and-dmarc)
  - [Verify DNS Records Using MXToolbox](#verify-dns-records-using-mxtoolbox)
  - [Check the Mail Log on Your Server](#check-the-mail-log-on-your-server)
  - [Send Email to Common Providers Example Gmail](#send-email-to-common-providers-example-gmail)
    - [Tips for Improving Deliverability](#tips-for-improving-deliverability)
<!-- TOC END -->

After configuring **Postfix**, including all of the necessary **DNS records** (A, MX, SPF, DKIM, DMARC, and PTR), you can perform some testing to ensure that everything is working properly. Below, I'll outline different steps you can take to test both **sending and receiving** emails, as well as verify that all security measures like **SPF, DKIM, and DMARC** are working correctly.

 
## Test settup for mailbox setup with physical user 

in the server unix user are created :


### Test alias and redirection to extern email from postfix

we want to test redirection from aliases defined in /etc/aliases , where we have configured :
     - Emails sent to `root` will be forwarded to `postmaster`.
     - Emails sent to `postmaster` or `abuse` will be forwarded to `extern_user1@gmail.com`.


2. **send emails**:

If you're testing from different users on the system, you can switch to another user before sending the test emails:
```bash
sudo su - evaluation
echo "This is a test email to postmaster" | mail -s "Test evaluation to Postmaster" postmaster
echo "This is a test email to abuse" | mail -s "Test evaluation to abuse" abuse
echo "This is a test email to freebus" | mail -s "Test evaluation to freebus" freebus
echo "This is a test email to extern_user2@gmail.com" | mail -s "Test evaluation to extern_user2@gmail.com" extern_user2@gmail.com
echo "This is a test email to extern_user2@gmail.com" | mail -s "Test evaluation to extern_user2@gmail.com" extern_user2@gmail.com
```
aliases is set to redirect to 

```bash
sudo su - freebus
date
echo "This is a test email to postmaster" | mail -s "Test3 freebus to Postmaster" postmaster
echo "This is a test email to abuse" | mail -s "Test3 freebus to abuse" abuse
echo "This is a test email to freebus" | mail -s "Test3 freebus to freebus" freebus
echo "This is a test email to freebus" | mail -s "Test3 freebus to evaluation" evaluation
echo "This is a test email to  extern_user2@gmail.com" | mail -s "Test3 freebus to  extern_user2@gmail.com"  extern_user2@gmail.com
echo "This is a test email to extern_user2@gmail.com" | mail -s "Test4 freebus to extern_user2@gmail.com" extern_user2@gmail.com
date
```
 


2. **Monitor Logs**:
   - Check Postfix logs to confirm emails are being forwarded:
     ```bash
     sudo tail -f /var/log/mail.log
     ```
   - Look for entries indicating successful forwarding to `extern_user1@gmail.com` and `extern_user2@gmail.com`.

3. **Verify in Gmail**:
   - Confirm that the test emails are delivered to  `extern_user1@gmail.com` and `extern_user2@gmail.com`.
   - Check the headers in Gmail for:
     - DKIM signature
     - SPF status
     - Reverse DNS alignment

 
 
3. **Verify in thunderbird **:
   - Confirm that the test emails are delivered to  `evaluation@nathabee.de` and `freebus@nathabee.com`.
   - Check the headers in Gmail for:
     - DKIM signature
     - SPF status
     - Reverse DNS alignment

 
 

### Test default conf - user evaluation from mail without specifying sender to gmail

hier is the default sender that will be used user + 
   ```bash
postconf myhostname
myhostname = mail.nathabee.de
hostname
mail.nathabee.de

sudo su - evaluation
echo "This is a test email with default sender evaluation@mail.nathabee.de"  -s "test default sender  to gmail" extern_user2@gmail.com
This is a test email with default sender evaluation@mail.nathabee.de -s test default sender extern_user2@gmail.com
 
  ```





## Test virtual mailbox



## Testing the Setup with mail

### 0. **Use OpenSSL to Test the Connection**
You can also use **openssl** to verify the secure connection to your mail server:
   ```bash
   openssl s_client -connect mail.nathabee.de:587 -starttls smtp
   ```
   This will check if the SMTP server supports **STARTTLS** and that the certificate is served correctly.

### **Send Test Emails**

- Send a test email to `evaluation@nathabee.de` and `freebus@nathabee.de`:
  ```bash
  echo "This is a test email for evaluation" | mail -s "Test Mailbox" evaluation@nathabee.de
  echo "This is a test email for freebus" | mail -s "Test Mailbox" freebus@nathabee.de
  ```





















### **Verifying DKIM is Working**
1. **Send a Test Email:**
   - Use a tool like [Gmail](https://mail.google.com) or another provider to send an email to yourself from your mail server.
2. **Check the Email Headers:**
   - In the received email, look for the `DKIM-Signature` header and ensure it matches your key.
   - Also, look for the `Authentication-Results` header. You should see something like:
     ```
     dkim=pass header.i=@nathabee.de
     ```


### *Check the Mailboxes**

Navigate to the mailbox directories to check for incoming mail:

```bash
sudo ls /var/mail/vhosts/nathabee.de/evaluation/new
sudo ls /var/mail/vhosts/nathabee.de/freebus/new
```
You should see files inside the `new/` directories for each mailbox, which represent the new email messages.

- **Check Email Storage**:
  Emails should be stored in `/var/mail/vhosts/nathabee.de/freebus/` and similar directories.
  If the directories (`cur`, `new`, `tmp`) do not exist, create them manually with proper ownership and permissions.

## Sending a Test Email from the Command Line

To test **Postfix**, you can send an email from the command line using the `mail` utility.

### Install `mailutils` if it's Not Installed
If the `mail` utility isn't installed, you need to install it first:

```bash
sudo apt-get update
sudo apt-get install mailutils
```

### Send a Test Email
To send a test email:

```bash
echo "This is a test email from Postfix" | mail -s "Test Postfix Setup" freebus@nathabee.com
``` 
- **`-s`**: This specifies the subject line for your email.

**Check if you receive the email** in your inbox. Make sure to also check your **spam folder** to ensure it wasn’t flagged as spam. If it arrives in the spam folder, it may indicate a configuration issue or low trust for your server.

## Use Online Tools to Test SPF, DKIM, and DMARC

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

## Verify DNS Records Using MXToolbox

You can also use **MXToolbox** to verify that all of your DNS records are configured correctly. Go to [https://mxtoolbox.com](https://mxtoolbox.com) and do the following:

1. **Check MX Records**:
   - Enter your domain (`nathabee.de`) in the **MX Lookup** tool to verify that your **MX records** are correctly pointing to your mail server (`mail.nathabee.de`).

2. **Check SPF Record**:
   - Use the **SPF Record Lookup** tool to ensure that your SPF record is valid.

3. **Check DKIM Record**:
   - Use the **DKIM Lookup** tool and enter `default._domainkey.nathabee.de` to verify that your **DKIM public key** is properly published.

4. **Check PTR Record**:
   - Use the **Reverse DNS Lookup** tool by entering your server's **public IP address**. It should return `mail.nathabee.de`.

## Check the Mail Log on Your Server

You can also check the **mail log** to see if there are any errors or issues with the sending process. This log will give you detailed information about the Postfix operations:

```bash
tail -f /var/log/mail.log
```

- You should see details about email delivery, including any errors if something goes wrong.
- You will also see if emails are signed with **DKIM** properly and if they have been delivered to the next destination (e.g., Gmail, Yahoo, etc.).

## Send Email to Common Providers Example Gmail

It is also a good idea to send test emails to a variety of popular email providers like:

- **Gmail**
- **Yahoo Mail**
- **Outlook**

Use the following command to send an email:

```bash
echo "Testing email delivery with Postfix" | mail -s "Postfix Test" your-gmail-address@gmail.com
```

- **Check if the email arrives**: Pay attention to where it goes—**Inbox** or **Spam**. If your emails end up in the spam folder, it could indicate that your domain or IP address still needs some time to build up a good reputation, or there might be minor adjustments needed to your **SPF**, **DKIM**, or **DMARC** configurations.

### Tips for Improving Deliverability
- **Double-Check DNS Records**: Ensure **SPF**, **DKIM**, and **DMARC** are correctly set up and free of errors.
- **Check Email Reputation**: Use tools like [SenderScore](https://www.senderscore.org) to verify your IP reputation.
- **Add a PTR Record**: Ensure that you have a **reverse DNS (PTR)** record pointing back to your mail server’s hostname.
- **Monitor Spam Complaints**: Be mindful of **spam complaints**. If you notice increased complaints, consider revising your email content or recipients.


