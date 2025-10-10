// lib/services/event_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/event_model.dart'; // Correct import

class EventService with ChangeNotifier {
  final CollectionReference<Map<String, dynamic>> _eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Stream<List<EventModel>> get events {
    return _eventsCollection
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addEvent(EventModel newEvent) async {
    await _eventsCollection.add(newEvent.toMap());
  }

   Future<void> deleteEvent(String id) async {
    await _eventsCollection.doc(id).delete();
  }
}