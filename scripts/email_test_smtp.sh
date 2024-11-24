#!/bin/bash

# Check if enough arguments are passed
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <email> <password> <recipient> <smtp_server>"
    echo "Example: $0 evaluation@nathabee.de yourpassword recipient@example.com mail.nathabee.de"
    exit 1
fi

# Command-line arguments
EMAIL="$1"
PASSWORD="$2"
RECIPIENT="$3"
SMTP_SERVER="$4"

# Encode email and password in Base64
EMAIL_BASE64=$(echo -n "$EMAIL" | base64)
PASSWORD_BASE64=$(echo -n "$PASSWORD" | base64)

# Run SMTP commands via OpenSSL
openssl s_client -connect "$SMTP_SERVER:587" -starttls smtp << EOF
EHLO $SMTP_SERVER
AUTH LOGIN
$EMAIL_BASE64
$PASSWORD_BASE64
MAIL FROM:<$EMAIL>
RCPT TO:<$RECIPIENT>
DATA
From: $EMAIL
To: $RECIPIENT
Subject: Test Email from SMTP Script

This is a test email sent using a dynamic SMTP test script.
.
QUIT
EOF
