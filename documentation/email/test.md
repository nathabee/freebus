# Test Email Configuration

<!-- TOC -->
- [Test Email Configuration](#test-email-configuration)
  - [Testing the Setup](#testing-the-setup)
  - [Sending a Test Email from the Command Line](#sending-a-test-email-from-the-command-line)
    - [Install `mailutils` if it's Not Installed](#install-mailutils-if-its-not-installed)
    - [Send a Test Email](#send-a-test-email)
  - [Use Online Tools to Test SPF, DKIM, and DMARC](#use-online-tools-to-test-spf-dkim-and-dmarc)
  - [Verify DNS Records Using MXToolbox](#verify-dns-records-using-mxtoolbox)
  - [Check the Mail Log on Your Server](#check-the-mail-log-on-your-server)
  - [Send Email to Common Providers example Gmail](#send-email-to-common-providers-example-gmail)
<!-- TOC END -->


After configuring **Postfix**, including all of the necessary **DNS records** (A, MX, SPF, DKIM, DMARC, and PTR), you can perform some testing to ensure that everything is working properly. Below, I'll outline different steps you can take to test both **sending and receiving** emails, as well as verify that all security measures like **SPF, DKIM, and DMARC** are working correctly.


## Testing the Setup

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

## Send Email to Common Providers example Gmail

It is also a good idea to send test emails to a variety of popular email providers like:

- **Gmail**
- **Yahoo Mail**
- **Outlook**

Use the following command to send an email:

```bash
echo "Testing email delivery with Postfix" | mail -s "Postfix Test" your-gmail-address@gmail.com
```

Check if the email arrives, and **pay attention** to where it goes—if it lands in **Inbox** or **Spam**. If your emails end up in the spam folder, that could indicate that your domain or IP address still needs some time to build up a good reputation, or there might be minor adjustments needed to your **SPF**, **DKIM**, or **DMARC** configurations.
