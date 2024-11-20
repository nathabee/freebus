
## USER INTERFACE Specification

<!-- TOC -->
  - [USER INTERFACE Specification](#user-interface-specification)
    - [global layout of the application will consist of:](#global-layout-of-the-application-will-consist-of)
    - [User Registration and Validation](#user-registration-and-validation)
    - [Reservation Creation](#reservation-creation)
    - [Calendar Availability](#calendar-availability)
<!-- TOC END -->



![User Role Diagram](https://github.com/nathabee/freebus/blob/main/documentation/png/freebusUserRole.png) 


- **Menu Navigation**: The main menu will include options such as `Home`, `Reservation`, `Ticket History`, `User Dashboard`, and `Admin Tools`. The visibility of these options will be role-dependent.

  - **Overview** view of the FreeBus services and announcements.
  - **Reservation**: Allows users to view the available routes, select a date from the calendar, and reserve a seat.
  - **Ticket History**: Displays past and upcoming reservations along with ticket details.
  - **User Dashboard**: Provides access to personal information, allowing users to update contact details or view reservation history.
  - **Admin Tools**: Accessible only by users with admin or supervisor roles to manage users, reservations, routes, and calendars.

- **Role-Based Access Control**: Depending on the user role, menu items and features will vary. For example, supervisors will have the ability to modify user data, while regular users can only make reservations.

### global layout of the application will consist of:

- Header: A navigation bar at the top of the page with the main menu options. The active menu item will be highlighted to provide a clear indication of the user's current page.

- Main Window: The center of the screen will display the primary content. By default, the Home page will be shown, but once the user is logged in, it will switch to the Dashboard view.

- Footer: A footer at the bottom of the page, which can include links to contact information, privacy policies, or other relevant details.


### User Registration and Validation

- Users register through a form with required details (name, email, address, disabilities).

- Users are put into a pending state until validated by an admin.

- Admin Validation Process: Admins can review, approve, request modifications, or create new users directly.



### Reservation Creation

- Users navigate to the Reservation Page to create reservations.

- Available routes are shown, allowing users to select a date, time, and destination.

- Users can modify or cancel reservations through their dashboard.

### Calendar Availability

- The Calendar Page displays routes in a calendar view.

- Only available slots are visible, showing the number of seats available.

