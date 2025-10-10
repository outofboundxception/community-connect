// lib/screens/events/events_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event_model.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../widgets/event_card.dart';
import 'add_edit_event_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<IAuthService>(context, listen: false);
    final bool isAdmin = authService.currentUser?.isAdmin ?? false;

    // Use a specific provider for this screen's state if needed, or get from a multi-provider
    return ChangeNotifierProvider(
      create: (_) => EventService(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Events'),
        ),
        body: Consumer<EventService>(
          builder: (context, eventService, child) {
            return StreamBuilder<List<EventModel>>(
              stream: eventService.events,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No events scheduled."));
                }
                final events = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: events.length,
                  itemBuilder: (ctx, index) {
                    final event = events[index];
                    return EventCard(
                      event: event,
                      isAdmin: isAdmin,
                      onDelete: () {
                        if (isAdmin) {
                          eventService.deleteEvent(event.id);
                        }
                      },
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: isAdmin
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddEditEventScreen()),
                  );
                },
              )
            : null,
      ),
    );
  }
}