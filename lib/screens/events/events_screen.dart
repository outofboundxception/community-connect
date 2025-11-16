import 'package:flutter/material.dart';
import 'package:gitraj/screens/events/event_details_screen.dart';
import 'package:provider/provider.dart';
import '/services/auth_service.dart';
import 'add_edit_event_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> events = [
    {
      "title": "Flutter Workshop",
      "date": "Oct 15, 2025",
      "description": "Learn to build cross-platform apps with Flutter.",
      "funds": "5000",
    },
    {
      "title": "Hackathon 2025",
      "date": "Nov 5, 2025",
      "description": "48-hour coding marathon to build cool projects.",
      "funds": "5000",
    },
    {
      "title": "Tech Meetup",
      "date": "Dec 10, 2025",
      "description":
          "Networking and talks from senior developers & tech leaders.",
      "funds": "5000",
    },
  ];

  List<Map<String, String>> filteredEvents = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    filteredEvents = List.from(events);
    super.initState();
  }

  void filterEvents(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEvents = List.from(events);
      } else {
        filteredEvents = events
            .where(
              (event) =>
                  event["title"]!.toLowerCase().contains(query.toLowerCase()) ||
                  event["description"]!.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  void deleteEvent(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Event?"),
          content: const Text("Are you sure you want to delete this event?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text("Delete"),
              onPressed: () {
                setState(() {
                  events.removeAt(index);
                  filteredEvents = List.from(events);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final bool isAdmin = authService.currentUser?.isAdmin ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(
            color: Color(0xFF5D4037),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF8E1),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5D4037)),
      ),

      // Admin can create event
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () async {
                final newEvent = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEditEventScreen()),
                );

                if (newEvent != null) {
                  setState(() {
                    events.add(newEvent);
                    filteredEvents = List.from(events);
                  });
                }
              },
              backgroundColor: const Color(0xFFFF8C42),
              label: const Text("Create Event"),
              icon: const Icon(Icons.add),
            )
          : null,

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C42).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: filterEvents,
                decoration: const InputDecoration(
                  hintText: "Search events...",
                  prefixIcon: Icon(Icons.search, color: Color(0xFFFF8C42)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),

          // List of events
          Expanded(
            child: filteredEvents.isEmpty
                ? const Center(
                    child: Text(
                      "No events found",
                      style: TextStyle(
                        color: Color(0xFF6D4C41),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];

                      return _buildAnimatedEventCard(
                        index: index,
                        event: event,
                        isAdmin: isAdmin,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Animated event card widget
  Widget _buildAnimatedEventCard({
    required int index,
    required Map<String, String> event,
    required bool isAdmin,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
          );

          if (result != null && result["donation"] != null) {
            final donation = result["donation"];

            setState(() {
              int indexInEvents = events.indexOf(event);

              // Increase funds
              int currentFunds =
                  int.tryParse(events[indexInEvents]["funds"]!) ?? 0;
              int donatedAmount = int.tryParse(donation["amount"]!) ?? 0;

              events[indexInEvents]["funds"] = (currentFunds + donatedAmount)
                  .toString();

              // Refresh filtered list
              filteredEvents = List.from(events);
            });
          }

          /* if (updatedEvent != null) {
            setState(() {
              int originalIndex = events.indexOf(event);
              events[originalIndex] = updatedEvent;
              filteredEvents = List.from(events);
            });
          }*/
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8C42).withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + delete icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event["title"]!,
                    style: const TextStyle(
                      color: Color(0xFF4A2511),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (isAdmin)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => deleteEvent(index),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Date
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Color(0xFFFF8C42),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    event["date"]!,
                    style: const TextStyle(
                      color: Color(0xFF5D4037),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                event["description"]!,
                style: const TextStyle(color: Color(0xFF6D4C41), height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
