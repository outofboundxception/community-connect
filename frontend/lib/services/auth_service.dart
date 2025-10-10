// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'database_service.dart';

abstract class IAuthService with ChangeNotifier {
  User? get currentUser;
  bool get isAuthenticated;
  Future<void> login(String email, String password);
  Future<void> signUp(String fullName, String email, String password, List<String> interests);
  Future<void> logout();
}

class AuthService extends IAuthService {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();
  User? _currentUser;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  @override
  User? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  Future<void> _onAuthStateChanged(firebase.User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
    } else {
      _currentUser = await _db.getUserData(firebaseUser.uid);
    }
    notifyListeners();
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signUp(String fullName, String email, String password, List<String> interests) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        User newUser = User(
          uid: credential.user!.uid,
          fullName: fullName,
          email: email,
          interests: interests,
        );
        await _db.setUserData(newUser);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }
}