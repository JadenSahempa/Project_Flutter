import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../domain/entities/course_entity.dart';
import '../../user/controllers/user_course_controller.dart';

class AdminCourseReviewsScreen extends StatefulWidget {
  final CourseEntity course;

  const AdminCourseReviewsScreen({super.key, required this.course});

  @override
  State<AdminCourseReviewsScreen> createState() =>
      _AdminCourseReviewsScreenState();
}

class _AdminCourseReviewsScreenState extends State<AdminCourseReviewsScreen> {
  late final UserCourseController c;

  @override
  void initState() {
    super.initState();
    c = Get.find<UserCourseController>();

    // load review untuk course ini
    c.loadReviews(widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    return Scaffold(
      appBar: AppBar(title: Text('Review: ${course.name}')),
      body: Obx(() {
        final isLoading = c.isLoadingReviews.value;
        final reviews = c.reviews; // asumsikan list review untuk course ini

        if (isLoading && (reviews.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (reviews.isEmpty) {
          return const Center(
            child: Text('Belum ada review untuk kursus ini.'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: reviews.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final r = reviews[index];

            final userName = r.userName ?? 'User';
            final rating = r.rating;
            final comment = r.comment ?? '-';

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: avatar + nama
                  Row(
                    children: [
                      const CircleAvatar(child: Icon(Icons.person)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      // kalau nanti mau tambah tombol delete:
                      // IconButton(
                      //   icon: const Icon(Iconsax.trash, color: Colors.red),
                      //   onPressed: () { ... },
                      // ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      const Icon(Iconsax.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text('$rating/5'),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Comment
                  Text(comment, style: const TextStyle(fontSize: 13)),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
