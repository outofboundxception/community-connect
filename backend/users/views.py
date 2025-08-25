from rest_framework import generics, permissions
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.parsers import MultiPartParser, FormParser
from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken

from .serializers import (
    RegisterSerializer, UserSerializer,
    ProfileSerializer, ProfileUpdateSerializer
)
from .models import Profile

# Register
class RegisterAPI(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]

# Current user
@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_user(request):
    return Response(UserSerializer(request.user).data)

# My profile (read)
class ProfileAPI(generics.RetrieveAPIView):
    serializer_class = ProfileSerializer
    permission_classes = [permissions.IsAuthenticated]
    def get_object(self):
        return self.request.user.profile
    def get_serializer_context(self):
        ctx = super().get_serializer_context()
        ctx['request'] = self.request
        return ctx

# NEW: Update my profile (handles photo upload too)
class ProfileUpdateAPI(generics.UpdateAPIView):
    serializer_class = ProfileUpdateSerializer
    permission_classes = [permissions.IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]   # for avatar upload

    def get_object(self):
        return self.request.user.profile

# NEW: Directory + filters
class DirectoryAPI(generics.ListAPIView):
    serializer_class = ProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        qs = Profile.objects.select_related('user').all()
        name = self.request.query_params.get('name')
        city = self.request.query_params.get('city')
        skills = self.request.query_params.get('skills')
        year = self.request.query_params.get('year')

        if name:
            qs = qs.filter(user__username__icontains=name)
        if city:
            qs = qs.filter(city__icontains=city)
        if skills:
            qs = qs.filter(skills__icontains=skills)
        if year:
            qs = qs.filter(graduation_year=year)
        return qs

    def get_serializer_context(self):
        ctx = super().get_serializer_context()
        ctx['request'] = self.request
        return ctx

# NEW: Logout (blacklist refresh token)
@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def logout_view(request):
    try:
        refresh = request.data.get('refresh')
        token = RefreshToken(refresh)
        token.blacklist()
        return Response({"detail": "Logged out"})
    except Exception:
        return Response({"detail": "Invalid token"}, status=400)
