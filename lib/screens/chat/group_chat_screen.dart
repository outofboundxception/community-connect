// lib/screens/chat/group_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_message_model.dart';
import '../../services/auth_service.dart';
import '../../widgets/message_bubble.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _messageController = TextEditingController();

  // Mock data for the chat
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: "1",
      senderName: "Jane Doe",
      senderId: "456",
      text: "Hey everyone! 👋",
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    ChatMessage(
      id: "2",
      senderName: "John Smith",
      senderId: "789",
      text: "Hi Jane! How's the new Flutter update treating you?",
      timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
    ),
    ChatMessage(
      id: "3",
      senderName: "Alex Thompson",
      senderId: "123",
      text: "Loving the performance improvements! It's super smooth.",
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = Provider.of<AuthService>(
      context,
      listen: false,
    ).currentUser;
    if (currentUser == null) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: currentUser.fullName,
      senderId: currentUser.uid,
      text: _messageController.text,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });
    // TODO: Send message to backend (e.g., Firestore)
  }

  // Admin-only action
  void _showAutoDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Set Auto-Delete Timer"),
        content: const Text(
          "This feature is only available for admins. You can set messages to auto-delete after a certain period.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentUserId = authService.currentUser?.uid;
    final isAdmin = authService.currentUser?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Chat"),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.timer_off_outlined),
              tooltip: "Set Auto-Delete",
              onPressed: _showAutoDeleteDialog,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true, // Shows latest messages at the bottom
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final message = _messages.reversed.toList()[index];
                final isMe = message.senderId == currentUserId;
                return MessageBubble(message: message, isMe: isMe);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
          // TODO: Add buttons for image/video upload
        ],
      ),
    );
  }
}
