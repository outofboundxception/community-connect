import 'package:flutter/foundation.dart';
import '../models/event_model.dart';

// This service class encapsulates all logic related to event management.
class EventService with ChangeNotifier {
  // A private list to hold the events. In a real app, this would
  // be replaced with calls to a database like Firestore.
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

  // A public getter to allow other parts of the app to read the events
  // without being able to modify the list directly (Encapsulation).
  List<Event> get events => [..._events];

  // Adds a new event to the list.
  Future<void> addEvent(String title, String description, DateTime date) async {
    final newEvent = Event(
      // Use timestamp for a unique ID in this mock setup.
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      date: date,
      author: "Admin", // Assuming the admin is the author.
    );
    _events.add(newEvent);

    // Notify any widgets listening to this service that the data has changed.
    notifyListeners();
  }

  // Deletes an event from the list by its ID.
  Future<void> deleteEvent(String id) async {
    _events.removeWhere((event) => event.id == id);
    notifyListeners();
  }
}
