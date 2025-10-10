// lib/screens/members/members_directory_screen.dart
// lib/screens/members/members_directory_screen.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart'; // Corrected import
import '../../services/database_service.dart';
import 'member_profile_screen.dart';

// ... (rest of the file is correct)

class MembersDirectoryScreen extends StatelessWidget {
  const MembersDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService dbService = DatabaseService();

    return Scaffold(
      appBar: AppBar(title: const Text('Members Directory')),
      body: StreamBuilder<List<User>>(
        stream: dbService.allUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No members found.'));
          }

          final members = snapshot.data!;
          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final user = members[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.profilePictureUrl.isNotEmpty
                      ? NetworkImage(user.profilePictureUrl)
                      : null,
                  child: user.profilePictureUrl.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(user.fullName),
                subtitle: Text(user.email),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MemberProfileScreen(user: user),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}