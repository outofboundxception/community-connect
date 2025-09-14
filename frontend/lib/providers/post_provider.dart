import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiService _apiService = ApiService();

  Future<void> fetchPosts() async {
    _setLoading(true);
    _error = null;
    
    try {
      _posts = await _apiService.getPosts();
    } catch (e) {
      _error = e.toString();
    }
    
    _setLoading(false);
  }

  Future<bool> createPost(String title, String content) async {
    _setLoading(true);
    _error = null;
    
    try {
      final newPost = await _apiService.createPost(title, content);
      _posts.insert(0, newPost);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<Post?> getPostById(int id) async {
    try {
      return await _apiService.getPost(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}