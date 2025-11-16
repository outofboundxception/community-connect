// lib/models/event_model.dart
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String author;
  int likes;
  int comments;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.author,
    this.likes = 0,
    this.comments = 0,
  });
}
