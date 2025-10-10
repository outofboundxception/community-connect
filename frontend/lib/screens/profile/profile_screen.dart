// lib/screens/profile/profile_screen.dart
// lib/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart'; // Corrected import
import '../../services/auth_service.dart';
import 'edit_profile_screen.dart';

// ... (rest of the file is correct)

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Consumer to react to changes in AuthService
    return Consumer<IAuthService>(
      builder: (context, authService, child) {
        final User? user = authService.currentUser;

        if (user == null) {
          return const Scaffold(
            body: Center(child: Text("No user logged in or data is loading...")),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("My Profile"),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => authService.logout(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.profilePictureUrl.isNotEmpty
                        ? NetworkImage(user.profilePictureUrl)
                        : null,
                    child: user.profilePictureUrl.isEmpty
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(user.email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                    },
                    child: const Text("Edit Profile"),
                  ),
                  const SizedBox(height: 24),
                  _buildSection("Bio", user.bio.isNotEmpty ? user.bio : "No bio provided."),
                  _buildInterestsSection(user.interests),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper widgets remain the same
   Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 16)),
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildInterestsSection(List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Interests",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (interests.isEmpty)
          const Text("No interests selected.", style: TextStyle(fontSize: 16)),
        if (interests.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: interests
                .map((interest) => Chip(label: Text(interest)))
                .toList(),
          ),
        const Divider(height: 32),
      ],
    );
  }
}