
# server configuration

<!-- TOC -->
- [server configuration](#server-configuration)
  - [User and group creation](#user-and-group-creation)
    - [vmail, postfix, dovecode](#vmail-postfix-dovecode)
    - [user for emailbox](#user-for-emailbox)
    - [alias and redirect from postfix](#alias-and-redirect-from-postfix)
  - [IPv6](#ipv6)
  - [IPv6](#ipv6)
    - [Add an Entry for mail.nathabee.de with IPv6 Based on your IPv6 address (2a01:4f8:1c1b:b3f8::1), add the following line to /etc/hosts:](#add-an-entry-for-mailnathabeede-with-ipv6-based-on-your-ipv6-address-2a014f81c1bb3f81-add-the-following-line-to-etchosts)
    - [Modify the Cloud-Init Template](#modify-the-cloudinit-template)
<!-- TOC END -->


## User and group creation

### vmail, postfix, dovecode


### user for emailbox





### alias and redirect from postfix

To test the email forwarding setup for `postmaster`, `abuse`, and `root`, you don't need to create actual Unix system accounts for these aliases. Your `/etc/aliases` file takes care of redirecting emails for these addresses. However, you should confirm that the alias setup is working as expected.
  

1. **No Need for Actual User Accounts**:
   - The aliases in `/etc/aliases` map these email addresses (`root`, `postmaster`, `abuse`) to the specified destination addresses. In your case:
     ```plaintext
     root: postmaster
     postmaster: extern_user@gmail.com
     abuse: extern_user@gmail.com
     ```
     - Emails sent to `root` will be forwarded to `postmaster`.
     - Emails sent to `postmaster` or `abuse` will be forwarded to `extern_user@gmail.com`.

2. **Verify Aliases Are Active**:
   - Ensure you ran the `newaliases` command after editing `/etc/aliases`:
     ```bash
     sudo newaliases
     ```
   - Restart Postfix to apply the changes:
     ```bash
     sudo systemctl restart postfix
     ```

---
 
---


## IPv6




## IPv6

### Add an Entry for mail.nathabee.de with IPv6 Based on your IPv6 address (2a01:4f8:1c1b:b3f8::1), add the following line to /etc/hosts:

plaintext 
2a01:4f8:1c1b:b3f8::1 mail.nathabee.de nathabee.de



### Modify the Cloud-Init Template
Edit /etc/cloud/templates/hosts.debian.tmpl and add your IPv6 entry there:




plaintext 
2a01:4f8:1c1b:b3f8::1 mail.nathabee.de nathabee.de