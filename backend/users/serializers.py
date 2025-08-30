from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Profile

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id", "username", "email"]

class ProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)  # Nested user info

    class Meta:
        model = Profile
        fields = [
            "id",
            "user",
            "role",
            "bio",
            "location",
            "graduation_year",
            "profession",
            "skills",
            "city",
            "contact",
            "show_email",
            "show_phone",
            "avatar",
        ]

class RegisterSerializer(serializers.ModelSerializer):
    # password write-only so it won't show up in response
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ["id", "username", "email", "password"]

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data["username"],
            email=validated_data["email"],
            password=validated_data["password"]
        )
        # When a user registers, create a Profile with role = MEMBER by default
        Profile.objects.create(user=user, role="MEMBER")
        return user
