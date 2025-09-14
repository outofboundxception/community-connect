# Community Connect - Full-Stack Django + Flutter App

A modern, full-stack social media application built with Django REST Framework backend and Flutter frontend, featuring beautiful gradient UI, smooth animations, and comprehensive user management.

## 🚀 Features

### Backend (Django + DRF)
- **Authentication**: JWT-based login/signup/logout
- **User Management**: User profiles with customizable information
- **Posts**: Create, read, update, delete posts
- **Comments**: Comment system for posts
- **API**: RESTful API with proper pagination
- **Admin Panel**: Django admin interface for management
- **CORS**: Configured for Flutter frontend integration

### Frontend (Flutter)
- **Modern UI**: Gradient-based design with light/dark mode toggle
- **Smooth Animations**: Page transitions, button animations, loading states
- **Responsive Design**: Works on mobile, tablet, and web
- **State Management**: Provider pattern for reactive UI
- **Secure Storage**: JWT tokens stored securely
- **Error Handling**: Comprehensive error states and user feedback

## 📱 Screenshots

The app features:
- Beautiful splash screen with animated logo
- Gradient login/signup screens with smooth transitions
- Modern home feed with post cards
- Detailed post view with comments
- Profile management
- Theme toggle (light/dark mode)

## 🛠️ Tech Stack

### Backend
- **Django 5.0.6**: Web framework
- **Django REST Framework**: API development
- **JWT Authentication**: Secure token-based auth
- **SQLite/PostgreSQL**: Database (easily switchable)
- **CORS Headers**: Cross-origin support
- **Pillow**: Image handling

### Frontend
- **Flutter**: Cross-platform framework
- **Provider**: State management
- **HTTP**: API communication
- **Google Fonts**: Typography
- **Animations**: Smooth transitions
- **Secure Storage**: Token management

## 🚀 Getting Started

### Prerequisites
- Python 3.8+
- Flutter 3.0+
- Git

### Backend Setup

1. **Navigate to backend directory**:
   ```bash
   cd backend
   ```

2. **Create virtual environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Environment setup** (optional):
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

5. **Run migrations**:
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

6. **Create superuser** (optional):
   ```bash
   python manage.py createsuperuser
   ```

7. **Start development server**:
   ```bash
   python manage.py runserver
   ```

The API will be available at `http://127.0.0.1:8000/`

### Frontend Setup

1. **Navigate to frontend directory**:
   ```bash
   cd frontend
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   # For web
   flutter run -d chrome
   
   # For mobile (with device/emulator connected)
   flutter run
   ```

## 🔧 Configuration

### API Base URL
To change the API base URL, edit `frontend/lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://your-api-url.com/api';
```

### Database Configuration
The app uses SQLite by default. To switch to PostgreSQL:

1. Install PostgreSQL and create a database
2. Update `backend/backend/settings.py`:
   ```python
   DATABASES = {
       'default': {
           'ENGINE': 'django.db.backends.postgresql',
           'NAME': 'your_db_name',
           'USER': 'your_db_user',
           'PASSWORD': 'your_db_password',
           'HOST': 'localhost',
           'PORT': '5432',
       }
   }
   ```
3. Install PostgreSQL adapter: `pip install psycopg2-binary`

## 📚 API Endpoints

### Authentication
- `POST /api/auth/register/` - User registration
- `POST /api/auth/login/` - User login
- `POST /api/auth/logout/` - User logout
- `POST /api/auth/token/refresh/` - Refresh JWT token
- `GET /api/auth/profile/` - Get user profile
- `PUT /api/auth/profile/update/` - Update user profile

### Posts
- `GET /api/posts/` - List all posts (paginated)
- `POST /api/posts/` - Create new post
- `GET /api/posts/{id}/` - Get specific post
- `PUT /api/posts/{id}/` - Update post (owner only)
- `DELETE /api/posts/{id}/` - Delete post (owner only)

