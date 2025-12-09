import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../domain/entities/course_entity.dart';

// Controller & usecase sisi user
import '../../user/controllers/user_course_controller.dart';
import '../../../domain/usecases/get_courses.dart';
import '../../../domain/usecases/get_lessons.dart';
import '../../../domain/usecases/enroll_in_course.dart';
import '../../../domain/usecases/get_user_enrollments.dart';
import '../../../domain/usecases/get_course_progress.dart';
import '../../../domain/usecases/toggle_lesson_completed.dart';
import '../../../domain/usecases/unenroll_from_course.dart';
import '../../../domain/usecases/get_reviews.dart';
import '../../../domain/usecases/get_user_review.dart';
import '../../../domain/usecases/upsert_review.dart';
import '../../../domain/usecases/delete_review.dart';

import 'admin_course_reviews_screen.dart';

class AdminReviewsScreen extends StatelessWidget {
  const AdminReviewsScreen({super.key});

  double _ratingValue(CourseEntity c) {
    if (c.rating == null) return 0;
    return double.tryParse(c.rating!.trim()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // Pastikan semua usecase sudah di-bind di CourseBindings
    final c = Get.put(
      UserCourseController(
        getCoursesUseCase: Get.find<GetCoursesUseCase>(),
        getLessonsUseCase: Get.find<GetLessonsUseCase>(),
        enrollInCourseUseCase: Get.find<EnrollInCourseUseCase>(),
        getUserEnrollmentsUseCase: Get.find<GetUserEnrollmentsUseCase>(),
        getCourseProgressUseCase: Get.find<GetCourseProgressUseCase>(),
        toggleLessonCompletedUseCase: Get.find<ToggleLessonCompletedUseCase>(),
        unenrollFromCourseUseCase: Get.find<UnenrollFromCourseUseCase>(),
        getReviewsUseCase: Get.find<GetReviewsUseCase>(),
        getUserReviewUseCase: Get.find<GetUserReviewUseCase>(),
        upsertReviewUseCase: Get.find<UpsertReviewUseCase>(),
        deleteReviewUseCase: Get.find<DeleteReviewUseCase>(),
      ),
      permanent: false,
    );

    // pastikan data course sudah di-load
    if (c.publishedCourses.isEmpty && !c.isLoadingCourses.value) {
      c.loadPublishedCourses();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Rating & Review Peserta')),
      body: Obx(() {
        if (c.isLoadingCourses.value && c.publishedCourses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = c.publishedCourses;

        if (items.isEmpty) {
          return const Center(child: Text('Belum ada kursus yang tersedia.'));
        }

        // Sort: rating desc → enrollmentCount desc
        final sorted = [...items]
          ..sort((a, b) {
            final rb = _ratingValue(b);
            final ra = _ratingValue(a);

            if (rb.compareTo(ra) != 0) return rb.compareTo(ra);

            return b.enrollmentCount.compareTo(a.enrollmentCount);
          });

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sorted.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final course = sorted[index];

            final avgRating = course.rating ?? '-';

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Get.to(() => AdminCourseReviewsScreen(course: course));
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Color(0x14000000),
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: course.thumbnail == null
                          ? Container(
                              width: 64,
                              height: 64,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.image_not_supported),
                            )
                          : Image.network(
                              course.thumbnail!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 14),

                    // Info kursus
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Iconsax.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                avgRating,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // nanti kalau sudah punya field "totalReviews" / "ratingCount",
                              // bisa tambahin: Text(' · $totalReviews review'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${course.enrollmentCount} peserta',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
