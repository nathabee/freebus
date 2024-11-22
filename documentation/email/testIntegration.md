# Email Workflow Test Scenarios


<!-- TOC -->
- [Email Workflow Test Scenarios](#email-workflow-test-scenarios)
  - [**Basic Email Sending and Receiving**](#basic-email-sending-and-receiving)
  - [**Authentication Tests**](#authentication-tests)
  - [**DKIM and SPF Validation**](#dkim-and-spf-validation)
  - [**IMAP and POP3 Access Testing**](#imap-and-pop3-access-testing)
  - [**Relay Restrictions and Security**](#relay-restrictions-and-security)
  - [**Mailbox Management and Quota**](#mailbox-management-and-quota)
  - [**Connection Encryption Tests**](#connection-encryption-tests)
  - [**Webmail Integration**](#webmail-integration)
  - [**Email Filtering and Spam Handling**](#email-filtering-and-spam-handling)
  - [**Bounce Handling and Notifications**](#bounce-handling-and-notifications)
  - [**DNS and MX Record Testing**](#dns-and-mx-record-testing)
  - [Summary and Reporting](#summary-and-reporting)
<!-- TOC END -->


To ensure the full functionality of your email system setup, which includes **Postfix**, **Dovecot**, and **DNS (DKIM, SPF)**, we need a comprehensive list of scenarios to test different aspects of the configuration. Below is a collection of key test cases to validate the email workflow end-to-end:

## **Basic Email Sending and Receiving**
   - **Send Email to Local Mailbox**: Send an email from an external domain (e.g., Gmail or Yahoo) to a local mailbox (`freebus@nathabee.de`). Verify that the email arrives in the correct Dovecot mailbox.
   - **Send Email Outbound**: Send an email from a local mailbox (`evaluation@nathabee.de`) to an external address (e.g., `example@gmail.com`). Verify successful delivery.
   - **Internal Mailbox Communication**: Test sending an email between two local mailboxes (`freebus@nathabee.de` to `evaluation@nathabee.de`). Check the delivery and message integrity.

## **Authentication Tests**
   - **Authentication via Email Client (IMAP/SMTP)**: Set up an email client (e.g., Thunderbird) using the IMAP and SMTP settings for `nathabee.de`. Verify the authentication works and the client can access/send emails.
   - **TLS/SSL Authentication**: Verify that email clients can connect via **SSL/TLS** on ports `993` (IMAP) and `587` (SMTP) using valid certificates.

## **DKIM and SPF Validation**
   - **DKIM Signing for Outbound Emails**: Send an email from `nathabee.de` to an external email (e.g., Gmail). Verify that the **DKIM signature** is added and valid.
   - **SPF Check for Incoming Mail**: Send an email from an unauthorized server pretending to be `nathabee.de`. Ensure that the SPF check identifies and rejects the message.

## **IMAP and POP3 Access Testing**
   - **IMAP Access via Email Client**: Use an email client (e.g., Thunderbird) to connect using **IMAP** to `freebus@nathabee.de`. Verify the mailbox can be accessed, and messages can be read, moved, and deleted.
   - **POP3 Access**: Connect using **POP3** to download messages for `evaluation@nathabee.de`. Verify messages are retrieved successfully.

## **Relay Restrictions and Security**
   - **Unauthorized Relay Prevention**: Attempt to relay email through your server from an unauthorized IP. Ensure that the server rejects the attempt as expected.
   - **Relay Authentication**: Use a valid username and password with SMTP (port 587) to authenticate as a legitimate user and relay an email. Confirm that authenticated users can successfully send mail.

## **Mailbox Management and Quota**
   - **Mailbox Quota Enforcement**: Assign a mailbox quota to `evaluation@nathabee.de` and try exceeding it. Verify that no additional emails can be received until space is cleared.
   - **Mailbox Access Permissions**: Ensure only authorized users can access their designated mailboxes.

## **Connection Encryption Tests**
   - **IMAP with SSL (Port 993)**: Verify that emails can be read over a secure IMAP connection using **SSL/TLS**.
   - **POP3 with SSL (Port 995)**: Confirm that emails can be downloaded securely using **POP3** with SSL/TLS enabled.
   - **SMTP Submission with TLS (Port 587)**: Ensure that outgoing emails are submitted securely via port 587 with **STARTTLS**.

## **Webmail Integration**
   - **Roundcube Webmail Access**: Install **Roundcube** and ensure users can access their mailbox (`freebus@nathabee.de`, `evaluation@nathabee.de`) through a web interface. Verify sending, receiving, and mailbox management via the webmail.

## **Email Filtering and Spam Handling**
   - **Spam Filter Test**: Configure basic spam filters in Postfix. Send a test email with common spam characteristics to `nathabee.de` and confirm it gets marked appropriately.
   - **Blacklist and Whitelist Testing**: Verify that emails from blacklisted domains are rejected, while those from whitelisted domains are allowed.

## **Bounce Handling and Notifications**
   - **Non-existent User Handling**: Send an email to a non-existent address at `nathabee.de`. Verify that a bounce notification is returned with an appropriate error message.
   - **Mailbox Full Notification**: Ensure a proper bounce notification is generated if an email is sent to a mailbox that is full.

## **DNS and MX Record Testing**
   - **MX Record Verification**: Verify that the **MX records** for `nathabee.de` are set up correctly and point to your mail server.
   - **Reverse DNS (PTR) Record Check**: Verify that your mail server’s IP address has a correct **PTR record** to reduce spam flagging.

## Summary and Reporting
- Document the results of each test scenario.
- Log any issues found and the corresponding steps to fix them.
- Create a detailed test report summarizing each test, the expected outcome, the actual result, and any additional actions taken.

