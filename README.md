# freebus
 
The aim of this project is to define, specify, and code the FreeBus project using limited human resources and expertise. The specification and development are done with prompt engineering, based on ChatGPT and Canvas.




![Milestones Diagram](https://nathabee.de/freebus/UserRole.png) 



## OBJECTIVE:
The Citizen Bus project aims to address the mobility challenges faced by older individuals who may struggle to access essential services like bakeries, butchers, and supermarkets due to limited mobility or lack of transportation options. Our initiative offers a free bus service to anyone interested, regardless of age, with the option for passengers to make voluntary donations to support the service. To enhance accessibility and convenience, we are developing a mobile application that facilitates seat reservations for the Citizen Bus service.

The app will enable users to easily book seats on the Citizen Bus, providing a seamless and efficient way to secure transportation to their desired destinations. With intuitive features and a user-friendly interface, the app aims to empower individuals to independently arrange their travel plans, promoting autonomy and social inclusion among older citizens. By leveraging technology to support the Citizen Bus service, we strive to enhance mobility options for vulnerable populations and foster a sense of community support and connectivity.

## ARCHITECTURE:

 

- **Frontend**: The frontend will use Next.js 19 combined with React for creating an interactive and dynamic user experience. The user will access the application through the domain `nathabee.de/freebus`, served via Apache.
- **Backend**: The backend will leverage the server-side features of Next.js to communicate with the Django backend, which is hosted on the same server but not accessed directly from the frontend. This backend setup is located in the cloud, running on an Ubuntu environment.
- **Database**: The backend will also integrate with a MySQL (MariaDB) database, which stores user information, reservations, and other relevant data.
- **Server & Domain**: The backend and frontend are hosted under the domain `nathabee.de`. The frontend is available at `nathabee.de/freebus`, while the backend remains internal.
- **Continuous Integration/Continuous Deployment (CI/CD)**: Jenkins will handle the CI/CD processes to ensure smooth deployments, testing, and updates.
- **Code Repository**: The source code for the entire project will be stored in the GitHub repository named `freebus`, which is associated with the `nathabee` user.


![Architecture Diagram](https://nathabee.de/chartDiagramFreeBus.png) 

 
## REQUIREMENTS:

- **User Interface (UI)**: The application will provide a clean, intuitive UI to allow users of all ages to easily navigate, make seat reservations, and view trip details.
- **Accessibility**: Designed to comply with WCAG standards to ensure older individuals can comfortably use the app. Features include larger buttons, clear labels, voice compatibility, and high-contrast mode.
- **Login & Registration**: Users will be able to register and log in using a simple authentication system. Passwords will be securely stored, and users can reset passwords as needed.
- **Reservation System**: Users will have access to a calendar-based reservation system to view available seats and make bookings. The system will show real-time seat availability.
- **Notifications**: The frontend will integrate notifications to inform users about reservation status, cancellations, or reminders for upcoming trips.
- **Performance Optimization**: The frontend will utilize code-splitting, lazy loading, and caching to improve performance, ensuring that even older devices can run the application smoothly.
- **Multi-Language Support**: The interface will be multilingual, supporting multiple languages to cater to diverse communities.
- **Error Handling**: User-friendly error messages will guide users in case of invalid inputs or other issues, improving the overall user experience.


  

## USER INTERFACE Specification

- **Menu Navigation**: The main menu will include options such as `Home`, `Reservation`, `Ticket History`, `User Dashboard`, and `Admin Tools`. The visibility of these options will be role-dependent.

  - **Overview** view of the FreeBus services and announcements.
  - **Reservation**: Allows users to view the available routes, select a date from the calendar, and reserve a seat.
  - **Ticket History**: Displays past and upcoming reservations along with ticket details.
  - **User Dashboard**: Provides access to personal information, allowing users to update contact details or view reservation history.
  - **Admin Tools**: Accessible only by users with admin or supervisor roles to manage users, reservations, routes, and calendars.

- **Role-Based Access Control**: Depending on the user role, menu items and features will vary. For example, supervisors will have the ability to modify user data, while regular users can only make reservations.

### global layout of the application will consist of:

\*\*Header\*\*: A navigation bar at the top of the page with the main menu options. The active menu item will be highlighted to provide a clear indication of the user's current page.

\*\*Main Window\*\*: The center of the screen will display the primary content. By default, the \*\*Home\*\* page will be shown, but once the user is logged in, it will switch to the \*\*Dashboard\*\* view.

\*\*Footer\*\*: A footer at the bottom of the page, which can include links to contact information, privacy policies, or other relevant details.


### User Registration and Validation

- Users register through a form with required details (name, email, address, disabilities).

- Users are put into a pending state until validated by an admin.

- \*\*Admin Validation Process\*\*: Admins can review, approve, request modifications, or create new users directly.



### Reservation Creation

- Users navigate to the \*\*Reservation Page\*\* to create reservations.

- Available routes are shown, allowing users to select a date, time, and destination.

- Users can modify or cancel reservations through their dashboard.

### Calendar Availability

- The \*\*Calendar Page\*\* displays routes in a calendar view.

- Only available slots are visible, showing the number of seats available.


  


## Milestones:

![Milestones Diagram](https://nathabee.de/freebus/FreebusMilestones.png) 


- **Team**: The development team is led by a developer with strong foundational knowledge of Next.js, having recently completed an intensive 80-day development program.

- **Project Start Date**: November 15, 2024

- **Project Kickoff**: Establish project requirements, form the development team, and create a detailed project plan. Target Completion: November 22, 2024

- **UI/UX Design**: Design a user-friendly interface and create mockups that prioritize accessibility and ease of use. Target Completion: December 6, 2024

- **Backend & Frontend Development**: Develop the core functionalities for both frontend (React + Next.js) and backend (Django REST API). Target Completion: January 17, 2025

- **Integration & Testing**: Integrate frontend and backend, followed by comprehensive testing to ensure functionality, performance, and security. Target Completion: February 7, 2025

- **Beta Testing & Feedback**: Conduct beta testing with a focus group of users, gather feedback, and make necessary improvements. Target Completion: February 28, 2025

- **Deployment**: Deploy the application to the production server and perform final checks to ensure stability. Target Completion: March 7, 2025

- **Ongoing Support & Updates**: Provide ongoing maintenance, add new features based on user feedback, and ensure the system remains up-to-date and secure. Starts: March 8, 2025

## Workflow Overview:

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

### Admin Management:
- **Admins** oversee the entire system, managing bus routes, the calendar, seat availability, user accounts, and roles.

### Supervision Management:
- **Supervisors** oversee the booking system, verify booked routes, manage routes and calendar entries, and oversee user personal information.

