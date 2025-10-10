// lib/services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message_model.dart';

class ChatService {
  final CollectionReference<Map<String, dynamic>> _chatCollection =
      FirebaseFirestore.instance.collection('groupChat');

  /// Stream of chat messages, ordered by timestamp.
  Stream<List<ChatMessage>> get messages {
    return _chatCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Sends a new message to the chat.
  Future<void> sendMessage(ChatMessage message) async {
    await _chatCollection.add(message.toMap());
  }
}