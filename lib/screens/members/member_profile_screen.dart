import 'package:flutter/material.dart';
import '../../models/user_model.dart';

// This is a new screen dedicated to showing another member's public profile.
class MemberProfileScreen extends StatelessWidget {
  // It takes a User object in its constructor to know who to display.
  final User user;

  const MemberProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 16),

            // User's name and email
            Text(
              user.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // "Connect" button
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text("Send Connect Request"),
              onPressed: () {
                // TODO: Implement connect/friend request logic.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Connect request sent to ${user.fullName}!"),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Bio section
            _buildSection(
              "Bio",
              user.bio.isNotEmpty ? user.bio : "No bio provided.",
            ),
            const SizedBox(height: 16),

            // Interests section
            _buildInterestsSection(context, user.interests),
          ],
        ),
      ),
    );
  }

  // A helper widget to create a consistent section layout for "Bio".
  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(content, style: const TextStyle(fontSize: 16)),
        ),
        const Divider(height: 32),
      ],
    );
  }

  // A helper widget to display the user's interests using Chips.
  Widget _buildInterestsSection(BuildContext context, List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Interests",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (interests.isEmpty)
          const Text(
            "No interests listed.",
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        if (interests.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: interests
                .map(
                  (interest) => Chip(
                    label: Text(interest),
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColorLight.withOpacity(0.5),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
