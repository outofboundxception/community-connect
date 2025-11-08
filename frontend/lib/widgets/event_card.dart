import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';

// This is a reusable UI component, a form of Abstraction.
// It hides the complexity of how an event is displayed.
class EventCard extends StatelessWidget {
  final Event event;
  final bool isAdmin;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const EventCard({
    super.key,
    required this.event,
    this.isAdmin = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip
          .antiAlias, // Ensures the InkWell ripple stays within the rounded corners
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (isAdmin)
                    // Using a constrained box to ensure the icon has a proper tap area
                    // without adding too much padding.
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: onDelete,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Date: ${DateFormat.yMMMd().format(event.date)} by ${event.author}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_alt_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${event.likes}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 24),
                  Icon(
                    Icons.comment_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${event.comments}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
