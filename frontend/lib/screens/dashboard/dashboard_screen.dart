// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event_model.dart'; // Correct import
import '../../services/event_service.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/event_card.dart';
import '../../widgets/post_card.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- THIS BLOCK IS THE FIX ---
    // Using EventModel and providing all required fields.
    final upcomingEvent = EventModel(
      id: "1",
      title: "Flutter State Management Summit",
      description: "A deep dive into Provider, BLoC, and Riverpod.",
      date: DateTime.now().add(const Duration(days: 10)),
      author: "Flutter Connect Team",
      authorId: "admin_id", // Added missing required field
    );

    return Scaffold(
      drawer: const CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF4E6).withOpacity(0.5),
              const Color(0xFFFFF8E1).withOpacity(0.3),
              const Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFC966), Color(0xFFFFB347), Color(0xFFFF9933)],
                        ),
                      ),
                      child: const Center(child: Text("Dashboard", style: TextStyle(fontSize: 32, color: Color(0xFF4A2511), fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Your StatCards remain here...
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                    child: Text("Upcoming Events", style: Theme.of(context).textTheme.headlineSmall),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 240,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: 3, // Using mock data for now
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 320,
                          child: EventCard(event: upcomingEvent), // Using the corrected upcomingEvent
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                   child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Text("Community Feed", style: Theme.of(context).textTheme.headlineSmall),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const PostCard(author: "Jane Doe", content: "New package for charts!", timeAgo: "2h ago"),
                      const PostCard(author: "John Smith", content: "Help with Navigators?", timeAgo: "5h ago"),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}