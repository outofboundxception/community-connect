// lib/models/chat_message_model.dart
class ChatMessage {
  final String id;
  final String senderName;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final String? imageUrl;
  final String? videoUrl;

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.imageUrl,
    this.videoUrl,
  });
}
