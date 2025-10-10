// lib/screens/register/register_step2_interests.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';

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
  final List<String> _allInterests = ['Coding', 'Music', 'Sports', 'Art', 'Travel', 'Reading'];
  final List<String> _selectedInterests = [];
  bool _isLoading = false;

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  Future<void> _finishSignUp() async {
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one interest.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final authService = Provider.of<IAuthService>(context, listen: false);

    try {
      await authService.signUp(
        widget.fullName,
        widget.email,
        widget.password,
        _selectedInterests,
      );
      // Navigation is handled automatically by the listener in main.dart
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign Up Failed: ${e.toString()}")),
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
      appBar: AppBar(title: const Text('Select Your Interests')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('What are you passionate about?', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: _allInterests.map((interest) {
                final isSelected = _selectedInterests.contains(interest);
                return ChoiceChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (_) => _toggleInterest(interest),
                  selectedColor: Colors.orangeAccent,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                );
              }).toList(),
            ),
            const Spacer(),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _finishSignUp,
                    child: const Text('Complete Registration'),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}