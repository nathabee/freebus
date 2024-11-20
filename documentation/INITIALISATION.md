## PROJECT INITIALISATION:
 

<!-- TOC -->
  - [PROJECT INITIALISATION:](#project-initialisation)
    - [hier this is how i created the first time :](#hier-this-is-how-i-created-the-first-time)
    - [Set Up the Root Directory](#set-up-the-root-directory)
    - [Create the Backend Directory](#create-the-backend-directory)
    - [Create the Frontend Directory](#create-the-frontend-directory)
    - [Final Directory Structure](#final-directory-structure)
    - [Additional Configuration](#additional-configuration)
    - [Running the Development Servers](#running-the-development-servers)
<!-- TOC END -->


### hier this is how i created the first time :
Absolutely! I will guide you through the command sequence to create this project structure from scratch. This will cover setting up the Django backend and the Next.js frontend, creating the appropriate folders, and initializing everything in the desired structure.

Here is how you can do it step by step:

### Set Up the Root Directory
First, create the root folder and navigate into it:

```bash
mkdir freebus
cd freebus
```

### Create the Backend Directory
Create a directory for the backend and navigate into it:

```bash
mkdir backend
cd backend
```

#### 2.1: Set Up Django
1. **Create a Virtual Environment**:
   Create a virtual environment (recommended to keep dependencies isolated):
   ```bash
   python3 -m venv env
   ```

2. **Activate the Virtual Environment**:
   - **Linux/macOS**:
     ```bash
     source env/bin/activate
     ```
   - **Windows**:
     ```bash
     .\env\Scripts\activate
     ```

3. **Install Django**:
   Install Django inside the virtual environment:
   ```bash
   pip install django
   ```

4. **Start the Django Project**:
   Start the project with the name `django_settings`:
   ```bash
   django-admin startproject django_settings .
   ```

   This creates the project configuration (including `settings.py`, `urls.py`, etc.) in the `django_settings` folder.

#### 2.2: Create the Django App
Now that the Django project is created, we will create a Django app named `django_freebus`:

```bash
python manage.py startapp django_freebus
```

After executing these commands, you should have a structure like:

```
backend/
├── django_settings/   # Contains settings.py, urls.py, etc.
├── django_freebus/    # Contains models, views, serializers, etc.
└── manage.py          # Django management script
```

#### 2.3: Register the App with the Django Project
1. Add the app to the `INSTALLED_APPS` list in `django_settings/settings.py`:

   ```python
   INSTALLED_APPS = [
       ...
       'django_freebus',
   ]
   ```

2. **Backend Directory Overview**:
   To better organize backend development, you can add additional elements like `requirements.txt` for dependencies:
   ```bash
   pip freeze > requirements.txt
   ```

### Create the Frontend Directory
Go back to the root directory (`freebus`) and create the `frontend` directory:

```bash
cd ..
mkdir frontend
cd frontend
```

#### 3.1: Create the Next.js App
Use the `create-next-app` command to initialize a new Next.js project:

```bash
npx create-next-app@latest .
```

You'll be prompted to enter a project name, but since we're already inside the `frontend` folder, you can just proceed with the defaults. This command will create all the necessary files for a Next.js application in the `frontend` folder.

### Final Directory Structure
Now your directory should look like this:

```
freebus/                   # Root directory
├── backend/               # Backend directory for Django
│   ├── django_settings/   # Project settings and configurations
│   ├── django_freebus/    # Django app with models, views, serializers, etc.
│   ├── manage.py          # Django management script
│   └── requirements.txt   # Python dependencies for the backend
└── frontend/              # Frontend directory for Next.js
    ├── package.json       # Node.js dependencies for the frontend
    ├── next.config.js     # Next.js configuration
    ├── pages/             # Pages for your frontend application
    ├── components/        # React components
    └── ...                # Other frontend-specific files
```

### Additional Configuration
#### Backend
- **CORS Headers**:
  Install `django-cors-headers` to allow the frontend to communicate with the backend:
  ```bash
  pip install django-cors-headers
  ```

  Add it to `INSTALLED_APPS` in `django_settings/settings.py`:

  ```python
  INSTALLED_APPS = [
      ...
      'corsheaders',
  ]

  MIDDLEWARE = [
      ...
      'corsheaders.middleware.CorsMiddleware',
      ...
  ]

  CORS_ALLOWED_ORIGINS = [
      'http://localhost:3001',  # Allow frontend requests
  ]
  ```

#### Frontend
- **Axios or Fetch API**:
  Install Axios for HTTP requests if desired:

  ```bash
  npm install axios #### we do not do that because we want to fetch fromn server side in freebus
  ```

  Alternatively, use the built-in `fetch()` function.

- **.env File**:
  Create a `.env.local` file in the `frontend` folder for environment variables:

  ```
  NEXT_PUBLIC_API_URL=http://localhost:8081/api/
  ```

### Running the Development Servers

#### Backend (Django)
Navigate to the `backend` directory and start the server:

```bash
cd ../backend
source env/bin/activate  # Activate the virtual environment
python manage.py migrate  # Apply migrations
python manage.py runserver   8081 # Start Django server
```

This will start the backend server at `http://localhost:8081`.

#### Frontend (Next.js)
Open another terminal, navigate to the `frontend` directory, and start the frontend server:

```bash
cd ../frontend
npm run dev -- -p 3001
```

This will start the Next.js server at `http://localhost:3001`.

 
 