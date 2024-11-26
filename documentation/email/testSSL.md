# TEST  Configuration Review and TLS Handshake Check

<!-- TOC -->
- [TEST  Configuration Review and TLS Handshake Check](#test--configuration-review-and-tls-handshake-check)
  - [Configuration Review](#configuration-review)
    - [What to Look For](#what-to-look-for)
    - [Configuration Summary](#configuration-summary)
<!-- TOC END -->

 
 ## test SSl with doveadm


```sh
auth doveadm auth test user@example.com password

```

 
## Configuration Review


### What to Look For
- **Certificate Chain**: Make sure the **correct certificate chain** is being used, and that no errors related to **certificate verification** are shown during the connection.
- **TLS Versions and Cipher Suites**: Look at the details of the handshake to ensure that strong **TLS versions** and **ciphers** are being used. It’s common to see compatibility issues when certain weaker ciphers or older protocols (such as TLS 1.0) are disabled.

### Configuration Summary
Given the information you've shared, here's how your configuration should look after fixing the issues:

#### `/etc/postfix/main.cf`
```conf
# TLS for incoming connections
smtpd_tls_cert_file = /etc/letsencrypt/live/nathabee.de/fullchain.pem
smtpd_tls_key_file = /etc/letsencrypt/live/nathabee.de/privkey.pem
smtpd_tls_security_level = encrypt
smtpd_tls_auth_only = yes

# TLS for outgoing connections
smtp_tls_CApath = /etc/ssl/certs
smtp_tls_security_level = may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtp_tls_cert_file = /etc/letsencrypt/live/nathabee.de/fullchain.pem
smtp_tls_key_file = /etc/letsencrypt/live/nathabee.de/privkey.pem

# LMTP configuration
virtual_transport = dovecot-lmtp
mailbox_transport = dovecot-lmtp
```

#### `/etc/postfix/master.cf`
Ensure you have the LMTP transport set up correctly:

```conf
dovecot-lmtp unix - - n - - lmtp
  -o lmtp_tls_security_level=none
```
