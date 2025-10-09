// lib/screens/register/register_step1_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'register_step2_interests.dart';

// Theme Configuration
class AppTheme {
  static const primaryGradientStart = Color(0xFFFFC966);
  static const primaryGradientEnd = Color(0xFFFFB347);
  static const buttonColor = Color(0xFFE8763E);
  static const labelColor = Color(0xFF5D4037);
  static const inputBackground = Color(0xFFFFF8E1);
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
      ..color = const Color(0xFFFFD699).withOpacity(0.15)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final value = animation.value;

    // Animated diagonal lines
    for (int i = 0; i < 8; i++) {
      final startX = size.width * (0.1 + i * 0.12);
      final startY = size.height * (0.15 + math.sin(value * 2 * math.pi + i) * 0.05);
      final endX = startX + 60 + math.cos(value * 2 * math.pi) * 20;
      final endY = startY - 40;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint..color = paint.color.withOpacity(0.1 + i * 0.02),
      );
    }

    // Floating particles
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
  bool shouldRepaint(AnimatedBackgroundPainter oldDelegate) => true;
}

// Glassmorphic Container
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(opacity),
              Colors.white.withOpacity(opacity * 0.5),
            ],
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: child,
      ),
    );
  }
}

// Premium Input Field
class PremiumInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const PremiumInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<PremiumInputField> createState() => _PremiumInputFieldState();
}

class _PremiumInputFieldState extends State<PremiumInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 10),
              child: Row(
                children: [
                  Icon(widget.icon, size: 18, color: AppTheme.labelColor),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppTheme.labelColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isFocused
                      ? [const Color(0xFFFFFAF0), const Color(0xFFFFF8E1)]
                      : [const Color(0xFFFFF8E1), const Color(0xFFFFF3E0)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _isFocused
                      ? AppTheme.accentOrange.withOpacity(0.5)
                      : Colors.white.withOpacity(0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isFocused
                        ? AppTheme.accentOrange.withOpacity(0.15)
                        : Colors.black.withOpacity(0.03),
                    blurRadius: _isFocused ? 15 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Focus(
                onFocusChange: (focused) {
                  setState(() => _isFocused = focused);
                  if (focused) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  validator: widget.validator,
                  style: const TextStyle(
                    color: AppTheme.labelColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 20,
                    ),
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: AppTheme.labelColor.withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                    ),
                    errorStyle: const TextStyle(
                      color: Color(0xFFD32F2F),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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

// Main Screen
class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends State<RegisterStep1Screen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(child: Text("Passwords do not match")),
              ],
            ),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
        return;
      }

      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) =>
              RegisterStep2Interests(
                fullName: _fullNameController.text.trim(),
                email: _emailController.text.trim(),
                password: _passwordController.text,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                      child: _buildContent(size),
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
            "Create Account",
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

  Widget _buildContent(Size size) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const FloatingStepIndicator(currentStep: 1, totalSteps: 2),
            const SizedBox(height: 40),
            _buildRegistrationCard(),
            const SizedBox(height: 28),
            _buildSignInPrompt(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationCard() {
    return Hero(
      tag: 'registration_card',
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
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
              // Shimmer effect overlay
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
                    const SizedBox(height: 32),
                    PremiumInputField(
                      controller: _fullNameController,
                      label: "Full Name",
                      hint: "Enter your full name",
                      icon: Icons.person_outline_rounded,
                      validator: (value) =>
                      value?.trim().isEmpty ?? true ? "Please enter your name" : null,
                    ),
                    const SizedBox(height: 20),
                    PremiumInputField(
                      controller: _emailController,
                      label: "Email Address",
                      hint: "Enter your email",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Please enter your email";
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value!)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    PremiumInputField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "Create a strong password",
                      icon: Icons.lock_outline_rounded,
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return "Please enter a password";
                        if (value!.length < 6) return "Minimum 6 characters required";
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    PremiumInputField(
                      controller: _confirmPasswordController,
                      label: "Confirm Password",
                      hint: "Re-enter your password",
                      icon: Icons.lock_outline_rounded,
                      obscureText: true,
                      validator: (value) =>
                      value?.isEmpty ?? true ? "Please confirm password" : null,
                    ),
                    const SizedBox(height: 36),
                    _buildContinueButton(),
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
                Icons.person_add_alt_1_rounded,
                size: 45,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton() {
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
        onPressed: _continue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Continue",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.arrow_forward_rounded, size: 26, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: AppTheme.accentOrange,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}