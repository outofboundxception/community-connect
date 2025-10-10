// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String fullName;
  final String email;
  final String profilePictureUrl;
  final String bio;
  final List<String> interests;
  final bool isAdmin;

  User({
    required this.uid,
    required this.fullName,
    required this.email,
    this.profilePictureUrl = '',
    this.bio = '',
    this.interests = const [],
    this.isAdmin = false,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      bio: data['bio'] ?? '',
      interests: List<String>.from(data['interests'] ?? []),
      isAdmin: data['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'interests': interests,
      'isAdmin': isAdmin,
    };
  }
}