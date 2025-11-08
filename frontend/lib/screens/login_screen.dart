import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'dashboard/main_navigator.dart';
import 'register/register_step1_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: "admin@flutter.dev");
  final _passwordController = TextEditingController(text: "password123");
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigator()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: -80,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8CC),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4E6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -100,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8CC),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Decorative small circles
          Positioned(
            top: 150,
            right: 50,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFFFC966),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: 40,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD699),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: screenSize.height * 0.3,
            right: 30,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8CC),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Diagonal lines
          CustomPaint(
            size: screenSize,
            painter: DiagonalLinesPainter(),
          ),
          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Login card
                    Container(
                      constraints: const BoxConstraints(maxWidth: 380),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFC966),
                            Color(0xFFFFB347),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB347).withOpacity(0.4),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
                        child: Column(
                          children: [
                            // Avatar circle with icon
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF9933),
                                    Color(0xFFFF8C42),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.hub,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 28),
                            // Email field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 4, bottom: 8),
                                  child: Text(
                                    "Email",
                                    style: TextStyle(
                                      color: Color(0xFF5D4037),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF8E1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      color: Color(0xFF5D4037),
                                      fontSize: 15,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 18,
                                      ),
                                      hintText: "Enter your email",
                                      hintStyle: TextStyle(
                                        color: Color(0xFFBCAAA4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Password field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 4, bottom: 8),
                                  child: Text(
                                    "Password",
                                    style: TextStyle(
                                      color: Color(0xFF5D4037),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF8E1),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    style: const TextStyle(
                                      color: Color(0xFF5D4037),
                                      fontSize: 15,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 18,
                                      ),
                                      hintText: "Enter your password",
                                      hintStyle: TextStyle(
                                        color: Color(0xFFBCAAA4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: _isLoading
                                  ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                                  : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE8763E),
                                  foregroundColor: const Color(0xFF4A2511),
                                  elevation: 8,
                                  shadowColor: const Color(0xFFD35400).withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  "Log in",
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Sign up prompt
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterStep1Screen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xFFFF8C42),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD699).withOpacity(0.4)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Top right diagonal lines
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.15),
      Offset(size.width * 0.75, size.height * 0.08),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.18),
      Offset(size.width * 0.8, size.height * 0.12),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.22),
      Offset(size.width * 0.88, size.height * 0.14),
      paint,
    );

    // Top left diagonal lines
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.18),
      Offset(size.width * 0.25, size.height * 0.12),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.22),
      Offset(size.width * 0.22, size.height * 0.16),
      paint,
    );

    // Bottom left diagonal lines
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.75),
      Offset(size.width * 0.18, size.height * 0.82),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.12, size.height * 0.78),
      Offset(size.width * 0.22, size.height * 0.86),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.82),
      Offset(size.width * 0.25, size.height * 0.9),
      paint,
    );

    // Bottom right diagonal lines
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.8),
      Offset(size.width * 0.85, size.height * 0.88),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.84),
      Offset(size.width * 0.9, size.height * 0.92),
      paint,
    );

    // Middle right diagonal lines
    canvas.drawLine(
      Offset(size.width * 0.85, size.height * 0.45),
      Offset(size.width * 0.92, size.height * 0.52),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}