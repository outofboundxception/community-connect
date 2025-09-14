import 'user_model.dart';
import 'comment_model.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final User user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Comment> comments;
  final int commentsCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.comments,
    required this.commentsCount,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      user: User.fromJson(json['user']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((comment) => Comment.fromJson(comment))
          .toList() ?? [],
      commentsCount: json['comments_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'user': user.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'comments_count': commentsCount,
    };
  }
}