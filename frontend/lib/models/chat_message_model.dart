// lib/models/chat_message_model.dart
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- THIS LINE IS THE FIX

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

  factory ChatMessage.fromMap(Map<String, dynamic> data, String documentId) {
    return ChatMessage(
      id: documentId,
      senderName: data['senderName'] ?? '',
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp? ?? Timestamp.now()).toDate(),
      imageUrl: data['imageUrl'],
      videoUrl: data['videoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }
}