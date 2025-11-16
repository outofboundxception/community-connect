class Newsletter {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime publishedDate;
  final List<NewsletterSection> sections;
  final String coverImageUrl;
  final int views;
  final bool isPublished;
  final String? pdfUrl;

  Newsletter({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.publishedDate,
    required this.sections,
    required this.coverImageUrl,
    this.views = 0,
    this.isPublished = false,
    this.pdfUrl,
  });

  Newsletter copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? publishedDate,
    List<NewsletterSection>? sections,
    String? coverImageUrl,
    int? views,
    bool? isPublished,
    String? pdfUrl,
  }) {
    return Newsletter(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      publishedDate: publishedDate ?? this.publishedDate,
      sections: sections ?? this.sections,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      views: views ?? this.views,
      isPublished: isPublished ?? this.isPublished,
      pdfUrl: pdfUrl ?? this.pdfUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'publishedDate': publishedDate.toIso8601String(),
      'sections': sections.map((s) => s.toJson()).toList(),
      'coverImageUrl': coverImageUrl,
      'views': views,
      'isPublished': isPublished,
      'pdfUrl': pdfUrl,
    };
  }

  factory Newsletter.fromJson(Map<String, dynamic> json) {
    return Newsletter(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      publishedDate: DateTime.parse(json['publishedDate']),
      sections: (json['sections'] as List)
          .map((s) => NewsletterSection.fromJson(s))
          .toList(),
      coverImageUrl: json['coverImageUrl'],
      views: json['views'] ?? 0,
      isPublished: json['isPublished'] ?? false,
      pdfUrl: json['pdfUrl'],
    );
  }
}

class NewsletterSection {
  final String title;
  final String content;
  final List<String> highlightedPosts;
  final List<String> mediaUrls;

  NewsletterSection({
    required this.title,
    required this.content,
    this.highlightedPosts = const [],
    this.mediaUrls = const [],
  });

  NewsletterSection copyWith({
    String? title,
    String? content,
    List<String>? highlightedPosts,
    List<String>? mediaUrls,
  }) {
    return NewsletterSection(
      title: title ?? this.title,
      content: content ?? this.content,
      highlightedPosts: highlightedPosts ?? this.highlightedPosts,
      mediaUrls: mediaUrls ?? this.mediaUrls,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'highlightedPosts': highlightedPosts,
      'mediaUrls': mediaUrls,
    };
  }

  factory NewsletterSection.fromJson(Map<String, dynamic> json) {
    return NewsletterSection(
      title: json['title'],
      content: json['content'],
      highlightedPosts: List<String>.from(json['highlightedPosts'] ?? []),
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
    );
  }
}