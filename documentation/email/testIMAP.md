
# TEST  IMAP

<!-- TOC -->
- [TEST  IMAP](#test--imap)
    - [Test IMAP and TLS Functionality**](#test-imap-and-tls-functionality)
    - [**IMAP Commands You Can Test**](#imap-commands-you-can-test)
    - [**What These Tests Verify**](#what-these-tests-verify)
    - [**Advanced IMAP Tests**](#advanced-imap-tests)
    - [**Monitor Logs During Tests**](#monitor-logs-during-tests)
<!-- TOC END -->

 

### Test IMAP and TLS Functionality**

#### **a. Test IMAP Connectivity**
Use `openssl` to test if the IMAP server is accessible and using SSL/TLS:
```bash
openssl s_client -connect mail.nathabee.de:993
```
- Look for `SSL handshake has read` to confirm TLS encryption.
- Test authentication manually:
  ```plaintext
  a LOGIN citybus@nathabee.de yourpassword
  ```

  do not rmember the "a" for LOGIN

#### **b. Test Email Client Configuration**
1. Configure an email client (e.g., Thunderbird) to connect to `mail.nathabee.de`.
2. Use:
   - **IMAP Port:** 993
   - **Encryption:** SSL/TLS
3. Send a test email to and from your account.

---



### **IMAP Commands You Can Test**

#### **1. List Mailboxes**
This command lists all available mailboxes (e.g., Inbox, Sent, Trash):
```plaintext
a LIST "" "*"
```
Expected Response:
```plaintext
* LIST (\HasNoChildren) "." "INBOX"
a OK List completed.
```

---

#### **2. Select a Mailbox**
Select a specific mailbox (e.g., Inbox):
```plaintext
a SELECT INBOX
```
Expected Response:
```plaintext
* FLAGS (\Answered \Flagged \Deleted \Seen \Draft)
* EXISTS 5
* RECENT 1
* OK [UIDVALIDITY 3857529045] UIDs valid
a OK [READ-WRITE] Select completed.
```
- **`EXISTS 5`**: Indicates there are 5 messages in the mailbox.
- **`RECENT 1`**: Indicates 1 new message.

---

#### **3. Fetch Email Metadata**
Retrieve a list of emails in the mailbox and their metadata:
```plaintext
a FETCH 1:* (FLAGS)
```
Expected Response:
```plaintext
* 1 FETCH (FLAGS (\Seen))
* 2 FETCH (FLAGS (\Answered \Seen))
* 3 FETCH (FLAGS (\Deleted))
* 4 FETCH (FLAGS (\Draft))
* 5 FETCH (FLAGS (\Flagged))
a OK Fetch completed.
```

---

#### **4. Fetch an Email**
Retrieve the contents of a specific email by its ID (e.g., email `1`):
```plaintext
a FETCH 1 (BODY[])
```
Expected Response:
```plaintext
* 1 FETCH (BODY[] {1234}
From: test@nathabee.de
To: user@example.com
Subject: Test Email
Date: Sun, 24 Nov 2024 12:00:00 +0000

This is a test email.
)
a OK Fetch completed.
```

---

#### **5. Check the Status of a Mailbox**
Retrieve the status of a specific mailbox (e.g., Inbox):
```plaintext
a STATUS INBOX (MESSAGES UNSEEN RECENT)
```
Expected Response:
```plaintext
* STATUS "INBOX" (MESSAGES 5 UNSEEN 2 RECENT 1)
a OK Status completed.
```
- **MESSAGES**: Total number of messages in the mailbox.
- **UNSEEN**: Number of unread messages.
- **RECENT**: Number of new messages since last accessed.

---

#### **6. Logout**
Terminate the session:
```plaintext
a LOGOUT
```
Expected Response:
```plaintext
* BYE Logging out
a OK Logout completed.
```

---

### **What These Tests Verify**
1. **Mailbox Listing (LIST):**
   Confirms that mailboxes are correctly configured and accessible.
   
2. **Mailbox Access (SELECT):**
   Ensures that the server allows access to mailboxes and reports message counts accurately.

3. **Message Retrieval (FETCH):**
   Verifies that messages can be read successfully from the server.

4. **Server Response:**
   Ensures the server responds correctly to IMAP commands.

---

### **Advanced IMAP Tests**
If you want to test more advanced functionality:
- **Delete a Message:**
  Mark an email for deletion:
  ```plaintext
  a STORE 1 +FLAGS (\Deleted)
  ```
  Then permanently remove it:
  ```plaintext
  a EXPUNGE
  ```

- **Create a Mailbox:**
  Create a new folder (e.g., `TestFolder`):
  ```plaintext
  a CREATE TestFolder
  ```
  Expected Response:
  ```plaintext
  a OK Create completed.
  ```

- **Rename a Mailbox:**
  Rename an existing folder:
  ```plaintext
  a RENAME TestFolder RenamedFolder
  ```

- **Delete a Mailbox:**
  Remove a folder (e.g., `RenamedFolder`):
  ```plaintext
  a DELETE RenamedFolder
  ```

---

### **Monitor Logs During Tests**
While performing these commands, monitor your server logs to ensure no errors occur:
- **Dovecot Logs:**
  ```bash
  sudo tail -f /var/log/dovecot.log
  ```
- **Mail Logs:**
  ```bash
  sudo tail -f /var/log/mail.log
  ```

---