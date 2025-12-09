import 'package:flutter/material.dart';

class UserCourseCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tags;
  final String priceText;
  final String? thumbnailUrl;
  final String? rating;
  final int enrollmentCount;
  final VoidCallback? onTap;

  const UserCourseCard({
    super.key,
    required this.title,
    required this.description,
    required this.tags,
    required this.priceText,
    this.thumbnailUrl,
    this.rating,
    this.enrollmentCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final thumb = thumbnailUrl?.trim().isEmpty == true ? null : thumbnailUrl;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 72,
                  height: 72,
                  color: const Color(0xFFE6F4EA),
                  child: thumb == null
                      ? const Icon(Icons.book, size: 32, color: Colors.teal)
                      : Image.network(
                          thumb,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.book,
                            size: 32,
                            color: Colors.teal,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: tags
                          .map(
                            (t) => Chip(
                              label: Text(
                                t,
                                style: const TextStyle(fontSize: 11),
                              ),
                              backgroundColor: Colors.purple.shade50,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          priceText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const Spacer(),
                        if (rating != null && rating!.trim().isNotEmpty) ...[
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            rating!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        const Icon(Icons.people_alt_outlined, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          '$enrollmentCount siswa',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
