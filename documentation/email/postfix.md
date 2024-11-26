# Setting Up an SMTP Server Postfix
<!-- TOC -->
- [Setting Up an SMTP Server Postfix](#setting-up-an-smtp-server-postfix)
  - [**Install Postfix**:](#install-postfix)
  - [**Configure Postfix for Multiple Domains and Addresses**:](#configure-postfix-for-multiple-domains-and-addresses)
  - [**Postfix and Dovecot Integration for SASL**](#postfix-and-dovecot-integration-for-sasl)
  - [open to port 25](#open-to-port-25)
    - [mofify postfix configuration :](#mofify-postfix-configuration)
    - [change VPS firewall open port 25 in both direction](#change-vps-firewall-open-port-25-in-both-direction)
    - [check that postfix listnen on PORT 25](#check-that-postfix-listnen-on-port-25)
    - [check that postfix PORT 25 is accessible from outside VPS in inbound](#check-that-postfix-port-25-is-accessible-from-outside-vps-in-inbound)
    - [check port 25 acessible in outbound :](#check-port-25-acessible-in-outbound)
  - [seeting config for real user (alternative to  Virtual Mailboxes)](#seeting-config-for-real-user-alternative-to--virtual-mailboxes)
  - [**Setting Up Virtual Mailboxes**:](#setting-up-virtual-mailboxes)
  - [Using Aliases for Forwarding  (TO BE TESTED )](#using-aliases-for-forwarding--to-be-tested)
<!-- TOC END -->

You can use **Postfix** as your SMTP server to manage outgoing emails. Here's what you'll need to do:

## **Install Postfix**:
   ```bash
   sudo apt-get update
   sudo apt-get install postfix
   ```
   
## **Configure Postfix for Multiple Domains and Addresses**:
   - Postfix can be configured to send emails on behalf of multiple addresses (`evaluation@nathabee.de`, `freebus@nathabee.de`, etc.).
   - Edit `/etc/postfix/main.cf` to set up your domain:
     ```
     myhostname = mail.nathabee.de
     mydomain = nathabee.de
     myorigin = $mydomain
     inet_interfaces = all
     mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
     ```



   - **add in /etc/hosts**:
     ```bash
      127.0.0.1 mail.nathabee.de
     ```

     - **Access to socket**
     ```bash
     sudo chown root:postfix /var/spool/postfix/
sudo chmod 755 /var/spool/postfix/
     ```

## **Postfix and Dovecot Integration for SASL**
Postfix uses the following configuration to point to Dovecot for authentication:

 Relevant Entries in `/etc/postfix/main.cf`:
```plaintext
smtpd_sasl_auth_enable = yes
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_security_options = noanonymous
```



## open to port 25
 
###  mofify postfix configuration :

```plaintext
sudo nano /etc/postfix/master.cf
Look for this section (it controls port 25):
```


```plaintext
smtp      inet  n       -       y       -       -       smtpd
```


```plaintext
sudo nano /etc/postfix/main.cf


inet_interfaces = all
inet_protocols = ipv4, ipv6
``` 

 

### change VPS firewall open port 25 in both direction

- inbound TCP port 25
- outboud TXP port 25 


### check that postfix listnen on PORT 25

```plaintext
sudo netstat -tlnp | grep :25

``` 


### check that postfix PORT 25 is accessible from outside VPS in inbound
on your PC 
```plaintext
telnet 159.69.0.127 25
```
- you should see that postfix listenen to port 25

### check port 25 acessible in outbound :
telnet gmail-smtp-in.l.google.com 25


- sometimes it could be necessary to ask your VPS provider to unblock port 25 if it blocks it

## seeting config for real user (alternative to  Virtual Mailboxes)

```plaintext
sudo useradd  -m -s /bin/bash evaluation
sudo passwd evaluation
New password: 
Retype new password: 
passwd: password updated successfully

sudo useradd  -m -s /bin/bash freebus
sudo passwd freebus
New password: 
Retype new password: 
passwd: password updated successfully

```

 
## **Setting Up Virtual Mailboxes**:

  - **Virtual Mailboxes**: If you want to have multiple email addresses, you should use **virtual mailboxes**. This allows you to manage many email addresses (`evaluation`, `freebus`, etc.) without creating system users for each email.


   - You need to add virtual mailbox support in **Postfix**.
   - Edit `/etc/postfix/main.cf` and add:
     ```
      # Virtual email to be defined after in /etc/postfix/virtual
      virtual_alias_domains = nathabee.de
      virtual_alias_maps = hash:/etc/postfix/virtual_aliases

      # configure postfix to use dovecot LMTP
      virtual_transport = lmtp:unix:private/dovecot-lmtp
      virtual_mailbox_domains = nathabee.de
      virtual_mailbox_maps = hash:/etc/postfix/virtual_mailboxes
      virtual_mailbox_base = /var/mail/vhosts

     ```
   - Create or edit `/etc/postfix/virtual`:
     ```
      evaluation@nathabee.de    nathabee.de/evaluation/
      freebus@nathabee.de       nathabee.de/freebus/
      admin@nathabee.de         nathabee@gmail.com

     ```
   - **Map mailboxes to folders**: After editing the virtual file, run:
     ```bash
  sudo postmap /etc/postfix/virtual_aliases
sudo postmap /etc/postfix/virtual_mailboxes

     ```
   - **Reload Postfix**:
     ```bash
     sudo systemctl restart postfix
     ```


## Using Aliases for Forwarding  (TO BE TESTED )

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

