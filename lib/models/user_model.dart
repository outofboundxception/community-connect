// lib/models/user_model.dart
import 'package:flutter/foundation.dart'; // Import for debugPrint

class User {
  final String _uid; // Private field
  final String fullName;
  final String email;
  final String profilePictureUrl;
  final String bio;
  final List<String> interests;
  final bool isAdmin;

  // Constructor
  User({
    required String uid,
    required this.fullName,
    required this.email,
    this.profilePictureUrl = '',
    this.bio = '',
    this.interests = const [],
    this.isAdmin = false,
  }) : _uid = uid;

  // Public getter to access the private _uid field
  String get uid => _uid;
}

// Inherits from User, adding specific admin capabilities
class AdminUser extends User {
  AdminUser({required super.uid, required super.fullName, required super.email})
      : super(isAdmin: true);

  void deleteEvent() {
    // Replaced print with a safer logging method for Flutter environments
    debugPrint("Admin: Deleting event.");
  }

  void setAutoDeleteTimer() {
    // Replaced print with a safer logging method for Flutter environments
    debugPrint("Admin: Setting chat auto-delete timer.");
  }
}