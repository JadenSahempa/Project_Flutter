import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final List<String> tags;
  final String priceText;
  final String? thumbnailUrl;
  final String? rating; // ⬅️ tambahkan ini
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CourseCard({
    super.key,
    required this.title,
    required this.tags,
    required this.priceText,
    this.thumbnailUrl,
    this.rating, // ⬅️ tambahkan ini
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final thumb =
        (thumbnailUrl != null &&
            thumbnailUrl!.startsWith('http') &&
            thumbnailUrl!.trim().isNotEmpty)
        ? thumbnailUrl
        : null;

    return Hero(
      tag: title,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              height: 64,
              color: const Color(0xFFE6F4EA),
              child: thumb == null
                  ? const Icon(Icons.book, size: 28, color: Colors.teal)
                  : Image.network(
                      thumb!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.book, size: 28, color: Colors.teal),
                    ),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),

              if (tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: tags.map((t) => _BadgePill(text: t)).toList(),
                ),

              const SizedBox(height: 8),

              // ⭐ Tambahin rating di sini
              if (rating != null && rating!.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        rating!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              Text(
                priceText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') onEdit?.call();
              if (v == 'delete') onDelete?.call();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Delete'),
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Edit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  final String text;
  const _BadgePill({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = text.toLowerCase().trim();
    final Color bg = switch (t) {
      'prakerja' => const Color(0xFF2F80ED),
      'spl' => const Color(0xFF22C55E),
      _ => const Color(0xFF64748B),
    };

    return Container(
      constraints: const BoxConstraints(minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
