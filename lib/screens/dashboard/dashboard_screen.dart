// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/event_card.dart';
import '../../widgets/post_card.dart';
import '../../models/event_model.dart';
//import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final upcomingEvent = Event(
      id: "1",
      title: "Flutter State Management Summit",
      description: "A deep dive into Provider, BLoC, and Riverpod.",
      date: DateTime.now().add(const Duration(days: 10)),
      author: "Flutter Connect Team",
    );

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(title: const Text("Dashboard")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Upcoming Events Section
          const Text(
            "Upcoming Events",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 300, child: EventCard(event: upcomingEvent)),
                const SizedBox(width: 10),
                SizedBox(width: 300, child: EventCard(event: upcomingEvent)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // New Posts Section
          const Text(
            "New Posts",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const PostCard(
            author: "Jane Doe",
            content:
                "Just released a new package for creating beautiful charts in Flutter! Check it out.",
            timeAgo: "2 hours ago",
          ),
          const PostCard(
            author: "John Smith",
            content:
                "Having trouble with nested Navigators. Can anyone share some best practices?",
            timeAgo: "5 hours ago",
          ),
        ],
      ),
    );
  }
}
