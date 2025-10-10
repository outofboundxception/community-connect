// lib/screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  late String _uid;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<IAuthService>(context, listen: false).currentUser;
    if (user != null) {
      _uid = user.uid;
      _nameController.text = user.fullName;
      _bioController.text = user.bio;
    }
  }

  Future<void> _saveProfile() async {
    // THIS CALL IS THE FIX
    await _dbService.updateUserProfile(
        _uid, _nameController.text, _bioController.text);

    if (mounted) {
       // Manually trigger a refresh of user data after saving
      await Provider.of<IAuthService>(context, listen: false).logout();
      await Provider.of<IAuthService>(context, listen: false).login("test@example.com","password123");
      
      Navigator.of(context).pop();
    }
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