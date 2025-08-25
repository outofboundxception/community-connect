from django.db import models
from django.contrib.auth.models import User

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    graduation_year = models.IntegerField(null=True, blank=True)
    profession = models.CharField(max_length=100, blank=True)
    skills = models.TextField(blank=True)         # e.g. "python, flutter, django"
    city = models.CharField(max_length=100, blank=True)
    contact = models.CharField(max_length=50, blank=True)

    # NEW
    avatar = models.ImageField(upload_to='avatars/', blank=True, null=True)
    show_email = models.BooleanField(default=False)
    show_phone = models.BooleanField(default=False)

    def __str__(self):
        return self.user.username
