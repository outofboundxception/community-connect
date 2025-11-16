import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/event_service.dart';
import '../../widgets/event_card.dart';
import 'add_edit_event_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We get the AuthService here, but we set listen: false because the Consumer will handle rebuilding.
    final authService = Provider.of<AuthService>(context, listen: false);
    final bool isAdmin = authService.currentUser?.isAdmin ?? false;

    // Use a Consumer widget to listen for changes in EventService.
    // The 'builder' gives us a NEW context that is guaranteed to find the service.
    return Consumer<EventService>(
      builder: (context, eventService, child) {
        // Now, the 'eventService' variable is safely provided.
        return Scaffold(
          appBar: AppBar(title: const Text("Events")),
          body: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: eventService.events.length,
            itemBuilder: (context, index) {
              final event = eventService.events[index];
              return EventCard(
                event: event,
                isAdmin: isAdmin,
                onDelete: () => eventService.deleteEvent(event.id),
                onTap: () {
                  /* TODO: Navigate to event details screen */
                },
              );
            },
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddEditEventScreen(),
                      ),
                    );
                  },
                  tooltip: 'Add Event',
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}
