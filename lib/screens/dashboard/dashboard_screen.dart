import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../models/post_model.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/event_card.dart';
import '../../widgets/post_card.dart';

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
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x80FFF4E6),
              Color(0x4DFFF8E1),
              Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -80,
              child: _DecorativeCircle(size: 200, color: const Color(0x66FFE8CC)),
            ),
            Positioned(
              top: 120,
              left: -60,
              child: _DecorativeCircle(size: 150, color: const Color(0x80FFF4E6)),
            ),
            Positioned(
              bottom: 100,
              right: -40,
              child: _DecorativeCircle(size: 180, color: const Color(0x4DFFD699)),
            ),
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
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // App Bar
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
                              CustomPaint(size: Size.infinite, painter: _DashboardLinesPainter()),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFFFF9933), Color(0xFFFF8C42)],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0x66FFFFFF), width: 2),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x4DFF9933),
                                            blurRadius: 12,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(Icons.hub, color: Colors.white, size: 28),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            "Welcome Back! 👋",
                                            style: TextStyle(
                                              color: Color(0xCC5D4037),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
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
                                      decoration: const BoxDecoration(
                                        color: Color(0x40FFFFFF),
                                        shape: BoxShape.circle,
                                        border: Border.fromBorderSide(
                                          BorderSide(color: Color(0x66FFFFFF), width: 2),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Quick Stats
                    SliverToBoxAdapter(
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
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
                        ),
                      ),
                    ),

                    // Upcoming Events
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 240,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
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
                                    child: Opacity(opacity: value, child: child),
                                  );
                                },
                                child: SizedBox(
                                  width: 320,
                                  child: EventCard(event: upcomingEvent),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Community Feed Section
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildPostCard(
                            author: "Jane Doe",
                            content:
                            "Just released a new package for creating beautiful charts in Flutter! Check it out.",
                            hoursAgo: 2,
                            likes: 1200,
                            comments: 35,
                            saves: 15,
                          ),
                          const SizedBox(height: 12),
                          _buildPostCard(
                            author: "John Smith",
                            content:
                            "Having trouble with nested Navigators. Can anyone share some best practices?",
                            hoursAgo: 5,
                            likes: 800,
                            comments: 22,
                            saves: 10,
                          ),
                          const SizedBox(height: 12),
                          _buildPostCard(
                            author: "Sarah Johnson",
                            content:
                            "Excited to announce our Flutter workshop next week! Limited seats available.",
                            hoursAgo: 8,
                            likes: 1500,
                            comments: 50,
                            saves: 20,
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

  // 🔹 Helper to build PostCard
  Widget _buildPostCard({
    required String author,
    required String content,
    required int hoursAgo,
    required int likes,
    required int comments,
    required int saves,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: PostCard(
        post: Post(
          id: UniqueKey().toString(),
          authorId: "author_${author.toLowerCase().replaceAll(' ', '_')}",
          authorName: author,
          authorAvatar: "https://via.placeholder.com/150",
          content: content,
          createdAt: DateTime.now().subtract(Duration(hours: hoursAgo)),
          likes: likes,
          comments: comments,
          saves: saves,
          isLiked: false,
          isSaved: false,
          mediaUrls: const [],
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
  Color _resolveOpacity(Color color, double opacity) => color.withOpacity(opacity);
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
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
        return Transform.scale(scale: value, child: Opacity(opacity: value, child: child));
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
              border: Border.all(color: const Color(0x4DFFFFFF), width: 2),
              boxShadow: [
                BoxShadow(
                  color: _resolveOpacity(widget.gradient.colors.first, 0.4),
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
                    color: const Color(0x40FFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x4DFFFFFF), width: 1.5),
                  ),
                  child: Icon(widget.icon, color: const Color(0xFF5D4037), size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: const TextStyle(color: Color(0xCC5D4037), fontSize: 13, fontWeight: FontWeight.w600),
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
                  style: const TextStyle(color: Color(0xB35D4037), fontSize: 11, fontWeight: FontWeight.w500),
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

  const _DecorativeCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
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
    _controller = AnimationController(duration: const Duration(seconds: 4), vsync: this);
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x26FFFFFF), Color(0x00FFFFFF)],
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

    canvas.drawLine(Offset(size.width * 0.7, 40), Offset(size.width * 0.8, 20), paint);
    canvas.drawLine(Offset(size.width * 0.75, 50), Offset(size.width * 0.85, 30), paint);
    canvas.drawLine(Offset(size.width * 0.15, 35), Offset(size.width * 0.25, 20), paint);
    canvas.drawLine(
      Offset(size.width * 0.75, size.height - 40),
      Offset(size.width * 0.85, size.height - 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
