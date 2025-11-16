// lib/screens/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/auth_service.dart';
import 'dart:math' as math;

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

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
    final authService = Provider.of<AuthService>(context);
    final bool isAdmin = authService.currentUser?.isAdmin ?? false;

    // ⭐ HARD-CODED VALUES
    const int events = 12;
    const int groups = 3;
    const int unseen = 47;
    const int members = 243;
    const int funds = 129000;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC966),
        elevation: 0,
        title: Text(
          isAdmin ? "Admin Dashboard" : "Dashboard",
          style: const TextStyle(
            color: Color(0xFF4A2511),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF4A2511)),
      ),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // ⭐ FIRST ROW
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.event_available_rounded,
                        title: "Events",
                        value: events.toString(),
                        subtitle: "This month",
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFC966), Color(0xFFFFB347)],
                        ),
                        delay: 0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.groups_rounded,
                        title: "Groups",
                        value: groups.toString(),
                        subtitle: "Active now",
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFB347), Color(0xFFFF9933)],
                        ),
                        delay: 100,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ⭐ SECOND ROW
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.mark_email_unread_rounded,
                        title: "Unseen",
                        value: unseen.toString(),
                        subtitle: "Messages",
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9933), Color(0xFFFF8C42)],
                        ),
                        delay: 200,
                      ),
                    ),

                    if (isAdmin) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.people_alt_rounded,
                          title: "Members",
                          value: members.toString(),
                          subtitle: "Total",
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8C42), Color(0xFFE8763E)],
                          ),
                          delay: 300,
                        ),
                      ),
                    ],
                  ],
                ),

                // ⭐ THIRD ROW (Admin Only)
                if (isAdmin) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.account_balance_wallet_rounded,
                          title: "Funds",
                          value: "₹$funds",
                          subtitle: "Collected",
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE8763E), Color(0xFFD8682A)],
                          ),
                          delay: 400,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Gradient gradient;
  final int delay;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.gradient,
    required this.delay,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + widget.delay),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()..scale(_pressed ? 0.95 : 1.0),

          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: const Color(0xFF5D4037)),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Color(0xFF5D4037),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.value,
                style: const TextStyle(
                  color: Color(0xFF4A2511),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.subtitle,
                style: const TextStyle(color: Color(0xFF6D4C41), fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
