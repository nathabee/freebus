# Common Troubleshooting Tips

<!-- TOC -->
- [Common Troubleshooting Tips](#common-troubleshooting-tips)
  - [Summary](#summary)
- [Debug Email ](#debug-email)
  - [Configuration](#configuration)
  - [Test Dovecot authentification](#test-dovecot-authentification)
  - [Inspecting or Monitoring the LMTP Socket](#inspecting-or-monitoring-the-lmtp-socket)
  - [Postfix Troubleshouting](#postfix-troubleshouting)
  - [Dovecot](#dovecot)
  - [Steps to Troubleshoot the IMAP SSL Issue](#steps-to-troubleshoot-the-imap-ssl-issue)
  - [LMTP socket](#lmtp-socket)
  - [Important Considerations](#important-considerations)
<!-- TOC END -->


If you run into issues, consider the following:

1. **Mail Logs**: Always start by checking `/var/log/mail.log` for Postfix-specific issues.

2. **DNS Record Propagation**: DNS changes (like SPF, DKIM, and PTR) can take some time to propagate—typically up to 24 hours. If your settings are correct, but you still have issues, it might be worth waiting.

3. **Check SPF, DKIM, and DMARC Errors**: If your email isn’t passing these checks, ensure that:
   - The **SPF record** includes the IP address of your mail server.
   - The **DKIM public key** is properly configured in your DNS.
   - Your **PTR record** resolves back to your domain (`mail.nathabee.de`).

## Summary

- **Step 1**: Send a test email from the server to verify that Postfix is working.
- **Step 2**: Use tools like **Mail-Tester** and **DKIM Validator** to verify **SPF, DKIM, and DMARC**.
- **Step 3**: Verify your DNS records (A, MX, SPF, DKIM, PTR) with **MXToolbox**.
- **Step 4**: Use the **mail log** (`/var/log/mail.log`) to troubleshoot any delivery issues.
- **Step 5**: Send test emails to popular email providers to verify deliverability.

These steps should help you comprehensively test your Postfix setup, identify any issues, and verify that the email configuration is secure, reliable, and delivering correctly.


 --- 

# Debug Email 

## Configuration

   - To get the dovecot active configuration:

     ```bash
      doveconf -n
     ```

      echo "This is a test email for freebus" | mail -s "Test Mailbox" freebus@nathabee.de

---
## Test Dovecot authentification

password are in /etc/dovecot/passwd
```bash
sudo doveadm auth test freebus@nathabee.de

 ```


## Inspecting or Monitoring the LMTP Socket

**UNIX sockets** are essentially a way for different processes to communicate with each other on the same system, similar to network sockets but used internally. Inspecting or "hacking" the data being sent between Postfix and Dovecot over the LMTP socket is possible, but requires some specific techniques and tools.

#### Expected workflow between emailing through Postfix to dovecot delivery 
```bash
sudo systemctl restart dovecot
sudo systemctl restart postfix
echo "This is a test email for freebus" | mail -s "Test Mailbox" freebus@nathabee.de
sudo ls /var/mail/vhosts/nathabee.de/freebus/new
 ```


## Postfix Troubleshouting
 
 

start postfix and check the logs :
```bash
sudo systemctl restart postfix
systemctl status postfix.service
 ```

 simulate send of a message :
```bash
 echo "This is a test email for freebus" | mail -s "Test Mailbox" freebus@nathabee.de

 ```

 check if the message is in the queue :

```bash
postqueue -p
#remove queues
postqueue -p | awk '($1 ~ /^[A-F0-9]+[*]?$/) { gsub("\\*", "", $1); print $1 }' | xargs -I {} sudo postsuper -d {}
postqueue -p | awk '($1 ~ /^[A-F0-9]+$/) { print $1 }' | xargs -I {} sudo postsuper -d {}
```
 

## Dovecot

**start Dovecot and check the logs :**
```bash
sudo rm /var/spool/postfix/private/dovecot-lmtp
sudo systemctl start dovecot
sudo systemctl restart postfix
sudo systemctl status dovecot.service
sudo tail -f /var/log/dovecot*.log

 ```

Test dovecot config manually :
```bash
 # Test IMAP without encryption
telnet localhost 143

# Test IMAP with encryption
openssl s_client -connect localhost:993 -crlf

# Test POP3 without encryption
telnet localhost 110

# Test POP3 with encryption
openssl s_client -connect localhost:995 -crlf

 ```


---



## Steps to Troubleshoot the IMAP SSL Issue

1. **Check Dovecot SSL/TLS Configuration**:
   - Open the Dovecot configuration related to SSL/TLS, usually found in `/etc/dovecot/conf.d/10-ssl.conf`.
   - Ensure that Dovecot is configured properly to support **SSL/TLS** on port **993**. The relevant configurations are:
     ```bash
     ssl = yes
     ssl_cert = </etc/dovecot/private/dovecot.pem
     ssl_key = </etc/dovecot/private/dovecot.key
     #ssl_cert = </etc/letsencrypt/live/nathabee.de/fullchain.pem
     #ssl_key = </etc/letsencrypt/live/nathabee.de/privkey.pem
     ```
   - Confirm that the paths to the certificate (`fullchain.pem`) and key (`privkey.pem`) are correct and that these files are valid. 

2. **Verify Certificate Validity**:
   - Ensure the SSL certificate used by Dovecot is not expired or improperly configured:
     ```bash
     openssl x509 -in /etc/dovecot/private/dovecot.pem -noout -dates
   
     #openssl x509 -in /etc/letsencrypt/live/nathabee.de/fullchain.pem -noout -dates
     ```
   - This will show the validity period of the certificate. If it’s expired, you'll need to renew it.

3. **Try OpenSSL with Explicit Protocol Specification**:
   - Run the command with more detailed options:
     ```bash
     openssl s_client -connect localhost:993 -starttls imap
     ```
   - This command tells OpenSSL to connect to port **993** and explicitly use the **IMAP STARTTLS** method, which might provide better insight into the handshake issue.

4. **Check for Dovecot Log Errors**:
   - Check the Dovecot logs after attempting the SSL connection:
     ```bash
     tail -f /var/log/dovecot.log
     ```
   - Look for any **SSL errors** or messages indicating an issue during the handshake.

---




## LMTP socket

```bash
sudo systemctl stop postfix
sudo systemctl stop dovecot

sudo rm -f /var/spool/postfix/private/dovecot-lmtp

sudo chown -R postfix:postfix /var/spool/postfix/private
sudo chmod -R 755 /var/spool/postfix/private
``` 

1. **`strace`** to Trace Socket Activity

   You can use `strace` to attach to the **Dovecot** or **Postfix** process and see system calls, which include read and write operations on the **LMTP socket**.

   - To trace **Dovecot**:

```bash
sudo strace -p $(pidof dovecot) -e trace=file,read,write
```

     - **`pidof dovecot`** gives the PID of the dovecot process.
     - **`-e trace=file,read,write`** limits the trace to **file**, **read**, and **write** system calls, which are relevant to socket interactions.

   - **Note**: This can generate a **lot** of output since it traces all activity. However, you will see the file descriptors related to the socket being accessed.

2. **`socat`** to Monitor Socket Data

   If you want to see the actual data being sent over the socket, you could use **`socat`**. This approach would involve redirecting the socket to another process that can show the data, or creating an intermediary listener. This is somewhat complex and can be risky to attempt on a production system because:

   - You need to temporarily **stop Dovecot** from listening on the socket.
   - You replace the socket with a **`socat`** listener to capture the traffic.

   Example command to inspect data between Postfix and Dovecot:

   ```bash
   sudo systemctl stop dovecot
   sudo socat -v UNIX-LISTEN:/var/spool/postfix/private/dovecot-lmtp,fork UNIX-CONNECT:/tmp/dovecot-lmtp-backup
   ```

   In this command:

   - `socat` listens to the **dovecot-lmtp** socket.
   - It forwards the communication to another socket, effectively **tapping** into the data flow.

3. **Debugging with `netcat` or `nc`**

   Since **UNIX sockets** and **network sockets** have similarities, you could also try using **netcat** (`nc`) to open a connection to the **LMTP** socket and inspect the response.

   ```bash
   sudo nc -U /var/spool/postfix/private/dovecot-lmtp
   ```

   This may allow you to manually initiate a connection and see the initial greeting from **Dovecot** (assuming you can properly format the LMTP commands).

## Important Considerations

- **Be Careful in Production**: Inspecting sockets, attaching strace, or using tools like **`socat`** or **`nc`** can disrupt normal operation, especially on a production server. It’s always a good idea to test these kinds of procedures in a **non-critical environment**.
  
- **Permissions**: Make sure you have the correct permissions when accessing the socket. This is why the mode, user, and group are important in `/etc/dovecot/conf.d/10-master.conf`.