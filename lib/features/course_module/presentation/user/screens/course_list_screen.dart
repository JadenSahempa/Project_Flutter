import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/course_module/presentation/user/controllers/user_course_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/widgets/user_course_card.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/screens/course_detail_screen.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Asumsi: UserCourseController sudah di-register di bindings / MainShell
    final c = Get.find<UserCourseController>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kelas Untuk Kamu'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Terpopuler'),
              Tab(text: 'SPL'),
              Tab(text: 'Prakerja'),
            ],
          ),
        ),
        body: Obx(() {
          if (c.isLoadingCourses.value && c.publishedCourses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (c.coursesError.value != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Terjadi masalah:\n${c.coursesError.value}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: c.loadPublishedCourses,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          if (c.publishedCourses.isEmpty) {
            return RefreshIndicator(
              onRefresh: c.loadPublishedCourses,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Text(
                    'Belum ada kelas yang tersedia.\n'
                    'Silakan cek lagi nanti ya 😊',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // 🔹 Ambil data untuk masing-masing tab (max 10 item)
          final popular = c.popularCourses.take(10).toList();
          final spl = c.splCourses.take(10).toList();
          final prakerja = c.prakerjaCourses.take(10).toList();

          return TabBarView(
            children: [
              _CourseListTab(
                items: popular,
                emptyText:
                    'Belum ada kelas terpopuler (belum ada rating dari pengguna).',
                onRefresh: c.loadPublishedCourses,
              ),
              _CourseListTab(
                items: spl,
                emptyText: 'Belum ada kelas dengan tag SPL.',
                onRefresh: c.loadPublishedCourses,
              ),
              _CourseListTab(
                items: prakerja,
                emptyText: 'Belum ada kelas dengan tag Prakerja.',
                onRefresh: c.loadPublishedCourses,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _CourseListTab extends StatelessWidget {
  final List<dynamic> items; // bisa ganti ke List<CourseEntity> kalau mau
  final String emptyText;
  final Future<void> Function() onRefresh;

  const _CourseListTab({
    required this.items,
    required this.emptyText,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UserCourseController>();

    if (items.isEmpty) {
      // Tetap pakai RefreshIndicator supaya bisa pull-to-refresh di tab kosong
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              emptyText,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final course = items[index];

          return UserCourseCard(
            title: course.name,
            description: course.description ?? '',
            tags: course.categoryTag,
            priceText: course.price == '0.00' || course.price == '0'
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
      ),
    );
  }
}
