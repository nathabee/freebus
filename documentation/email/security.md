### Authentication and Security
<!-- TOC -->
    - [Authentication and Security](#authentication-and-security)
    - [Other consideration](#other-consideration)
<!-- TOC END -->


To ensure the email setup is **secure**:

1. **TLS Encryption**:
   - Configure **Postfix** and **Dovecot** to use **TLS** encryption to secure emails in transit.
   - Obtain an **SSL certificate** (using **Let's Encrypt**, for example) and configure Postfix and Dovecot to use it.

2. **SPF, DKIM, DMARC**:
   - Set up **SPF**, **DKIM**, and **DMARC** in your DNS settings (via YourCloudProvider's DNS console) to authenticate your outgoing emails and improve their deliverability.
   - SPF ensures that only your server is authorized to send emails for your domain.
   - DKIM adds a signature to the email header that verifies its authenticity.
   - DMARC helps receiving servers decide what to do if emails fail SPF or DKIM checks.

To set up email addresses like `evaluation@nathabee.de`, `freebus@nathabee.de`, and `admin@nathabee.de` on your YourCloudProvider cloud instance using your domain (`nathabee.de`), you'll need to configure certain aspects within the **YourCloudProvider console**, specifically in the **DNS** management section. This configuration will ensure that:

- Emails are routed to your server.
- Emails sent from your server are authenticated properly to prevent them from being marked as spam.

Here's a breakdown of what exactly you should do within the YourCloudProvider console:

#### Step-by-Step DNS Configuration Using the YourCloudProvider Console

1. **Log in to Your YourCloudProvider Console**:
   - Log in to YourCloudProvider's cloud console at [console.YourCloudProvider.cloud](https://console.YourCloudProvider.cloud/).
   - Go to the **DNS** section where you manage your domain (`nathabee.de`).

2. **Add an MX Record (Mail Exchange Record)**:
   - **Purpose**: The MX record is used to direct emails for your domain (`nathabee.de`) to your mail server.
   - **What to Do**:
     1. Add an **MX Record** to your domain settings in the YourCloudProvider console.
     2. Use the IP address or the hostname of your YourCloudProvider cloud server as the destination.
     3. Example setup:
        - **Type**: MX
        - **Host**: `@` (represents the root domain, `nathabee.de`)
        - **Value**: `mail.nathabee.de` (this should point to your server where Postfix is running)
        - **Priority**: `10` (use a low value like `10` to make this server a primary email handler)

   - You can create multiple MX records if you have multiple mail servers for failover purposes.

3. **Add an A Record for Your Mail Server**:
   - **Purpose**: Point `mail.nathabee.de` to the correct IP address of your server.
   - **What to Do**:
     1. Add an **A Record** that associates `mail.nathabee.de` with the IP address of your cloud instance.
     2. Example setup:
        - **Type**: A
        - **Host**: `mail`
        - **Value**: `<your-server-ip>` (IP address of your YourCloudProvider cloud instance)
   - This will make `mail.nathabee.de` resolve to your YourCloudProvider cloud server, which is crucial for routing email traffic.

4. **Add an SPF Record (Sender Policy Framework)**:
   - **Purpose**: SPF helps prevent spammers from sending unauthorized emails on behalf of your domain. This tells recipient servers which IP addresses are allowed to send emails on behalf of `nathabee.de`.
   - **What to Do**:
     1. Add a **TXT Record** to specify which servers are allowed to send mail.
     2. Example setup:
        - **Type**: TXT
        - **Host**: `@`
        - **Value**: `"v=spf1 ip4:<your-server-ip> -all"`
        - Replace `<your-server-ip>` with the actual IP address of your YourCloudProvider cloud server.
        - The `-all` part indicates that only the listed IP address is allowed to send email, and all others should be rejected.

5. **Add a DKIM Record (DomainKeys Identified Mail)**:
   - **Purpose**: DKIM adds a digital signature to your outgoing emails, helping recipients verify that the email was sent by you and has not been altered.
   - **What to Do**:
     - After setting up DKIM on your mail server (e.g., with `opendkim`), you will get a **public key** that needs to be added to your DNS.
     - Add a **TXT Record** to the DNS configuration in the YourCloudProvider console:
       - **Type**: TXT
       - **Host**: `default._domainkey`
       - **Value**: `"v=DKIM1; k=rsa; p=<your-public-key-here>"` (replace `<your-public-key-here>` with the actual public key generated on your server)

6. **Add a DMARC Record**:
   - **Purpose**: DMARC tells email receivers what to do if an email fails SPF and/or DKIM checks, providing more information on the legitimacy of emails.
   - **What to Do**:
     1. Add a **TXT Record** for DMARC:
        - **Type**: TXT
        - **Host**: `_dmarc`
        - **Value**: `"v=DMARC1; p=none; rua=mailto:dmarc-reports@nathabee.de"`
        - The **`p=none`** setting means that failed messages will still be delivered but flagged. You can adjust this setting to `reject` or `quarantine` later, once you're confident in the setup.
 
7. **Reverse DNS (rDNS/PTR Record)**:
   - **Purpose**: Reverse DNS is important to prevent your outgoing emails from being marked as spam. It associates your server IP address with a hostname (`mail.nathabee.de`).
   - **What to Do**:
     - In the YourCloudProvider console, look for the **Reverse DNS** or **rDNS** section for your cloud server.
     - Set the **PTR record** for your server IP to point to `mail.nathabee.de`.


A **PTR Record** (Reverse DNS) maps your **IP address** back to a **hostname**, which is the opposite of what an **A record** does. Configuring a **PTR record** is crucial for email servers because many receiving mail servers check for a PTR record as an anti-spam measure.



 **Step-by-Step Guide to Setting Up PTR (Reverse DNS):**

7.1. **Log in to YourCloudProvider Console**:

   - Log in to your YourCloudProvider account where you manage your **cloud server**.
 
7.2. **Select Your Server**:
   - In the dashboard, locate and click on the server for which you want to set the PTR record.

7.3. **Navigate to Networking Settings**:
   - Click on the "Networking" tab or section associated with your selected server.

7.4. **Edit the Reverse DNS Entry**:
   - You'll see a list of your server's IP addresses.
   - Next to the IP address you wish to configure, there should be an option to edit the Reverse DNS (rDNS) entry.
   - Click on the edit icon or link.

7.5. **Set the PTR Record**:
   - Enter the Fully Qualified Domain Name (FQDN) you want the IP address to resolve to, such as `mail.nathabee.de`.
   - Save or apply the changes.


###  Other consideration
 **SSL/TLS Certificates for Secure Email**:
   - **Purpose**: To secure email traffic, Postfix should be configured to use SSL/TLS certificates.
   - **What to Do**:
     - Obtain an SSL certificate for `mail.nathabee.de`. You can use **Let’s Encrypt** (free SSL certificate provider).
     - Use this SSL certificate in your Postfix and Dovecot configurations for secure connections.

**Email Address Management**:
   - **Aliases vs. Virtual Mailboxes**:
     - You can use **virtual mailboxes** to create independent mailboxes for `evaluation@nathabee.de`, `freebus@nathabee.de`, and `admin@nathabee.de`. This requires you to set up mail folders for each address.
     - Alternatively, you can use **aliases** to forward all emails to a single admin inbox, simplifying the management.

**Webmail Access (Optional)**:
   - You can use **Roundcube** or similar software to provide webmail access for `evaluation`, `freebus`, `admin`, etc.
   - This webmail can be installed on your YourCloudProvider cloud instance and provide an interface where you can access all configured mailboxes.

