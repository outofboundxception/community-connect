// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    // Wait for 2 seconds to show splash, then go to the auth gate
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // The logic in main.dart will decide whether to show LoginScreen or MainNavigator
      // This pushReplacement is a fallback in case the app starts here directly.
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hub, color: Colors.white, size: 80),
            const SizedBox(height: 20),
            Text(
              "Community Connect",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}