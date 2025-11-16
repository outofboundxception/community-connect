import 'dart:math';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/newsletter_model.dart';

class ContentService {
  static List<Post> _cachedPosts = [];
  static List<Comment> _cachedComments = [];
  static List<Newsletter> _cachedNewsletters = [];

  // Fetch posts with pagination
  Future<List<Post>> fetchPosts({int page = 1, int limit = 10}) async {
    await Future.delayed(Duration(milliseconds: 800));

    if (_cachedPosts.isEmpty) {
      _cachedPosts = _generateMockPosts(50);
    }

    final start = (page - 1) * limit;
    final end = min(start + limit, _cachedPosts.length);

    if (start >= _cachedPosts.length) return [];

    return _cachedPosts.sublist(start, end);
  }

  // Search posts
  Future<List<Post>> searchPosts(String query, {List<String>? filters}) async {
    await Future.delayed(Duration(milliseconds: 500));

    return _cachedPosts.where((post) {
      final matchesQuery = post.content.toLowerCase().contains(query.toLowerCase()) ||
          post.hashtags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));

      if (filters != null && filters.isNotEmpty) {
        return matchesQuery && post.hashtags.any((tag) => filters.contains(tag));
      }

      return matchesQuery;
    }).toList();
  }

  // Create post
  Future<Post> createPost(Post post) async {
    await Future.delayed(Duration(milliseconds: 600));
    _cachedPosts.insert(0, post);
    return post;
  }

  // Like/Unlike post
  Future<Post> toggleLike(String postId) async {
    await Future.delayed(Duration(milliseconds: 200));

    final idx = _cachedPosts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      final post = _cachedPosts[idx];
      _cachedPosts[idx] = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
      return _cachedPosts[idx];
    }
    throw Exception('Post not found');
  }

  // Save/Unsave post
  Future<Post> toggleSave(String postId) async {
    await Future.delayed(Duration(milliseconds: 200));

    final idx = _cachedPosts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      final post = _cachedPosts[idx];
      _cachedPosts[idx] = post.copyWith(isSaved: !post.isSaved);
      return _cachedPosts[idx];
    }
    throw Exception('Post not found');
  }

  // Fetch comments
  Future<List<Comment>> fetchComments(String postId) async {
    await Future.delayed(Duration(milliseconds: 500));

    if (_cachedComments.isEmpty) {
      _cachedComments = _generateMockComments(postId, 20);
    }

    return _cachedComments.where((c) => c.postId == postId).toList();
  }

  // Add comment
  Future<Comment> addComment(Comment comment) async {
    await Future.delayed(Duration(milliseconds: 400));
    _cachedComments.add(comment);
    return comment;
  }

  // Fetch newsletters
  Future<List<Newsletter>> fetchNewsletters() async {
    await Future.delayed(Duration(milliseconds: 600));

    if (_cachedNewsletters.isEmpty) {
      _cachedNewsletters = _generateMockNewsletters(5);
    }

    return _cachedNewsletters;
  }

  // Mock data generators
  List<Post> _generateMockPosts(int count) {
    final random = Random();
    final contents = [
      'Just attended an amazing community meetup! 🎉 Great to see everyone.',
      'Excited about our upcoming cultural festival! Stay tuned for details.',
      'Looking for volunteers for the charity drive this weekend. Who\'s in?',
      'Had a wonderful time at the alumni gathering. Memories were made! 📸',
      'Our community is growing stronger every day. Thank you all!',
      'Check out these beautiful moments from yesterday\'s event.',
      'Planning a networking session next month. Mark your calendars!',
      'Congratulations to all scholarship recipients! 🎓',
    ];

    final hashtags = ['community', 'events', 'alumni', 'networking', 'culture', 'charity', 'festival'];
    final names = ['Kanika Gadiya', 'Gitraj Chaudhari', 'Bhavya Prajapati', 'Srusti Gelani', 'Gauri Sevalkar', 'Ayush Verma'];

    return List.generate(count, (i) {
      final hasMedia = random.nextBool();
      return Post(
        id: 'post_$i',
        authorId: 'user_${random.nextInt(10)}',
        authorName: names[random.nextInt(names.length)],
        authorAvatar: 'https://i.pravatar.cc/150?img=${random.nextInt(70)}',
        content: contents[random.nextInt(contents.length)],
        mediaUrls: hasMedia ? [
          'https://picsum.photos/600/800?random=$i',
        ] : [],
        mediaTypes: hasMedia ? ['image'] : [],
        hashtags: List.generate(
          random.nextInt(3) + 1,
              (_) => hashtags[random.nextInt(hashtags.length)],
        ),
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
        likes: random.nextInt(100),
        comments: random.nextInt(30),
        saves: random.nextInt(50),
        isLiked: random.nextBool(),
        location: random.nextBool() ? 'Gandhinagar, Gujarat' : null,
      );
    });
  }

  List<Comment> _generateMockComments(String postId, int count) {
    final random = Random();
    final comments = [
      'This is amazing! 🙌',
      'Great initiative!',
      'Count me in!',
      'Thanks for sharing!',
      'Looking forward to it!',
      'Wonderful work! 👏',
    ];
    final names = ['John Doe', 'Jane Smith', 'Alex Johnson', 'Maria Garcia'];

    return List.generate(count, (i) => Comment(
      id: 'comment_$i',
      postId: postId,
      authorId: 'user_${random.nextInt(10)}',
      authorName: names[random.nextInt(names.length)],
      authorAvatar: 'https://i.pravatar.cc/150?img=${random.nextInt(70)}',
      content: comments[random.nextInt(comments.length)],
      createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(24))),
      likes: random.nextInt(20),
      isLiked: random.nextBool(),
    ));
  }

  List<Newsletter> _generateMockNewsletters(int count) {
    return List.generate(count, (i) => Newsletter(
      id: 'newsletter_$i',
      title: 'Community Newsletter - ${DateTime.now().subtract(Duration(days: i * 30)).month}/${DateTime.now().year}',
      description: 'Monthly highlights and updates from our community',
      createdAt: DateTime.now().subtract(Duration(days: i * 30)),
      publishedDate: DateTime.now().subtract(Duration(days: i * 30)),
      sections: [
        NewsletterSection(
          title: 'Community Highlights',
          content: 'Amazing events and achievements this month!',
          highlightedPosts: ['post_1', 'post_2'],
        ),
      ],
      coverImageUrl: 'https://picsum.photos/800/400?random=$i',
      views: Random().nextInt(500),
      isPublished: true,
    ));
  }
}