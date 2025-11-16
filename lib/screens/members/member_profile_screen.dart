import 'package:flutter/material.dart';
import '../../models/user_model.dart';
// Removed: import 'dart:math' as math; (Unused import)

class MemberProfileScreen extends StatefulWidget {
  final User user;

  const MemberProfileScreen({super.key, required this.user});

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late AnimationController _fabController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;
  late Animation<double> _fabAnimation;

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );

    _contentAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );

    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fabController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  // Helper method to resolve potential deprecation warnings for colors
  Color _withOpacity(Color color, double opacity) {
    // For general Color instances, .withOpacity is the modern pattern.
    // We use Color.fromRGBO for clarity when dealing with variable opacity on known colors.
    return color.withOpacity(opacity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Use alpha-prefixed hex codes for constant gradient colors
              const Color(0x80FFF4E6), // 50% opacity (0.5 * 255 = 127, or 0x80)
              const Color(0x4DFFF8E1), // 30% opacity (0.3 * 255 = 76, or 0x4D)
              const Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  // Fixed potential MaterialColor.withOpacity deprecation
                  backgroundColor: _withOpacity(Colors.white, 0.9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF5D4037), size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: FadeTransition(
                  opacity: _headerAnimation,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        // Profile picture placeholder
                        ScaleTransition(
                          scale: _headerAnimation,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange.shade200,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 60,
                              color: Color(0xFF5D4037),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Name
                        Text(
                          widget.user.fullName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A2511),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Email
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            // Fixed potential MaterialColor.withOpacity deprecation
                            color: _withOpacity(Colors.white, 0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              // Fixed potential MaterialColor.withOpacity deprecation
                              color: _withOpacity(Colors.white, 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.email_rounded,
                                  color: Color(0xFF5D4037), size: 16),
                              const SizedBox(width: 6),
                              Text(
                                widget.user.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  // Fixed potential MaterialColor.withOpacity deprecation
                                  color: _withOpacity(const Color(0xFF5D4037), 0.9),
                                  fontWeight: FontWeight.w600,
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
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _contentAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(_contentAnimation),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Connect button
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isConnected = !_isConnected;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(_isConnected
                                          ? "Connected with ${widget.user.fullName}!"
                                          : "Connection removed"),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  _isConnected
                                      ? Icons.check_circle
                                      : Icons.person_add_alt_1,
                                ),
                                label: Text(
                                    _isConnected ? "Connected" : "Connect"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isConnected
                                      ? Colors.green
                                      : Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Bio
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.user.bio.isNotEmpty
                                ? widget.user.bio
                                : "No bio available yet.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.brown.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Interests
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.user.interests.isEmpty
                                ? [
                              Chip(
                                label: const Text("No interests listed"),
                                backgroundColor:
                                Colors.orange.shade100,
                              )
                            ]
                                : widget.user.interests
                                .map((interest) => Chip(
                              label: Text(interest),
                              backgroundColor:
                              Colors.orange.shade100,
                            ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // FAB can be added here if needed, but the original code did not include it in the build method
    );
  }
}