// lib/screens/register/register_step1_screen.dart
import 'package:flutter/material.dart';
import 'register_step2_interests.dart';

class RegisterStep1Screen extends StatelessWidget {
  const RegisterStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final fullNameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Account Setup (Step 1 of 2)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email Address"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Add validation
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RegisterStep2Interests(
                      fullName: fullNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  ),
                );
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
