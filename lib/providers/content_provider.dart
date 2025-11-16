import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/newsletter_model.dart';
import '../services/content_service.dart';

class ContentProvider with ChangeNotifier {
  final ContentService _service = ContentService();

  List<Post> _posts = [];
  List<Comment> _comments = [];
  List<Newsletter> _newsletters = [];

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  String? _error;

  List<Post> get posts => _posts;
  List<Comment> get comments => _comments;
  List<Newsletter> get newsletters => _newsletters;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  // Fetch posts with pagination
  Future<void> fetchPosts({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _posts = [];
      _hasMore = true;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newPosts = await _service.fetchPosts(page: _currentPage, limit: 10);

      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        _posts.addAll(newPosts);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search posts
  Future<void> searchPosts(String query, {List<String>? filters}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _posts = await _service.searchPosts(query, filters: filters);
      _hasMore = false;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create post
  Future<bool> createPost(Post post) async {
    try {
      final newPost = await _service.createPost(post);
      _posts.insert(0, newPost);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Toggle like
  Future<void> toggleLike(String postId) async {
    try {
      final idx = _posts.indexWhere((p) => p.id == postId);
      if (idx != -1) {
        _posts[idx] = _posts[idx].copyWith(
          isLiked: !_posts[idx].isLiked,
          likes: _posts[idx].isLiked ? _posts[idx].likes - 1 : _posts[idx].likes + 1,
        );
        notifyListeners();

        await _service.toggleLike(postId);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Toggle save
  Future<void> toggleSave(String postId) async {
    try {
      final idx = _posts.indexWhere((p) => p.id == postId);
      if (idx != -1) {
        _posts[idx] = _posts[idx].copyWith(isSaved: !_posts[idx].isSaved);
        notifyListeners();

        await _service.toggleSave(postId);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fetch comments
  Future<void> fetchComments(String postId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _comments = await _service.fetchComments(postId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add comment
  Future<bool> addComment(Comment comment) async {
    try {
      final newComment = await _service.addComment(comment);
      _comments.insert(0, newComment);

      final postIdx = _posts.indexWhere((p) => p.id == comment.postId);
      if (postIdx != -1) {
        _posts[postIdx] = _posts[postIdx].copyWith(
          comments: _posts[postIdx].comments + 1,
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Fetch newsletters
  Future<void> fetchNewsletters() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _newsletters = await _service.fetchNewsletters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}