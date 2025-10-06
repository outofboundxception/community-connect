// lib/services/auth_service.dart
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

// Abstract class defining the contract for any authentication service
abstract class IAuthService with ChangeNotifier {
  User? get currentUser;
  bool get isAuthenticated;
  Future<void> login(String email, String password);
  Future<void> signUp(
    String fullName,
    String email,
    String password,
    List<String> interests,
  );
  Future<void> logout();
}

// Concrete implementation of the authentication service
class AuthService extends IAuthService {
  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  Future<void> login(String email, String password) async {
    // TODO: Implement actual login logic with a backend (e.g., Firebase)
    print("Attempting login with $email");
    await Future.delayed(const Duration(seconds: 1));
    // Mock user for demonstration
    _currentUser = User(
      uid: "123",
      fullName: "Alex Thompson",
      email: email,
      isAdmin: true,
    );
    notifyListeners(); // Notify listeners about the change
  }

  @override
  Future<void> signUp(
    String fullName,
    String email,
    String password,
    List<String> interests,
  ) async {
    // TODO: Implement actual sign-up logic
    print("Signing up $fullName");
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      uid: "123",
      fullName: fullName,
      email: email,
      interests: interests,
    );
    notifyListeners();
  }

  @override
  Future<void> logout() async {
    // TODO: Implement actual logout logic
    print("Logging out");
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
    notifyListeners();
  }
}
