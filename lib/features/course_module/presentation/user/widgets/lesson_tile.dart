import 'package:flutter/material.dart';

class LessonTile extends StatelessWidget {
  final int index;
  final String title;
  final String contentPreview;
  final bool completed;
  final VoidCallback? onTap;

  const LessonTile({
    super.key,
    required this.index,
    required this.title,
    required this.contentPreview,
    this.completed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final preview = contentPreview.length > 80
        ? '${contentPreview.substring(0, 80)}...'
        : contentPreview;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: completed ? Colors.green : Colors.blueGrey.shade100,
          child: completed
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text('$index', style: const TextStyle(fontSize: 12)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(preview, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: onTap,
      ),
    );
  }
}
