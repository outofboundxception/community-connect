// lib/screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: In a real app, load the current user's data into the controllers
    // For example:
    // final user = Provider.of<AuthService>(context, listen: false).currentUser;
    // _nameController.text = user?.fullName ?? '';
    // _bioController.text = user?.bio ?? '';
  }

  void _saveProfile() {
    // TODO: Implement logic to save the updated profile information to your backend
    print("Saving profile...");
    print("Name: ${_nameController.text}");
    print("Bio: ${_bioController.text}");
    Navigator.of(context).pop(); // Go back to the profile screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveProfile),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile picture editing UI
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        /* TODO: Implement image picking logic */
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: "Bio"),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
