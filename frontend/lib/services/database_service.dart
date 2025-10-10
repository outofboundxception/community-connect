// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Correct import

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> setUserData(User user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<User?> getUserData(String uid) async {
    final docSnap = await _usersCollection.doc(uid).get();
    if (docSnap.exists && docSnap.data() != null) {
      return User.fromMap(docSnap.data()!);
    }
    return null;
  }

  // THIS METHOD IS THE FIX
  Future<void> updateUserProfile(String uid, String fullName, String bio) async {
    await _usersCollection.doc(uid).update({
      'fullName': fullName,
      'bio': bio,
    });
  }

  Stream<List<User>> get allUsers {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
    });
  }
}