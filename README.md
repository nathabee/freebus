# FreeBUS

![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)

The aim of this project is to define, specify, and code the FreeBus project using limited human resources and expertise. The specification and development are done with prompt engineering, based on ChatGPT and Canvas.

![Architecture Diagram](https://nathabee.de/freebus/chartDiagramFreeBus.png)



## Table of Contents
- [Objective](#objective)
- [Features](#features)
- [Current Status](#current-status)
- [Documentation Overview and screenshot](#documentation-overview)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Usage](#usage) 
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Credits](#credits)
- [Future Improvements](#future-improvements)
- [known issues](#known-issues)




## OBJECTIVE

The Citizen Bus project aims to address the mobility challenges faced by older individuals who may struggle to access essential services like bakeries, butchers, and supermarkets due to limited mobility or lack of transportation options...

## Features
- Free bus reservation system for the community.
- Mobile application for seat reservations.
- Voluntary donations support model.


## 🛠️ Current Status
 

- `Project started on time`: November 15, 2024



## Documentation Overview 


### Screenshots
![App Interface] (https://github.com/nathabee/freebus/blob/main/documentation/png/screenshot.png)


In the `/documentation` folder, you will find the following documents that provide detailed information about the project:


### [Project Presentation](./documentation/PROJECT.md) 
This document contains the project requirements and milestones.

### [Workflow](./documentation/WORKFLOW.md) 
A detailed explanation of the workflow used in the project, covering the different stages and roles involved.

### [Architecture Presentation](./documentation/ARCHITECTURE.md) 
An overview of the project's architecture, providing insights into the structural components and how they interact.

### [User Interface Specification](./documentation/FRONTEND.md) 
This document provides the details of the User Interface, including design specifications and guidelines.

### [Model](./documentation/MODELE.md) 
An overview of the data models used in the project, including entity relationships and core data structures.

### [Workflow](./documentation/WORKFLOW.md) 
Another in-depth document detailing the workflow, which explains how different components work together and processes flow throughout the system.


### [Initialisation](./documentation/INITIALISATION.md) 
describe how this project was initially created before github repository existence

### [Github Pages](./documentation/GH_PAGES.md) 
Explain how the github pages of this repository are made



## Project Structure
 

### folders

- `db_scripts/`: SQL scripts for initializing and seeding the database.
- `static/`: Static files (CSS, JavaScript, images).
- `tools/`: Utility scripts for managing the project.
- `Jenkinsfile`: CI/CD script for automated deployment.


- freebus/                   # Root directory (main repository)
- ├── backend/               # Backend directory for all Django-related code
- │   ├── django_settings/   # Django project folder, containing settings, URLs, wsgi.py, etc.
- │   ├── django_freebus/    # Django app containing models, views, serializers, etc.
- │   └── manage.py          # Manage script for Django
- └── frontend/              # Frontend folder with Next.js and React

### Branches

- `main`: Contains all project files (backend and frontend).
- `github-pages`: Contains the frontend export for GitHub Pages.



## Installation

To get started with FreeBUS, follow these steps... 

1. **Clone the repository**:
   ```bash
   git clone https://github.com/nathabee/freebus.git
   ```
2. **Navigate to the django project directory**:
   ```bash
   cd freebus/

  ```

3. **Navigate to the project directory**:
   ```bash
   cd freebus/frontend
  ```

4. **Install the frontend necessary dependencies**:
   - For example, if using `npm`:
     ```bash
     npm install
     ```
   - Or if you need to set up a Python environment:
     ```bash
     pip install -r requirements.txt
     ```

## Usage
- Include **examples** of how to run or use the application.
- Provide some **basic commands** to start the application.

```markdown


To run the application:

```bash
cd freebus
. venv/bin/activate
python manage.py runserver localhost:8080 --insecure
cd frontend
npm start
```

## Configuration

To run this project, you will need files to set the following environment variables:

# in freebus/backend/.env 

```bash
DJANGO_SECRET_KEY="to be defined"
DEBUG=True
DBNAME="freebusdb"
DBUSER="freedy"
DBPASSWORD="to be defined"
DBHOST="localhost"
DBPORT="3306" 
DEFAULT_USER_PASSWORD="to be defined"
DJANGO_SUPERUSER_USERNAME="freedy"
DJANGO_SUPERUSER_EMAIL="to be defined"
DJANGO_SUPERUSER_PASSWORD="to be defined"
CORS_ALLOWED_ORIGINS=http://localhost:3001
ALLOWED_HOSTS ="192.168.178.71,localhost,127.0.0.1,nathabee.de,159.69.0.127"
DJANGO_SERVER_IP="http://localhost:3001"
JWT_SECRET_KEY="to be defined"
```


# in freebus/frontend/.env.local 
```bash
NEXT_PUBLIC_ENV=developement
NEXT_PUBLIC_API_URL=http://localhost:8081/api
NEXT_PUBLIC_BASE_PATH=/freebus
NEXT_PUBLIC_ADMIN_URL=http://localhost:8081/admin/
NEXT_PUBLIC_MEDIA_URL=http://localhost:8081/media 
```


# in freebus/frontend/.env.demo 
```bash
NEXT_PUBLIC_ENV=demo
NEXT_PUBLIC_API_URL=/api
NEXT_PUBLIC_BASE_PATH=/freebus/out
NEXT_PUBLIC_ADMIN_URL=/freebus/out/demo/swagger/swagger_json.html
NEXT_PUBLIC_MEDIA_URL=/freebus/out/demo/data/ 
```


# in freebus/frontend/.env.production 
```bash
NEXT_PUBLIC_ENV=production
NEXT_PUBLIC_API_URL=https://nathabee.de/freebus/api/
NEXT_PUBLIC_BASE_PATH=/freebus
NEXT_PUBLIC_ADMIN_URL=https://nathabee.de/freebus/admin/
NEXT_PUBLIC_MEDIA_URL=http://nathabee.de/media 

```




## Usage
To run the application...

## Contributing
We welcome contributions from the community! Please read our [Contributing Guide](CONTRIBUTING.md) for guidelines on how to get started.



## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact
For inquiries or questions, reach out to:
- Name: Nathabee
- Email: nathabee123@gmail.com
 
## Credits

- Built using [Next.js 19](https://nextjs.org/), [React](https://reactjs.org/), [MariaDB](https://mariadb.org/), and [Django](https://www.djangoproject.com/).
- Diagrams generated using [ChatGPT](https://chat.openai.com/), [BlocksAndArrows.com](https://blocksandarrows.com/), and [Miro](https://miro.com/).
- Development supported with [ChatGPT-4](https://chat.openai.com/) and Canvas for prompt engineering.


## Future Improvements

- Add more language support.
- Integration with Google Calendar for reminders.

## Known Issues

- Project in development

