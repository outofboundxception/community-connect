import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Auth endpoints
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['access']);
      await _storage.write(key: 'refresh_token', value: data['refresh']);
      
      // Get user profile
      final user = await getCurrentUser();
      return {'user': user};
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['access']);
      await _storage.write(key: 'refresh_token', value: data['refresh']);
      
      final user = User.fromJson(data['user']);
      return {'user': user};
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<void> logout() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken != null) {
      await http.post(
        Uri.parse('$baseUrl/auth/logout/'),
        headers: await _getHeaders(),
        body: jsonEncode({'refresh': refreshToken}),
      );
    }
    
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<User> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  // Posts endpoints
  Future<List<Post>> getPosts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'] ?? data;
      return results.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> getPost(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$id/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Post> createPost(String title, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create post');
    }
  }

  // Comments endpoints
  Future<List<Comment>> getComments(int postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId/comments/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<Comment> createComment(int postId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts/$postId/comments/'),
      headers: await _getHeaders(),
      body: jsonEncode({'content': content}),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create comment');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'access_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}