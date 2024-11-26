# Project Work Log

![⏱️](https://img.icons8.com/emoji/48/stopwatch-emoji.png) **Total Hours Worked**: _40 hours_ (Auto-generated)
---
<!-- TOC -->
- [Project Work Log](#project-work-log)
  - [Detailed Work Log](#detailed-work-log)
  - [Week 0 (Dates: November 15, 2024)](#week-0-dates-november-15-2024)
    - [November 15, 2024](#november-15-2024)
  - [Week 1 (Dates: from November 18 to November 22, 2024)](#week-1-dates-from-november-18-to-november-22-2024)
    - [November 18, 2024](#november-18-2024)
    - [November 19, 2024](#november-19-2024)
    - [November 20, 2024](#november-20-2024)
    - [November 21, 2024](#november-21-2024)
    - [November 22, 2024](#november-22-2024)
    - [November 22, 2024](#november-22-2024)
  - [Week 2 (Dates: from November 25 to November 29, 2024)](#week-2-dates-from-november-25-to-november-29-2024)
    - [November 25, 2024](#november-25-2024)
    - [November 26, 2024](#november-26-2024)
  - [Week 3 (Dates: from December 1 to December 5, 2024)](#week-3-dates-from-december-1-to-december-5-2024)
    - [December 1, 2024](#december-1-2024)
  - [Tips for Using This Log](#tips-for-using-this-log)
<!-- TOC END -->

---

This document tracks the number of hours worked each day and provides a brief description of what was accomplished. It is useful to analyze the distribution of time across various activities in the project.

---
## Detailed Work Log


## Week 0 (Dates: November 15, 2024)

### November 15, 2024
- **Hours Worked**: 5 hours
- **Tasks**:
  - grob definition of the requirement
  - definition of milestones, workflow and modele
  - Initialised `nathabee/freebus` git repository with README and Documentation
  - Documentation initalisation PROJECT,ARCHITECTURE,MODELE,FRONTEND,WORKFLOW 
- **Theme**: Project Initialization 

---

## Week 1 (Dates: from November 18 to November 22, 2024)

### November 18, 2024
- **Hours Worked**: 3 hours
- **Tasks**:
  - Created initial folder structure for backend and frontend (`freebus/backend`,`freebus/frontend`,`freebus/gh_pages`).
  - Documentation initalisation WORKLOG, GH_PAGES. INITIALISATION
  - Set up Django environment and created project (`django_settings`).
  - add github hook in .git/hooks/pre-commit to remember to update this log
- **Theme**: Project Initialization, Backend Setup



### November 19, 2024
- **Hours Worked**: 6 hours
- **Tasks**:
  - Verified workflow and identified key areas for improvement.
  - Created a COMMUNICATION document detailing installation steps for a notification system using SNMP.
  - Installed and configured SNMP on `nathabee.de`.
- **Theme**:  Email system configuration
- **Progress**: SNMP successfully configured and documented. Email delivery between Postfix and Dovecot still requires troubleshooting; LMTP connection issues remain unresolved.


### November 20, 2024
- **Hours Worked**: 5 hours
- **Tasks**: 
  - automatic creation of table of content in markdown file by git commit
  - email configuration in the cloud nathabee.de
- **Theme**: Email system configuration
- **Progress**: troubleshooting; Virtual Mailbox and Unix Socket; LMTP connection issues remain unresolved.


### November 21, 2024
- **Hours Worked**: 5 hours
- **Tasks**:
  - Documenting email server configuration
  - Setting up email services on `nathabee.de` in the cloud
- **Theme**: Email System Configuration
- **Progress**: 
  - Troubleshooting completed: Resolved virtual mailbox, Unix socket issues, and LMTP connection problems.
  - Successfully configured Dovecot password authentication.
- **Pending Tasks**:
  - Configure email client access (Thunderbird).
  - Set up TLS security for server-side communications.
  - Test DKIM configuration for email authentication.
  - Create an overview document to explain the email system.
  - Integrate the email system with Django.


### November 22, 2024

- **Hours Worked**: 5 hours

- **Tasks**:
  - Documented email server configuration details.
  - Set up email services on `nathabee.de` in the cloud.

- **Theme**: Email System Configuration

- **Progress**:
  - Configured TLS security for server-side communications, addressing encryption requirements for both incoming and outgoing emails.
  - Troubleshooted Unix socket issues, specifically around the `dovecot-lmtp` connection, ensuring correct permissions and successful communication between **Postfix** and **Dovecot**.

- **Pending Tasks**:
  - Continue learning more about email server management.
  - Configure email client access, such as using **Thunderbird** for testing.
  - Finalize the TLS security setup and test for complete stability.
  - Test **DKIM** configuration to ensure proper email authentication. 
  - Create an overview document to explain the email system to other team members.
  - Integrate the email system with the **Django** application for seamless functionality.



### November 22, 2024

- **Hours Worked**: 4 hours
 
- **Tasks**:
  - Gained expertise in email server configuration, focusing on DNS, IMAP, and Postfix settings.
  - Configured and tested DNS records using tools like MXMailBox and Thunderbird.
  - Identified and resolved a Postfix misconfiguration preventing port 25 from being used.
  - Wrote unit tests for DNS records (MX, SPF, DKIM) and IMAP functionality.

- **Theme**: Email System Configuration

- **Progress**:
  - Verified DNS records passed validation tests (MX, SPF, DKIM).
  - Successfully configured Thunderbird for email testing.
  - Resolved issue with Postfix not listening on port 25 by uncommenting the `smtp` service in `/etc/postfix/master.cf`.
  - Preliminary unit tests for DNS and IMAP in place.

- **Pending Tasks**:
  - Awaiting outbound port 25 to be opened by the provider for testing server-to-server SMTP traffic.
  - Write more comprehensive unit and integration tests for SMTP and full email workflow.


---
 


## Week 2 (Dates: from November 25 to November 29, 2024)

###  November 25, 2024
- **Hours Worked**: 2 hours

- **Tasks**:
- Gained expertise in email server configuration, focusing on DNS, IMAP, and Postfix settings.
- dovecot authentification

- **Theme**: Email System Configuration

- **Progress**:
  - Troubleshooting LMTP dovecot 
  - outbound port 25 is opened by the provider for testing server-to-server SMTP traffic. 


 

###  November 26, 2024
- **Hours Worked**: 5 hours

- **Tasks**:
- Gained expertise in email server configuration, focusing on DNS, IMAP, and Postfix settings.

- **Theme**: Email System Configuration

- **Progress**:
- follow installation guide from https://gist.github.com/howyay/57982e6ba9eedd3a5662c518f1b985c7#0x05-install-and-configure-postfix
  - Reset installation  (remove + reinstalll) : Postfix, dqim, dovecot
  - create linux user for email instead of virtual box 
  - made alias to forward postmaster, abuse.. according RCF
  - port 25 activated from provider : tested and works
  - trouble shooting IPV6 : posfix conf, host cloud conf, correction of DNS reverse, and AAAA records
  - sucessfull test mail in unit test (dqim, send to extern, send in user/Maildir)

 

- **Pending Tasks**:
  - dovecot authentification in database and parametrisation
 
---
 


## Week 3 (Dates: from December 1 to December 5, 2024)

###  December 1, 2024
- **Hours Worked**: 0 hours
- **Tasks**:
  - 
- **Theme**: 
- **Progress**:

 **on going not done :**
  - Installed and configured MariaDB, updated settings for database connection.
  - Set up Django environment and created project (`django_settings`). 
  - Defined basic models for the bus data. 
  - Started implementing views and serializers.
  - Worked on the login and registration pages in Next.js.
  - Set up JWT tokens for user authentication. 
... 

---

## Tips for Using This Log
1. **Add a Section for Each Week**: It's helpful to group logs into weeks to make it easy to find particular days and also get an overview of progress week by week.
2. **Use Consistent Themes**: Try to use consistent labels for themes (e.g., "Frontend Setup", "API Integration", "Styling") to make it easier to analyze how much time was spent in different project areas.
3. **Summarize Weekly Progress**: At the end of each week, consider adding a summary that helps understand how productive the week was, what blockers were encountered, and what’s planned next.
4. **Daily Reflection**: Adding a short note about challenges faced or lessons learned each day can provide even more insight when reviewing your work.   

 