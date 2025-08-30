from django.contrib import admin
from .models import Profile

@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'role', 'city', 'graduation_year', 'profession', 'skills', 'show_email', 'show_phone')
    list_filter = ('role', 'city')
    search_fields = ('user__username', 'city', 'profession', 'skills')

    actions = ['make_admin', 'make_member']

    def make_admin(self, request, queryset):
        updated = queryset.update(role="ADMIN")   # must match DB value
        self.message_user(request, f"{updated} user(s) promoted to Admin.")

    def make_member(self, request, queryset):
        updated = queryset.update(role="MEMBER")  # must match DB value
        self.message_user(request, f"{updated} user(s) demoted to Member.")

    make_admin.short_description = "Make selected users Admin"
    make_member.short_description = "Make selected users Member"
