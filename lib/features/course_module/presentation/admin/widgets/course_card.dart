import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final List<String> tags;
  final String priceText;
  final String? thumbnailUrl;
  final String? rating;
  final String? status;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onManageLessons;

  const CourseCard({
    super.key,
    required this.title,
    required this.tags,
    required this.priceText,
    this.thumbnailUrl,
    this.rating,
    this.onEdit,
    this.onDelete,
    this.onManageLessons,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final thumb = thumbnailUrl?.trim().isEmpty == true ? null : thumbnailUrl;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 64,
            height: 64,
            color: const Color(0xFFE6F4EA),
            child: thumb == null
                ? const Icon(Icons.book, size: 28, color: Colors.teal)
                : Image.network(
                    thumb,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.book, size: 28, color: Colors.teal),
                  ),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            if (status != null && status!.isNotEmpty) ...[
              _StatusPill(status: status!), // ⬅️ badge kecil status
              const SizedBox(height: 4),
            ],

            Text(
              priceText,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: tags.map((t) => _BadgePill(text: t)).toList(),
            ),
            const SizedBox(height: 8),
            if (rating != null && rating!.trim().isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    rating!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit?.call();
            } else if (value == 'delete') {
              onDelete?.call();
            } else if (value == 'lessons') {
              onManageLessons?.call();
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit_outlined),
                title: Text('Edit'),
              ),
            ),
            PopupMenuItem(
              value: 'lessons',
              child: ListTile(
                leading: Icon(Icons.menu_book_outlined),
                title: Text('Kelola Materi'),
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Hapus'),
              ),
            ),
          ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.deepPurple,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  Color _bgColor() {
    switch (status) {
      case 'draft':
        return Colors.grey.withOpacity(0.1);
      case 'published':
        return Colors.green.withOpacity(0.1);
      case 'maintenance':
        return Colors.orange.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Color _textColor() {
    switch (status) {
      case 'draft':
        return Colors.grey[700]!;
      case 'published':
        return Colors.green[700]!;
      case 'maintenance':
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  String _label() {
    switch (status) {
      case 'draft':
        return 'Draft';
      case 'published':
        return 'Published';
      case 'maintenance':
        return 'Maintenance';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _label(),
        style: TextStyle(
          color: _textColor(),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
