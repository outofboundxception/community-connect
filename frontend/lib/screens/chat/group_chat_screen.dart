// lib/screens/chat/group_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat_message_model.dart';
import '../../models/user_model.dart'; // Corrected import
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../widgets/message_bubble.dart';

// ... (rest of the file is correct)

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final User? currentUser = Provider.of<IAuthService>(context, listen: false).currentUser;
    if (currentUser == null) return;

    final newMessage = ChatMessage(
      id: '',
      senderName: currentUser.fullName,
      senderId: currentUser.uid,
      text: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );
    
    _chatService.sendMessage(newMessage);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = Provider.of<IAuthService>(context).currentUser;
    final String currentUserId = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Group Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.messages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong.'));
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUserId;
                    return MessageBubble(message: message, isMe: isMe);
                  },
                );
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
        ],
      ),
    );
  }
}