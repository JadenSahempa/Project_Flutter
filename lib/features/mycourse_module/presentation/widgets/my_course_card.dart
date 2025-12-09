import 'package:flutter/material.dart';

class MyCourseCard extends StatelessWidget {
  final String title;
  final String description;
  final String? thumbnailUrl;
  final double progress; // 0.0 - 1.0
  final VoidCallback onTap;

  const MyCourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percentText = '${(progress * 100).round()}%';

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (thumbnailUrl == null || thumbnailUrl!.trim().isEmpty)
                      ? Container(color: Colors.grey.shade300)
                      : Image.network(
                          thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey.shade300),
                        ),
                ),
              ),
              const SizedBox(height: 8),

              // Judul & deskripsi singkat
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Progress bar
              const Text(
                'Proses Belajar',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: LinearProgressIndicator(value: progress)),
                  const SizedBox(width: 8),
                  Text(
                    percentText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
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
