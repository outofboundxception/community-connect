class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;
  final String? parentCommentId; // For threaded replies
  final List<Comment> replies;
  final bool isEdited;
  final bool isReported;

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    this.parentCommentId,
    this.replies = const [],
    this.isEdited = false,
    this.isReported = false,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? content,
    DateTime? createdAt,
    int? likes,
    bool? isLiked,
    String? parentCommentId,
    List<Comment>? replies,
    bool? isEdited,
    bool? isReported,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
      isEdited: isEdited ?? this.isEdited,
      isReported: isReported ?? this.isReported,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'isLiked': isLiked,
      'parentCommentId': parentCommentId,
      'replies': replies.map((r) => r.toJson()).toList(),
      'isEdited': isEdited,
      'isReported': isReported,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorAvatar: json['authorAvatar'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      parentCommentId: json['parentCommentId'],
      replies: (json['replies'] as List?)
          ?.map((r) => Comment.fromJson(r))
          .toList() ??
          [],
      isEdited: json['isEdited'] ?? false,
      isReported: json['isReported'] ?? false,
    );
  }
}