import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/mycourse_module/presentation/controllers/my_courses_controller.dart';
import 'package:luar_sekolah_lms/features/mycourse_module/presentation/widgets/my_course_card.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_courses.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_lessons.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_course_progress.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_user_enrollments.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/screens/course_detail_screen.dart';

// ✅ TODO module (Clean Architecture)
import 'package:luar_sekolah_lms/features/todo_module/presentation/screens/todo_list_screen.dart';
import 'package:luar_sekolah_lms/features/todo_module/presentation/bindings/todo_bindings.dart';
import 'package:luar_sekolah_lms/features/todo_module/presentation/controllers/todo_controller.dart';

class KelaskuScreen extends StatelessWidget {
  const KelaskuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Register MyCoursesController kalau belum ada
    if (!Get.isRegistered<MyCoursesController>()) {
      Get.lazyPut(
        () => MyCoursesController(
          getCoursesUseCase: Get.find<GetCoursesUseCase>(),
          getLessonsUseCase: Get.find<GetLessonsUseCase>(),
          getCourseProgressUseCase: Get.find<GetCourseProgressUseCase>(),
          getUserEnrollmentsUseCase: Get.find<GetUserEnrollmentsUseCase>(),
        ),
        fenix: true,
      );
    }

    // Register semua dependency Todo hanya sekali
    if (!Get.isRegistered<TodoController>()) {
      TodoBindings().dependencies();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kelasku'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Kelas Saya'),
              Tab(text: 'To-Do List'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MyCoursesTab(),
            // 🔹 Tab 2 langsung pakai screen dari todo_module
            TodoListScreen(),
          ],
        ),
      ),
    );
  }
}

//
// ────────────────────────────────────────────────────────────
//  TAB 1 — KELAS SAYA
// ────────────────────────────────────────────────────────────
//

class _MyCoursesTab extends StatelessWidget {
  const _MyCoursesTab();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<MyCoursesController>();

    return Obx(() {
      if (c.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (c.error.value != null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Terjadi masalah:\n${c.error.value}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: c.loadMyCourses,
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        );
      }

      if (c.items.isEmpty) {
        return RefreshIndicator(
          onRefresh: c.loadMyCourses,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              Text(
                'Belum ada kelas yang kamu enroll.\n'
                'Yuk pilih kelas dulu di tab Kelas 😊',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: c.loadMyCourses,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: c.items.length,
          itemBuilder: (context, index) {
            final item = c.items[index];
            final course = item.course;

            return MyCourseCard(
              title: course.name,
              description: course.description ?? '',
              thumbnailUrl: course.thumbnail,
              progress: item.progress,
              onTap: () {
                Get.to(() => CourseLearnScreen(courseId: course.id));
              },
            );
          },
        ),
      );
    });
  }
}
