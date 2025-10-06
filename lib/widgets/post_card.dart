// lib/widgets/post_card.dart
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String author;
  final String content;
  final String timeAgo;

  const PostCard({
    super.key,
    required this.author,
    required this.content,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      timeAgo,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(content),
          ],
        ),
      ),
    );
  }
}
