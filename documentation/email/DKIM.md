### DKIM
<!-- TOC -->
    - [DKIM](#dkim)
<!-- TOC END -->

Now that you've set up **Postfix**, the **DNS records (A, MX, SPF, DMARC)**, the next step is to configure **DKIM (DomainKeys Identified Mail)** using **OpenDKIM** to sign outgoing emails. This will add a layer of authenticity to your emails and help prevent them from being flagged as spam. Additionally, I'll explain how to create a **PTR record (Reverse DNS)** for your server's IP address, which is also crucial for good email deliverability.

Let's start with **OpenDKIM** for DKIM, followed by configuring the **PTR record**.

#### Setting Up DKIM Using OpenDKIM

**OpenDKIM** is an open-source implementation of DKIM that integrates well with **Postfix**. DKIM adds a digital signature to outgoing emails, which can be verified by the recipient's email server to ensure the authenticity of the email.

#### Step-by-Step Guide to Setting Up OpenDKIM

#### Step 1: Install OpenDKIM
First, install **OpenDKIM** and **OpenDKIM tools**:

```bash
sudo apt-get update
sudo apt-get install opendkim opendkim-tools
```

#### Step 2: Configure OpenDKIM

1. **Edit the OpenDKIM Configuration** (`/etc/opendkim.conf`):

   Open the **OpenDKIM** configuration file in your preferred editor:
   ```bash
   sudo nano /etc/opendkim.conf
   ```
   
   Make sure the following lines are set (add them if they’re not present):
   ```bash
   AutoRestart             Yes
   AutoRestartRate         10/1h
   Syslog                  Yes
   SyslogSuccess           Yes
   LogWhy                  Yes

   UMask                   002

   Domain                  nathabee.de
   KeyFile                 /etc/opendkim/keys/nathabee.de/default.private
   Selector                default
   Mode                    sv
   SubDomains              Yes

   Socket                  inet:12301@localhost
   OversignHeaders         From
   ```

   **Explanation**:
   - **Domain**: Specifies your domain name (`nathabee.de`).
   - **KeyFile**: Path to the private key that will be used for signing emails.
   - **Selector**: `default` is used as the selector, which is a way to identify the DKIM key.
   - **Socket**: This tells **OpenDKIM** how to communicate with **Postfix**. It listens on port `12301` on localhost.

#### Step 3: Integrate OpenDKIM with Postfix

1. **Create a Socket Directory** for OpenDKIM to communicate with Postfix:

   ```bash
   sudo mkdir -p /var/spool/postfix/opendkim
   sudo chown opendkim:opendkim /var/spool/postfix/opendkim
   ```

2. **Configure the Socket for OpenDKIM**:
   
   Edit `/etc/default/opendkim`:
   ```bash
   sudo nano /etc/default/opendkim
   ```

   Find the `SOCKET` line and change it to:

   ```bash
   SOCKET="inet:12301@localhost"
   ```

#### Step 4: Generate DKIM Keys

1. **Create the Key Directory**:

   ```bash
   sudo mkdir -p /etc/opendkim/keys/nathabee.de
   ```

2. **Generate the DKIM Key**:

   ```bash
   sudo opendkim-genkey -b 2048 -d nathabee.de -D /etc/opendkim/keys/nathabee.de -s default -v
   ```

   **Explanation**:
   - **`-b 2048`**: Specifies the key length.
   - **`-d nathabee.de`**: Your domain name.
   - **`-D /etc/opendkim/keys/nathabee.de`**: Directory where keys will be saved.
   - **`-s default`**: Selector name.

   This command will create two files in `/etc/opendkim/keys/nathabee.de`:
   - **`default.private`**: This is your private DKIM key.
   - **`default.txt`**: This contains the public key that you will add to your **DNS**.

3. **Set Permissions** for the Keys:

   ```bash
   sudo chown opendkim:opendkim /etc/opendkim/keys/nathabee.de/default.private
   sudo chmod 400 /etc/opendkim/keys/nathabee.de/default.private
   ```

#### Step 5: Add Public Key to DNS

1. **View the Contents of the `default.txt` File**:

   ```bash
   cat /etc/opendkim/keys/nathabee.de/default.txt
   ```

   You should see something like:
   ```
   default._domainkey IN TXT "v=DKIM1; k=rsa; p=MIIBIjANBgkq..." ; ----- DKIM key default for nathabee.de
   ```

2. **Add the DKIM Record to Your DNS**:

   - **Type**: TXT
   - **Name**: `default._domainkey`
   - **Value**: Everything inside the quotes (`"v=DKIM1; k=rsa; p=MIIBIjANBgkq..."`)

   This record needs to be added via the **YourCloudProvider DNS console** to associate your domain (`nathabee.de`) with this key.

#### Step 6: Configure Postfix to Use OpenDKIM

1. **Edit Postfix Configuration** (`/etc/postfix/main.cf`):

   ```bash
   sudo nano /etc/postfix/main.cf
   ```

2. **Add the Following Lines** to Integrate OpenDKIM:

   ```bash
   milter_default_action = accept
   milter_protocol = 6
   smtpd_milters = inet:localhost:12301
   non_smtpd_milters = inet:localhost:12301
   ```

#### Step 7: Restart Services

1. **Restart OpenDKIM and Postfix**:

   ```bash
   sudo systemctl restart opendkim
   sudo systemctl restart postfix
   ```

2. **Verify That OpenDKIM is Running**:

   You can verify if the services are up and running by checking their statuses:

   ```bash
   sudo systemctl status opendkim
   sudo systemctl status postfix
   ```


**Send a Test Email** to verify DKIM is working:
   - Send an email to a DKIM verification tool like **mail-tester.com** or **dkimvalidator.com**.
   - They will analyze your email headers and confirm if DKIM is correctly set up.


---