### Comments
- `GET /api/posts/{post_id}/comments/` - List post comments
- `POST /api/posts/{post_id}/comments/` - Create comment
- `PUT /api/posts/comments/{id}/` - Update comment (owner only)
- `DELETE /api/posts/comments/{id}/` - Delete comment (owner only)

## 🎨 Theme & UI

The app features a modern gradient-based design with:

### Color Scheme
- **Primary**: Indigo (#6366F1)
- **Secondary**: Purple (#8B5CF6)
- **Accent**: Pink (#EC4899)

### Features
- **Light/Dark Mode**: Toggle between themes
- **Smooth Animations**: Page transitions, button press effects
- **Responsive Design**: Adapts to different screen sizes
- **Modern Typography**: Google Fonts (Inter)
- **Gradient Backgrounds**: Beautiful color transitions
- **Card-based Layout**: Clean, organized content presentation

### Animations
- **Splash Screen**: Animated logo and fade-in effects
- **Page Transitions**: Smooth navigation between screens
- **Button Interactions**: Scale and color animations
- **Loading States**: Animated loading indicators
- **Text Fields**: Focus animations and scaling effects

## 🏗️ Project Structure

### Backend Structure
```
backend/
├── backend/
│   ├── settings.py      # Django settings
│   ├── urls.py          # Main URL configuration
│   └── wsgi.py          # WSGI configuration
├── users/
│   ├── models.py        # User profile models
│   ├── views.py         # Authentication views
│   ├── serializers.py   # API serializers
│   └── urls.py          # User URLs
├── posts/
│   ├── models.py        # Post and Comment models
│   ├── views.py         # Post/Comment views
│   ├── serializers.py   # Post/Comment serializers
│   └── urls.py          # Post URLs
└── requirements.txt     # Python dependencies
```

### Frontend Structure
```
frontend/
├── lib/
│   ├── main.dart           # App entry point
│   ├── theme/
│   │   └── app_theme.dart  # Theme configuration
│   ├── providers/          # State management
│   │   ├── auth_provider.dart
│   │   ├── post_provider.dart
│   │   └── theme_provider.dart
│   ├── services/
│   │   └── api_service.dart # API communication
│   ├── models/             # Data models
│   │   ├── user_model.dart
│   │   ├── post_model.dart
│   │   └── comment_model.dart
│   ├── screens/            # UI screens
│   │   ├── auth/
│   │   ├── home_screen.dart
│   │   ├── profile_screen.dart
│   │   └── ...
│   └── widgets/            # Reusable components
│       ├── animated_button.dart
│       ├── post_card.dart
│       └── ...
└── pubspec.yaml           # Flutter dependencies
```

## 🔒 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Token Refresh**: Automatic token renewal
- **Secure Storage**: Encrypted token storage on device
- **CORS Configuration**: Proper cross-origin setup
- **Input Validation**: Client and server-side validation
- **Permission Checks**: User-based access control

## 🚀 Deployment

### Backend Deployment
1. Set environment variables for production
2. Configure PostgreSQL database
3. Set `DEBUG=False` in settings
4. Configure static files serving
5. Use a production WSGI server (e.g., Gunicorn)

### Frontend Deployment
1. **Web**: `flutter build web` and deploy to hosting service
2. **Mobile**: Build APK/IPA and distribute through app stores

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🆘 Support

If you encounter any issues or have questions:

1. Check the existing issues on GitHub
2. Create a new issue with detailed information
3. Include steps to reproduce any bugs
4. Provide system information (OS, Flutter/Python versions)

## 🎯 Future Enhancements

- [ ] Real-time notifications
- [ ] Image upload for posts
- [ ] User following system
- [ ] Post likes and reactions
- [ ] Search functionality
- [ ] Push notifications
- [ ] Social media sharing
- [ ] Advanced user profiles
- [ ] Content moderation
- [ ] Analytics dashboard

---

**Happy Coding!** 🎉