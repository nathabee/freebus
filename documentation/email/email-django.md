

# Configure Django to Use Postfix

<!-- TOC -->
- [Configure Django to Use Postfix](#configure-django-to-use-postfix)
  - [Configure Django to Use Postfix](#configure-django-to-use-postfix)
  - [Test Sending Emails](#test-sending-emails)
<!-- TOC END -->


You already have a domain (`nathabee.de`) and hosting on a cloud server. This makes it possible to set up email communication without incurring additional recurring costs. After installing and  configure Postfix:

## Configure Django to Use Postfix
   Update the `settings.py` file in your Django project to use Postfix for email sending:

   ```python
   EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
   EMAIL_HOST = 'localhost'
   EMAIL_PORT = 25
   EMAIL_USE_TLS = False
   EMAIL_USE_SSL = False
   DEFAULT_FROM_EMAIL = 'freebus@nathabee.de'  # Replace with a valid email address
   ```

## Test Sending Emails
   You can create a test view or use Django's built-in management commands to send an email:

   ```bash
   python manage.py shell
   ```

   ```python
   from django.core.mail import send_mail
   send_mail('Subject here', 'Here is the message.', 'your_email@nathabee.de', ['recipient@example.com'], fail_silently=False)
   ```
 

