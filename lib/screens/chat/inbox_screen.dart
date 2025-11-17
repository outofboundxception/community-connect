// lib/screens/chat/inbox_screen.dart
import 'package:flutter/material.dart';
import 'package:gitraj/screens/chat/group_chat_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text(
          "Inbox",
          style: TextStyle(
            color: Color(0xFF5D4037),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFC966),
        elevation: 0,
      ),

      body: ListView(
        children: [
          _buildGroupTile(
            context,
            title: "Main Community Chat",
            subtitle: "Tap to open group chat",
            icon: Icons.group,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFFFFB347),
          child: Icon(icon, size: 30, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF4A2511),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF6D4C41)),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF5D4037),
        ),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GroupChatScreen()),
          );
        },
      ),
    );
  }
}
