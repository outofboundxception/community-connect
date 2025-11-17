import 'package:flutter/foundation.dart';
import '../models/event_model.dart';

class EventService with ChangeNotifier {
  // Hard-coded mock events
  final List<Event> _events = [
    Event(
      id: "1",
      title: "Flutter State Management Summit",
      description: "A deep dive into Provider, BLoC, and Riverpod.",
      date: DateTime.now().add(const Duration(days: 10)),
      author: "Flutter Connect Team",
    ),
    Event(
      id: "2",
      title: "UI/UX Design for Developers",
      description: "Learn design principles to make your apps beautiful.",
      date: DateTime.now().add(const Duration(days: 25)),
      author: "Design Gurus",
    ),
  ];

  // Get copy of list
  List<Event> get events => [..._events];

  // Get a specific event by ID
  Event? getEventById(String id) {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // Add new event
  Future<void> addEvent(String title, String description, DateTime date) async {
    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      date: date,
      author: "Admin",
    );

    _events.add(newEvent);
    notifyListeners();
  }

  // Update existing event
  Future<void> updateEvent(
    String id,
    String title,
    String description,
    DateTime date,
  ) async {
    final index = _events.indexWhere((e) => e.id == id);

    if (index == -1) return;

    _events[index] = Event(
      id: id,
      title: title,
      description: description,
      date: date,
      author: _events[index].author, // keep original author
    );

    notifyListeners();
  }

  // Delete event
  Future<void> deleteEvent(String id) async {
    _events.removeWhere((event) => event.id == id);
    notifyListeners();
  }
}
