// lib/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/event_card.dart';
import '../../widgets/post_card.dart';
import '../../models/event_model.dart';
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

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
    final upcomingEvent = Event(
      id: "1",
      title: "Flutter State Management Summit",
      description: "A deep dive into Provider, BLoC, and Riverpod.",
      date: DateTime.now().add(const Duration(days: 10)),
      author: "Flutter Connect Team",
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
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(
              top: -80,
              right: -80,
              child: _DecorativeCircle(
                size: 200,
                color: const Color(0xFFFFE8CC).withOpacity(0.4),
              ),
            ),
            Positioned(
              top: 120,
              left: -60,
              child: _DecorativeCircle(
                size: 150,
                color: const Color(0xFFFFF4E6).withOpacity(0.5),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -40,
              child: _DecorativeCircle(
                size: 180,
                color: const Color(0xFFFFD699).withOpacity(0.3),
              ),
            ),
            // Small accent circles
            Positioned(
              top: 200,
              right: 40,
              child: Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC966),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 250,
              left: 30,
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD699),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Premium App Bar
                    SliverAppBar(
                      expandedHeight: 200,
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFFC966),
                                Color(0xFFFFB347),
                                Color(0xFFFF9933),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Animated background patterns
                              Positioned(
                                right: -50,
                                top: -50,
                                child: _AnimatedCircle(delay: 0, size: 150),
                              ),
                              Positioned(
                                left: -30,
                                bottom: -30,
                                child: _AnimatedCircle(delay: 1000, size: 120),
                              ),
                              // Decorative lines
                              CustomPaint(
                                size: Size.infinite,
                                painter: _DashboardLinesPainter(),
                              ),
                              // Content
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFFF9933),
                                                Color(0xFFFF8C42),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.4),
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange.withOpacity(0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.hub,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Welcome Back! 👋",
                                                style: TextStyle(
                                                  color: const Color(0xFF5D4037).withOpacity(0.8),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              const Text(
                                                "Dashboard",
                                                style: TextStyle(
                                                  color: Color(0xFF4A2511),
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: -0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.25),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.4),
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.notifications_rounded,
                                            color: Color(0xFF5D4037),
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Quick Stats Cards
                    SliverToBoxAdapter(
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      icon: Icons.event_available_rounded,
                                      title: "Events",
                                      value: "12",
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
                                      icon: Icons.people_rounded,
                                      title: "Members",
                                      value: "248",
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
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      icon: Icons.chat_bubble_rounded,
                                      title: "Messages",
                                      value: "47",
                                      subtitle: "Unread",
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF9933), Color(0xFFFF8C42)],
                                      ),
                                      delay: 200,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _StatCard(
                                      icon: Icons.trending_up_rounded,
                                      title: "Engagement",
                                      value: "89%",
                                      subtitle: "+12% growth",
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF8C42), Color(0xFFE8763E)],
                                      ),
                                      delay: 300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Upcoming Events Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFFC966), Color(0xFFFFB347)],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFB347).withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today_rounded,
                                    color: Color(0xFF5D4037),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  "Upcoming Events",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5D4037),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFFFF8C42),
                              ),
                              child: const Text(
                                "View All",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 240,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: index < 2 ? 16 : 0),
                              child: TweenAnimationBuilder(
                                duration: Duration(milliseconds: 400 + (index * 100)),
                                tween: Tween<double>(begin: 0, end: 1),
                                builder: (context, double value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Opacity(
                                      opacity: value,
                                      child: SizedBox(
                                        width: 320,
                                        child: EventCard(event: upcomingEvent),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // New Posts Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF9933), Color(0xFFFF8C42)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF9933).withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.article_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Community Feed",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5D4037),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 500),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: const PostCard(
                              author: "Jane Doe",
                              content: "Just released a new package for creating beautiful charts in Flutter! Check it out.",
                              timeAgo: "2 hours ago",
                            ),
                          ),
                          const SizedBox(height: 12),
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 600),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: const PostCard(
                              author: "John Smith",
                              content: "Having trouble with nested Navigators. Can anyone share some best practices?",
                              timeAgo: "5 hours ago",
                            ),
                          ),
                          const SizedBox(height: 12),
                          TweenAnimationBuilder(
                            duration: const Duration(milliseconds: 700),
                            tween: Tween<double>(begin: 0, end: 1),
                            builder: (context, double value, child) {
                              return Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: const PostCard(
                              author: "Sarah Johnson",
                              content: "Excited to announce our Flutter workshop next week! Limited seats available.",
                              timeAgo: "8 hours ago",
                            ),
                          ),
                          const SizedBox(height: 24),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

class _StatCardState extends State<_StatCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + widget.delay),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: (_) {
          _controller.forward();
          setState(() => _isPressed = true);
        },
        onTapUp: (_) {
          _controller.reverse();
          setState(() => _isPressed = false);
        },
        onTapCancel: () {
          _controller.reverse();
          setState(() => _isPressed = false);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
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
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    color: const Color(0xFF5D4037),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: const Color(0xFF5D4037).withOpacity(0.8),
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
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: const Color(0xFF5D4037).withOpacity(0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorativeCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _AnimatedCircle extends StatefulWidget {
  final int delay;
  final double size;

  const _AnimatedCircle({required this.delay, required this.size});

  @override
  State<_AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<_AnimatedCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DashboardLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Top right diagonal lines
    canvas.drawLine(
      Offset(size.width * 0.7, 40),
      Offset(size.width * 0.8, 20),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, 50),
      Offset(size.width * 0.85, 30),
      paint,
    );

    // Top left lines
    canvas.drawLine(
      Offset(size.width * 0.15, 35),
      Offset(size.width * 0.25, 20),
      paint,
    );

    // Bottom right
    canvas.drawLine(
      Offset(size.width * 0.75, size.height - 40),
      Offset(size.width * 0.85, size.height - 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}