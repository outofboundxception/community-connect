class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatar;
  final String content;
  final List<String> mediaUrls;
  final List<String> mediaTypes; // 'image', 'video', 'audio'
  final List<String> hashtags;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int saves;
  final bool isLiked;
  final bool isSaved;
  final String? location;
  final List<String> mentions;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    this.mediaUrls = const [],
    this.mediaTypes = const [],
    this.hashtags = const [],
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.saves = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.location,
    this.mentions = const [],
  });

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? content,
    List<String>? mediaUrls,
    List<String>? mediaTypes,
    List<String>? hashtags,
    DateTime? createdAt,
    int? likes,
    int? comments,
    int? saves,
    bool? isLiked,
    bool? isSaved,
    String? location,
    List<String>? mentions,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaTypes: mediaTypes ?? this.mediaTypes,
      hashtags: hashtags ?? this.hashtags,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      saves: saves ?? this.saves,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      location: location ?? this.location,
      mentions: mentions ?? this.mentions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'mediaUrls': mediaUrls,
      'mediaTypes': mediaTypes,
      'hashtags': hashtags,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'saves': saves,
      'isLiked': isLiked,
      'isSaved': isSaved,
      'location': location,
      'mentions': mentions,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorAvatar: json['authorAvatar'],
      content: json['content'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      mediaTypes: List<String>.from(json['mediaTypes'] ?? []),
      hashtags: List<String>.from(json['hashtags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      saves: json['saves'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isSaved: json['isSaved'] ?? false,
      location: json['location'],
      mentions: List<String>.from(json['mentions'] ?? []),
    );
  }
}