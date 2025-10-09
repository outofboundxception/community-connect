// lib/screens/register/register_step2_interests.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../services/auth_service.dart';
import '../dashboard/main_navigator.dart';

// Theme Configuration
class AppTheme {
  static const primaryGradientStart = Color(0xFFFFC966);
  static const primaryGradientEnd = Color(0xFFFFB347);
  static const buttonColor = Color(0xFFE8763E);
  static const labelColor = Color(0xFF5D4037);
  static const accentOrange = Color(0xFFFF8C42);
  static const backgroundLight = Color(0xFFF8F9FA);

  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGradientStart, primaryGradientEnd],
  );

  static LinearGradient get buttonGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9966), Color(0xFFE8763E)],
  );
}

// Animated Background Painter
class AnimatedBackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  AnimatedBackgroundPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final value = animation.value;

    for (int i = 0; i < 8; i++) {
      final startX = size.width * (0.1 + i * 0.12);
      final startY = size.height * (0.15 + math.sin(value * 2 * math.pi + i) * 0.05);
      final endX = startX + 60 + math.cos(value * 2 * math.pi) * 20;
      final endY = startY - 40;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint..color = const Color(0xFFFFD699).withOpacity(0.1 + i * 0.02),
      );
    }

    for (int i = 0; i < 15; i++) {
      final x = size.width * (0.1 + (i * 0.07));
      final y = size.height * (0.2 + math.sin(value * 2 * math.pi + i * 0.5) * 0.3);

      canvas.drawCircle(
        Offset(x, y),
        2 + math.sin(value * math.pi + i) * 1,
        Paint()..color = const Color(0xFFFFB347).withOpacity(0.3),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Floating Step Indicator
class FloatingStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const FloatingStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentOrange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            final isCurrent = index == currentStep - 1;
            return Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isCurrent ? 40 : 32,
                  height: isCurrent ? 40 : 32,
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? const LinearGradient(
                      colors: [Color(0xFFFF9933), Color(0xFFFF8C42)],
                    )
                        : null,
                    color: isActive ? null : Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: isCurrent ? 3 : 2,
                    ),
                    boxShadow: isCurrent
                        ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                        : null,
                  ),
                  child: Center(
                    child: isActive && index < currentStep - 1
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                      "${index + 1}",
                      style: TextStyle(
                        color: isActive ? Colors.white : AppTheme.accentOrange,
                        fontSize: isCurrent ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (index < totalSteps - 1)
                  Container(
                    width: 30,
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: isActive
                          ? const LinearGradient(
                        colors: [Color(0xFFFF9933), Color(0xFFFF8C42)],
                      )
                          : null,
                      color: isActive ? null : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(width: 12),
          Text(
            "Step $currentStep/$totalSteps",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Animated Interest Chip
class AnimatedInterestChip extends StatefulWidget {
  final String interest;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  const AnimatedInterestChip({
    super.key,
    required this.interest,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.index,
  });

  @override
  State<AnimatedInterestChip> createState() => _AnimatedInterestChipState();
}

class _AnimatedInterestChipState extends State<AnimatedInterestChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Staggered entrance animation
    Future.delayed(Duration(milliseconds: 50 * widget.index), () {
      if (mounted) {
        _controller.forward();
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) => _controller.reverse());
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isSelected ? _scaleAnimation.value : 1.0,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                decoration: BoxDecoration(
                  gradient: widget.isSelected
                      ? LinearGradient(
                    colors: [
                      Colors.white,
                      const Color(0xFFFFFAF0),
                    ],
                  )
                      : LinearGradient(
                    colors: [
                      const Color(0xFFFFF8E1),
                      const Color(0xFFFFF3E0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: widget.isSelected
                        ? AppTheme.accentOrange
                        : Colors.white.withOpacity(0.6),
                    width: widget.isSelected ? 3 : 2,
                  ),
                  boxShadow: widget.isSelected
                      ? [
                    BoxShadow(
                      color: AppTheme.accentOrange.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ]
                      : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.icon,
                      size: 22,
                      color: widget.isSelected
                          ? AppTheme.accentOrange
                          : AppTheme.labelColor.withOpacity(0.7),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.interest,
                      style: TextStyle(
                        color: widget.isSelected
                            ? AppTheme.accentOrange
                            : AppTheme.labelColor,
                        fontSize: 16,
                        fontWeight: widget.isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (widget.isSelected) ...[
                      const SizedBox(width: 8),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 400),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Transform.rotate(
                              angle: value * math.pi * 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF9933), Color(0xFFFF8C42)],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Main Screen
class RegisterStep2Interests extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;

  const RegisterStep2Interests({
    super.key,
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  State<RegisterStep2Interests> createState() => _RegisterStep2InterestsState();
}

class _RegisterStep2InterestsState extends State<RegisterStep2Interests>
    with TickerProviderStateMixin {
  final Map<String, IconData> _interestsWithIcons = {
    "State Management": Icons.settings_suggest_rounded,
    "UI/UX": Icons.palette_rounded,
    "Firebase": Icons.cloud_rounded,
    "Testing": Icons.bug_report_rounded,
    "Animation": Icons.animation_rounded,
    "Desktop Dev": Icons.desktop_windows_rounded,
    "Web Dev": Icons.language_rounded,
    "API Integration": Icons.api_rounded,
  };

  final List<String> _selectedInterests = [];
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
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
    _backgroundController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < 5) {
          _selectedInterests.add(interest);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "You can select up to 5 interests only",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.accentOrange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    });
  }

  Future<void> _signUp() async {
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Please select at least one interest",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.accentOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUp(
        widget.fullName,
        widget.email,
        widget.password,
        _selectedInterests,
      );

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (context, animation, secondaryAnimation) =>
            const MainNavigator(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
          ),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Registration failed: ${e.toString()}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: CustomPaint(
              painter: AnimatedBackgroundPainter(_backgroundController),
            ),
          ),
          // Decorative Circles
          ...[
            Positioned(
              top: -100,
              right: -100,
              child: _buildDecorativeCircle(250, const Color(0xFFFFF4E6)),
            ),
            Positioned(
              top: 100,
              left: -80,
              child: _buildDecorativeCircle(180, const Color(0xFFFFE8CC)),
            ),
            Positioned(
              bottom: -120,
              left: -60,
              child: _buildDecorativeCircle(300, const Color(0xFFFFF4E6)),
            ),
            Positioned(
              bottom: 100,
              right: -100,
              child: _buildDecorativeCircle(220, const Color(0xFFFFE8CC)),
            ),
          ],
          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildContent(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.4),
            color.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Hero(
            tag: 'back_button',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentOrange.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppTheme.accentOrange,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            "Your Interests",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const FloatingStepIndicator(currentStep: 2, totalSteps: 2),
          const SizedBox(height: 40),
          _buildInterestsCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInterestsCard() {
    return Hero(
      tag: 'registration_card',
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 550),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGradientEnd.withOpacity(0.5),
                blurRadius: 50,
                offset: const Offset(0, 25),
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Shimmer overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 28),
                    const Text(
                      "Select Your Interests",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        "${_selectedInterests.length}/5 Selected",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 14,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: _interestsWithIcons.entries.toList().asMap().entries.map((entry) {
                        final index = entry.key;
                        final interest = entry.value.key;
                        final icon = entry.value.value;
                        return AnimatedInterestChip(
                          interest: interest,
                          icon: icon,
                          isSelected: _selectedInterests.contains(interest),
                          onTap: () => _toggleInterest(interest),
                          index: index,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    _buildFinishButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.rotate(
            angle: (1 - value) * math.pi * 2,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFAA66), Color(0xFFFF8C42)],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C42).withOpacity(0.4),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite_rounded,
                size: 45,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFinishButton() {
    return Container(
      width: double.infinity,
      height: 62,
      decoration: BoxDecoration(
        gradient: AppTheme.buttonGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.buttonColor.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
          height: 28,
          width: 28,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Finish Setup",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.check_circle_rounded, size: 28, color: Colors.white),
          ],
        ),
      ),
    );
  }
}