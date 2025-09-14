"""
Django settings for backend project.
"""

from pathlib import Path
from datetime import timedelta
from decouple import config
<<<<<<< HEAD
import os
from corsheaders.defaults import default_headers
=======
>>>>>>> ab65ad6da0a05a7c0d2ef018f9ccf90de67bf0a4

# =======================
# Paths
# =======================
BASE_DIR = Path(__file__).resolve().parent.parent

# =======================
# Security
# =======================
SECRET_KEY = config('SECRET_KEY', default='django-insecure-ym)p&hy@-56w(k@)pp@u5pmpe!iq=vv#vi5wkm(x-3fy3k8i0d')
DEBUG = config('DEBUG', default=True, cast=bool)
ALLOWED_HOSTS = config(
    'ALLOWED_HOSTS',
    default='127.0.0.1,localhost',
    cast=lambda v: [s.strip() for s in v.split(',')]
)

<<<<<<< HEAD
# =======================
# Installed apps
# =======================
=======
# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = config('SECRET_KEY', default='django-insecure-ym)p&hy@-56w(k@)pp@u5pmpe!iq=vv#vi5wkm(x-3fy3k8i0d')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = config('DEBUG', default=True, cast=bool)

ALLOWED_HOSTS = config('ALLOWED_HOSTS', default='127.0.0.1,localhost', cast=lambda v: [s.strip() for s in v.split(',')])


# Application definition

>>>>>>> ab65ad6da0a05a7c0d2ef018f9ccf90de67bf0a4
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
<<<<<<< HEAD

    # Third-party apps
    'corsheaders',
    'django_filters',
=======
    'corsheaders',
    'django_filters',
    'users',
    'posts',
>>>>>>> ab65ad6da0a05a7c0d2ef018f9ccf90de67bf0a4
    'rest_framework',
    'rest_framework_simplejwt.token_blacklist',

    # Your apps
    'users',
    'posts',
]

<<<<<<< HEAD
# =======================
# Middleware
# =======================
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # MUST be at the top
=======
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',  # still keep JWT
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
}

import os
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
>>>>>>> ab65ad6da0a05a7c0d2ef018f9ccf90de67bf0a4
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

<<<<<<< HEAD
# =======================
# JWT Configuration
# =======================
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=30),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=1),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
    'AUTH_HEADER_TYPES': ('Bearer',),
}

# =======================
# REST Framework
# =======================
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
}

# =======================
# CORS Configuration
# =======================
# For development, allow all origins (Flutter Web dev server)
CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
CORS_ALLOW_HEADERS = list(default_headers) + [
    'authorization',
]

# =======================
# URLs & Templates
# =======================
=======
# CORS settings
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:8080",
    "http://127.0.0.1:8080",
]

CORS_ALLOW_CREDENTIALS = True

>>>>>>> ab65ad6da0a05a7c0d2ef018f9ccf90de67bf0a4
ROOT_URLCONF = 'backend.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'backend.wsgi.application'

# =======================
# Database
# =======================
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# =======================
# Password validation
# =======================
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]

# =======================
# Internationalization
# =======================
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# =======================
# Static & Media files
# =======================
STATIC_URL = 'static/'

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# =======================
# Default primary key
# =======================
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
