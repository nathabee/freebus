# freebus
test to create a fullstack app with canvas and chatgpt

## Objective:
The Citizen Bus project aims to address the mobility challenges faced by older individuals who may struggle to access essential services like bakeries, butchers, and supermarkets due to limited mobility or lack of transportation options. Our initiative offers a free bus service to anyone interested, regardless of age, with the option for passengers to make voluntary donations to support the service. To enhance accessibility and convenience, we are developing a mobile application that facilitates seat reservations for the Citizen Bus service.

The app will enable users to easily book seats on the Citizen Bus, providing a seamless and efficient way to secure transportation to their desired destinations. With intuitive features and a user-friendly interface, the app aims to empower individuals to independently arrange their travel plans, promoting autonomy and social inclusion among older citizens. By leveraging technology to support the Citizen Bus service, we strive to enhance mobility options for vulnerable populations and foster a sense of community support and connectivity.

## Architecture Overview:

It seems we are having some fun betting on the bugs, but let’s stay optimistic! Here’s your updated architecture overview:

![Architecture Diagram](https://nathabee.de/chartDiagramFreeBus.png) 



- **Frontend**: The frontend will use Next.js 19 combined with React for creating an interactive and dynamic user experience. The user will access the application through the domain `nathabee.de/freebus`, served via Apache.
- **Backend**: The backend will leverage the server-side features of Next.js to communicate with the Django backend, which is hosted on the same server but not accessed directly from the frontend. This backend setup is located in the cloud, running on an Ubuntu environment.
- **Database**: The backend will also integrate with a MySQL (MariaDB) database, which stores user information, reservations, and other relevant data.
- **Server & Domain**: The backend and frontend are hosted under the domain `nathabee.de`. The frontend is available at `nathabee.de/freebus`, while the backend remains internal.
- **Continuous Integration/Continuous Deployment (CI/CD)**: Jenkins will handle the CI/CD processes to ensure smooth deployments, testing, and updates.
- **Code Repository**: The source code for the entire project will be stored in the GitHub repository named `freebus`, which is associated with the `nathabee` user.

This architecture ensures a clear separation of the frontend and backend responsibilities, promotes security by not exposing the backend directly, and utilizes modern technologies to provide a smooth user experience. 





