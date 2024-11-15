# freebus
test to create a fullstack app with canvas and chatgpt

## Objective:
The Citizen Bus project aims to address the mobility challenges faced by older individuals who may struggle to access essential services like bakeries, butchers, and supermarkets due to limited mobility or lack of transportation options. Our initiative offers a free bus service to anyone interested, regardless of age, with the option for passengers to make voluntary donations to support the service. To enhance accessibility and convenience, we are developing a mobile application that facilitates seat reservations for the Citizen Bus service.

The app will enable users to easily book seats on the Citizen Bus, providing a seamless and efficient way to secure transportation to their desired destinations. With intuitive features and a user-friendly interface, the app aims to empower individuals to independently arrange their travel plans, promoting autonomy and social inclusion among older citizens. By leveraging technology to support the Citizen Bus service, we strive to enhance mobility options for vulnerable populations and foster a sense of community support and connectivity.

## Architecture Overview:

 

- **Frontend**: The frontend will use Next.js 19 combined with React for creating an interactive and dynamic user experience. The user will access the application through the domain `nathabee.de/freebus`, served via Apache.
- **Backend**: The backend will leverage the server-side features of Next.js to communicate with the Django backend, which is hosted on the same server but not accessed directly from the frontend. This backend setup is located in the cloud, running on an Ubuntu environment.
- **Database**: The backend will also integrate with a MySQL (MariaDB) database, which stores user information, reservations, and other relevant data.
- **Server & Domain**: The backend and frontend are hosted under the domain `nathabee.de`. The frontend is available at `nathabee.de/freebus`, while the backend remains internal.
- **Continuous Integration/Continuous Deployment (CI/CD)**: Jenkins will handle the CI/CD processes to ensure smooth deployments, testing, and updates.
- **Code Repository**: The source code for the entire project will be stored in the GitHub repository named `freebus`, which is associated with the `nathabee` user.


![Architecture Diagram](https://nathabee.de/chartDiagramFreeBus.png) 


This architecture ensures a clear separation of the frontend and backend responsibilities, promotes security by not exposing the backend directly, and utilizes modern technologies to provide a smooth user experience. 

 
## Functional Specifications:

- **User Interface (UI)**: The application will provide a clean, intuitive UI to allow users of all ages to easily navigate, make seat reservations, and view trip details.
- **Accessibility**: Designed to comply with WCAG standards to ensure older individuals can comfortably use the app. Features include larger buttons, clear labels, voice compatibility, and high-contrast mode.
- **Login & Registration**: Users will be able to register and log in using a simple authentication system. Passwords will be securely stored, and users can reset passwords as needed.
- **Reservation System**: Users will have access to a calendar-based reservation system to view available seats and make bookings. The system will show real-time seat availability.
- **Notifications**: The frontend will integrate notifications to inform users about reservation status, cancellations, or reminders for upcoming trips.
- **Performance Optimization**: The frontend will utilize code-splitting, lazy loading, and caching to improve performance, ensuring that even older devices can run the application smoothly.
- **Multi-Language Support**: The interface will be multilingual, supporting multiple languages to cater to diverse communities.
- **Error Handling**: User-friendly error messages will guide users in case of invalid inputs or other issues, improving the overall user experience.

## Model Specifications:

- **User Model**: Stores user data such as name, email, password (hashed), age, and city of residence. This data is used for user authentication, registration, and validation.
- **Reservation Model**: Contains information about user reservations, including trip date, time, destination, and seat availability. It ensures that users can reserve seats and view reservation history.
- **Bus Route Model**: Stores data on bus routes, destinations, and schedules. This allows users to see available trips and make informed decisions on reservations.
- **Admin Model**: Manages data related to admin users responsible for validating new users, managing trip schedules, and overseeing reservations. This model ensures the system remains secure and reliable.

## Milestones:

- **Team**: The development team consists of 1 developer with 80 days of Next.js experience, now proficient and no longer a beginner.

- **Project Start Date**: November 15, 2024

- **Project Kickoff**: Establish project requirements, form the development team, and create a detailed project plan. Target Completion: November 22, 2024

- **UI/UX Design**: Design a user-friendly interface and create mockups that prioritize accessibility and ease of use. Target Completion: December 6, 2024

- **Backend & Frontend Development**: Develop the core functionalities for both frontend (React + Next.js) and backend (Django REST API). Target Completion: January 17, 2025

- **Integration & Testing**: Integrate frontend and backend, followed by comprehensive testing to ensure functionality, performance, and security. Target Completion: February 7, 2025

- **Beta Testing & Feedback**: Conduct beta testing with a focus group of users, gather feedback, and make necessary improvements. Target Completion: February 28, 2025

- **Deployment**: Deploy the application to the production server and perform final checks to ensure stability. Target Completion: March 7, 2025

- **Ongoing Support & Updates**: Provide ongoing maintenance, add new features based on user feedback, and ensure the system remains up-to-date and secure. Starts: March 8, 2025

 




