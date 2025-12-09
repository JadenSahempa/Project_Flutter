import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/course_module/presentation/user/controllers/user_course_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/widgets/user_course_card.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/screens/course_detail_screen.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UserCourseController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Kelasku')),
      body: Obx(() {
        if (c.isLoadingCourses.value || c.isLoadingEnrollments.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final myCourses = c.publishedCourses
            .where((course) => c.isEnrolled(course.id))
            .toList();

        if (myCourses.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada kelas yang kamu ikuti.\n'
              'Enroll dulu dari halaman Kelas 😉',
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: myCourses.length,
          itemBuilder: (context, index) {
            final course = myCourses[index];
            return UserCourseCard(
              title: course.name,
              description: course.description ?? '',
              tags: course.categoryTag,
              priceText: course.price == '0.00'
                  ? 'Gratis'
                  : 'Rp ${course.price}',
              thumbnailUrl: course.thumbnail,
              rating: course.rating,
              enrollmentCount: course.enrollmentCount,
              onTap: () async {
                await c.loadCourseDetail(course.id, course);
                Get.to(() => CourseDetailScreen(courseId: course.id));
              },
            );
          },
        );
      }),
    );
  }
}
