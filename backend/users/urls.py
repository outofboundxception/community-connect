from django.urls import path
from .views import (
    RegisterAPI, ProfileAPI, ProfileUpdateAPI, logout_view
)
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    path('register/', RegisterAPI.as_view(), name='register'),
    path('login/', TokenObtainPairView.as_view(), name='login'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('profile/', ProfileAPI.as_view(), name='profile'),
    path('profile/update/', ProfileUpdateAPI.as_view(), name='profile_update'),
    path('logout/', logout_view, name='logout'),
]