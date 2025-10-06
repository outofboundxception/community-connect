// lib/screens/register/register_step2_interests.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../dashboard/main_navigator.dart';

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

class _RegisterStep2InterestsState extends State<RegisterStep2Interests> {
  final List<String> _allInterests = [
    "State Management",
    "UI/UX",
    "Firebase",
    "Testing",
    "Animation",
    "Desktop Dev",
    "Web Dev",
    "API Integration",
  ];
  final List<String> _selectedInterests = [];
  bool _isLoading = false;

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < 5) {
          _selectedInterests.add(interest);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You can select up to 5 interests.")),
          );
        }
      }
    });
  }

  void _signUp() async {
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
          MaterialPageRoute(builder: (_) => const MainNavigator()),
          (route) => false,
        );
      }
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Interests (Step 2 of 2)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select up to 5 interests:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _allInterests.map((interest) {
                final isSelected = _selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (_) => _toggleInterest(interest),
                  selectedColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.3),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _selectedInterests.isEmpty ? null : _signUp,
                      child: const Text("Finish Setup"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
