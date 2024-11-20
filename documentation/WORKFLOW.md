
# Workflow Overview:

<!-- TOC -->
- [Workflow Overview:](#workflow-overview)
  - [Workflow :](#workflow)
    - [User Registration and Authentication:](#user-registration-and-authentication)
    - [Route Management:](#route-management)
    - [Calendar Management:](#calendar-management)
    - [Booking Process:](#booking-process)
    - [Ticket Generation:](#ticket-generation)
    - [User Dashboard:](#user-dashboard)
    - [Admin Management:](#admin-management)
    - [Supervision Management:](#supervision-management)
  - [sequence diagram :](#sequence-diagram)
  - [NOT IMPLEMENTED Workflow (NOT on the skope YET)](#not-implemented-workflow-not-on-the-skope-yet)
<!-- TOC END -->

## Workflow :

### User Registration and Authentication:
- **Authentication** ensures secure access to the booking system.
- **Django JWT** is used for the authentication process.
- **Roles** are assigned within the Django admin console. A user can have one of three roles: **supervisor**, **administrator**, or **booking privilege**.
- Any user can **register for an account**, which initially puts them in a **pending mode** that does not grant booking privileges. The user must fill out a form during registration.
- In Django, we use a **custom user model** to store user contact data, including address, telephone, age, disability flag, and disability description.
- **Supervisors** validate user data. They can also modify user details or create new users.

### Route Management:
- The **Route Model** defines the list of different activities (e.g., trips to city X, supermarket, Christmas Market, etc.). Each route is linked to a maximum number of places on the bus.
- There are also restrictions on the number of **rolators** or **wheelchairs** that can be transported per route.
- **Route Modification History**: Maintain a **history log** or **audit trail** of modifications to routes, such as changes in max capacity, schedules, etc. This helps track changes for accountability.
- **Route Filtering and Search**: Add functionality for filtering or searching routes based on **date**, **availability**, or **specific characteristics** (e.g., wheelchair accessibility). This improves user experience when there are many route options.


### Calendar Management:
- The **Calendar Model** defines which routes are planned for which day.
- Routes can be scheduled for **weekly** or **monthly** trips. Each calendar entry is linked to a specific route and contains information on the number of available seats.
- The calendar is also linked to **booking entries**, allowing users to reserve seats for a specific route and date.

### Booking Process:
- Users access the **booking page** to select a route and a date from the calendar.
- Users confirm their selection to finalize the booking.

### Ticket Generation:
- Upon successful booking, users receive a **digital ticket** with journey details and seat information.
- Tickets can be viewed in the **ticket history** menu.

### User Dashboard:
- Users have access to a **dashboard** where they can manage bookings, view past trips, and update personal information.
- **Notifications Panel**: Include a **notifications section** where users can see system messages, updates on bookings, upcoming trips, or other important announcements.
- **Booking History Analytics**: Allow users to view **analytics** of their booking history, such as the number of trips taken, routes frequently booked, etc.
- **Favorites Feature**: Users can mark certain **routes as favorites** for quicker bookings in the future.

### Admin Management:
- **Admins** oversee the entire system, managing bus routes, the calendar, seat availability, user accounts, and roles.
- **Analytics and Reporting**: Provide administrators with **analytics** on usage statistics, route popularity, user engagement, etc. This can help optimize resource allocation and identify potential improvements.

### Supervision Management:
- **Supervisors** oversee the booking system, verify booked routes, manage routes and calendar entries, and oversee user personal information.
- **Supervisor Dashboards**: Provide supervisors with **dashboards** that display metrics such as pending user verifications, upcoming bookings requiring validation, and recently modified routes.




## sequence diagram :



![Sequence workflow Diagram](https://github.com/nathabee/freebus/blob/main/documentation/png/freebusSeqDiagReservation.png) 

- Sequence Diagram Structure
- User initiates the reservation.

- Interaction: User -> Frontend Application (Select route & date)
- Frontend Application sends request to Backend.

- Interaction: Frontend Application -> Backend (Check availability)
- Backend checks Database for availability.

- Interaction: Backend -> Database (Query available seats)
- Interaction: Database -> Backend (Return availability status)
- Backend responds to Frontend.

- If seats available:
- Interaction: Backend -> Frontend Application (Seats available, confirm details)
- If no seats available:
- Interaction: Backend -> Frontend Application (Seats unavailable)
- User confirms the reservation.

- Interaction: User -> Frontend Application (Confirm reservation)
- Frontend Application sends final confirmation to Backend.

- Interaction: Frontend Application -> Backend (Confirm reservation)
- Backend saves reservation in Database.

- Interaction: Backend -> Database (Save reservation details)
- Backend triggers Notification System to inform User.

- Interaction: Backend -> Notification System (Send reservation confirmation)
- Notification System sends confirmation to User.

- Interaction: Notification System -> User (Confirmation of reservation)
- Backend sends success response to Frontend Application.

- Interaction: Backend -> Frontend Application (Reservation successful)
- Frontend Application displays confirmation to User.

- Interaction: Frontend Application -> User (Reservation confirmed)




## NOT IMPLEMENTED Workflow (NOT on the skope YET)


#### 1.  **NOT IMPLEMENTED User Registration and Authentication:**
   - **Email Verification**: After user registration, consider adding an **email verification step**. This ensures that users provide a valid email address and helps in preventing spam registrations.
   - **Account Activation Flow**: Since users start in **pending mode**, you might add an automated or semi-automated **notification** (e.g., email or SMS) to supervisors to let them know when a new account needs validation. This would speed up the validation process.
   - **Forgot Password / Password Reset**: A **password reset flow** is an important feature for users who may forget their password. Using Django’s built-in password reset capabilities, you can provide a secure link via email.
   - **Multi-Factor Authentication (MFA)** (Optional): For roles like **administrators** or **supervisors**, adding MFA could improve the security of privileged accounts.

#### 2. **NOT IMPLEMENTED Role-Based Access Control (RBAC):**
   - **Role Permissions Granularity**: Consider more granular permissions for roles. For instance:
     - **Administrators** can access everything, but maybe you want **booking privilege users** to have the ability to view certain data but not modify it.
     - Use Django’s **Permissions Framework** to ensure specific actions are only allowed by users with the proper roles.

#### 3. **Route Management:**
   - **Maximum Capacity Notifications**: Implement notifications for **administrators** or **supervisors** when a route is approaching maximum capacity for seats, **wheelchairs**, or **rolators**.

#### 4. **Calendar Management:**
   - **Recurring Event Creation**: Your system already supports weekly or monthly trips. Consider adding a feature to easily **duplicate recurring events**, which could simplify scheduling similar routes.
   - **Conflict Detection**: Add a check to ensure there are no **conflicting entries** in the calendar (e.g., the same bus assigned to two routes at the same time).
   - **Notifications for Changes**: If there are changes to routes that affect users with existing bookings, send **notifications** to the affected users (e.g., if a route is cancelled or the date changes).

#### 5. **Booking Process:**
   - **Booking Restrictions and Rules**: Add **business rules** such as:
     - **Booking Limits**: Users can only book a **limited number of trips** within a certain period to avoid overuse.
     - **Cancellation Policy**: Add a **cancellation policy** that allows users to cancel bookings up to a specific date before the route. Make sure users are aware of any restrictions.
   - **Waitlisting Feature**: Implement a **waitlist** for fully booked routes, so if a user cancels, someone on the waitlist is notified that a seat is available.

#### 6. **Ticket Generation:**
   - **QR Code or Barcode on Tickets**: Adding a **QR code** or **barcode** to the digital ticket can improve the boarding process. Supervisors or drivers can quickly scan the ticket to confirm boarding.
   - **Download or Print Option**: Allow users to **download** or **print** their tickets. This is particularly useful if internet connectivity might be an issue during the journey.

#### 7. **User Dashboard:** 

#### 8. **Admin Management:**
   - **Access Logs and Audit Trails**: Track **access logs** and **audit trails** for administrative actions, such as changes made to user roles or route settings. This helps maintain accountability and transparency.
   - **Bulk Actions**: Add **bulk actions** for admins to efficiently manage multiple users, routes, or bookings at the same time (e.g., approving multiple pending users).

#### 9. **Supervision Management:**
   - **User Feedback Loop**: Enable supervisors to **add feedback** or communicate with users directly through the platform (e.g., reasons for denying user access, requirements for re-verification).
   - **Escalation Paths**: If an issue arises that a supervisor cannot handle, there should be an **escalation path** to an administrator for further review.

#### 10. **Notifications and Communication:**
   - **Email/SMS Notifications**: Ensure that important events trigger **notifications**, such as:
     - **Booking confirmations**
     - **Booking cancellations**
     - **Route modifications** that impact users
     - **Account status updates** (e.g., registration approval)
   - **In-App Messaging**: If the system grows, consider adding **in-app messaging** for easier communication between users and supervisors/administrators.
   - **Reminders**: Send **reminders** to users before an upcoming trip or when a new schedule for a favorite route becomes available.

#### 11. **Audit and Logs:**
   - **User Activity Log**: Track user activity, such as login times, booking attempts, and cancellation actions.
   - **Booking and Payment History**: If you add a payment system in the future, consider keeping a **booking and payment log** for each user that supervisors or admins can access if needed.

#### 12. **Performance and Scaling Considerations:**
   - **Database Indexing**: As your data grows (routes, users, bookings), ensure that your database models have the appropriate **indexes** to support efficient querying.
   - **Load Testing**: Test the system under **load conditions** to ensure it can handle a large number of bookings, user registrations, or concurrent route updates.
   - **Caching**: Implement **caching** for frequently accessed data, such as route schedules or seat availability, to improve performance.

