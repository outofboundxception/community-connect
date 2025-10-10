// lib/widgets/event_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isAdmin;
  final VoidCallback? onDelete;

  const EventCard({
    super.key,
    required this.event,
    this.isAdmin = false,
    this.onDelete,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (isAdmin)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  )
              ],
            ),
            const SizedBox(height: 8),
            Text("Date: ${DateFormat.yMMMd().format(event.date)} by ${event.author}"),
            const SizedBox(height: 12),
            Text(event.description, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}