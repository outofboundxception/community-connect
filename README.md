# Community Connect (Backend)

## 🛠️ Setup Instructions

### 1. Clone the repository

After downloading Github Desktop Clone the repo and open it in VS Code

### 2. Create and Activate Virtual Enviroment

After opening the the repo in VS code open a new terminal and run the following

#### Windows

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
venv\Scripts\activate
cd backend
pip install django djangorestframework djangorestframework-simplejwt
pip install django-filter
pip install Pillow
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser

#### Mac

source venv/bin/activate
cd backend
pip install django djangorestframework djangorestframework-simplejwt
pip install django-filter
pip install Pillow
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser

*Enter Username and password for the Super User*

python manage.py runserver

### 3. Accessible Websites

#### Now all of the following will be accessible

Register → http://127.0.0.1:8000/api/users/api/users/register/

Login (JWT) → http://127.0.0.1:8000/api/users/api/users/token/

Refresh Token → http://127.0.0.1:8000/api/users/api/users/token/refresh/

Logout (requires Refresh Token) → http://127.0.0.1:8000/api/users/api/users/logout/

Profile View / Update → http://127.0.0.1:8000/api/users/api/users/profile/ (http://127.0.0.1:8000/api/users/api/users/profile/update/)

Directory (only accessible by admin) → http://127.0.0.1:8000/api/users/api/users/directory/

