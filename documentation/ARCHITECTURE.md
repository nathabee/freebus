
## ARCHITECTURE:

 

- **Frontend**: The frontend will use Next.js 19 combined with React for creating an interactive and dynamic user experience. The user will access the application through the domain `nathabee.de/freebus`, served via Apache.
- **Backend**: The backend will leverage the server-side features of Next.js to communicate with the Django backend, which is hosted on the same server but not accessed directly from the frontend. This backend setup is located in the cloud, running on an Ubuntu environment.
- **Database**: The backend will also integrate with a MySQL (MariaDB) database, which stores user information, reservations, and other relevant data.
- **Server & Domain**: The backend and frontend are hosted under the domain `nathabee.de`. The frontend is available at `nathabee.de/freebus`, while the backend remains internal.
- **Continuous Integration/Continuous Deployment (CI/CD)**: Jenkins will handle the CI/CD processes to ensure smooth deployments, testing, and updates.
- **Code Repository**: The source code for the entire project will be stored in the GitHub repository named `freebus`, which is associated with the `nathabee` user.

 
 
![Architecture Diagram](https://nathabee.de/freebus/chartDiagramFreeBus.png) 