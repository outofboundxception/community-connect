// lib/models/event_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String author;
  final String authorId;
  int likes;
  int comments;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.author,
    required this.authorId,
    this.likes = 0,
    this.comments = 0,
  });

  factory EventModel.fromMap(Map<String, dynamic> data, String documentId) {
    return EventModel(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      author: data['author'] ?? '',
      authorId: data['authorId'] ?? '',
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'author': author,
      'authorId': authorId,
      'likes': likes,
      'comments': comments,
    };
  }
}