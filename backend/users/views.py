from rest_framework import generics, permissions
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.views import APIView
from django.contrib.auth.models import User

from .models import Profile
from .serializers import RegisterSerializer, UserSerializer, ProfileSerializer


# --------------------------
# Register API
# --------------------------
class RegisterAPI(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]  # anyone can register


# --------------------------
# Get Current User
# --------------------------
@api_view(["GET"])
@permission_classes([permissions.IsAuthenticated])
def get_user(request):
    serializer = UserSerializer(request.user)
    return Response(serializer.data)


# --------------------------
# Profile View (GET current user profile)
# --------------------------
class ProfileAPI(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        profile = request.user.profile
        serializer = ProfileSerializer(profile)
        return Response(serializer.data)


# --------------------------
# Profile Update View
# --------------------------
class ProfileUpdateAPI(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def put(self, request):
        profile = request.user.profile
        data = request.data.copy()
        if "role" in data:
            data.pop("role")
        serializer = ProfileSerializer(profile, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)


# --------------------------
# Directory API (ADMIN-only)
# --------------------------
class DirectoryAPI(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        # Only ADMINs can view the directory
        if request.user.profile.role != "ADMIN":
            return Response({"error": "Only Admins can access this"}, status=403)

        profiles = Profile.objects.all()
        serializer = ProfileSerializer(profiles, many=True)
        return Response(serializer.data)


# --------------------------
# Logout View
# --------------------------
from rest_framework_simplejwt.tokens import RefreshToken

@api_view(["POST"])
@permission_classes([permissions.IsAuthenticated])
def logout_view(request):
    try:
        refresh_token = request.data["refresh"]
        token = RefreshToken(refresh_token)
        token.blacklist()
        return Response({"message": "Logged out successfully"})
    except Exception as e:
        return Response({"error": "Invalid token"}, status=400)
