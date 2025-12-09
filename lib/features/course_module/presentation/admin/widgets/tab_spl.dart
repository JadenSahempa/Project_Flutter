import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/screens/course_add_screens.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/screens/manage_lessons_screens.dart';

import '../controllers/course_controller.dart';
import 'course_card.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/screens/course_edit_screens.dart'
    show EditKelasScreen;
// import 'package:luar_sekolah_lms/features/course_module/presentation/admin/screens/manage_lessons_screens.dart';

class SplCoursesTab extends StatelessWidget {
  const SplCoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CourseController>();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Buat layar tambah kelas
          Get.to(() => const TambahKelasScreen());
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kelas'),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.error.value != null) {
          return Center(child: Text('Terjadi masalah: ${c.error.value}'));
        }

        final items = c.splCourses;

        if (items.isEmpty) {
          return const Center(child: Text('Belum ada kelas SPL.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CourseCard(
                title: item.name,
                tags: item.categoryTag,
                priceText: item.price == '0.00' ? 'Gratis' : 'Rp ${item.price}',
                thumbnailUrl: item.thumbnail,
                rating: item.rating,
                status: item.status,
                onEdit: () {
                  Get.to(() => EditKelasScreen(courseId: item.id));
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: const Text('Hapus Kelas'),
                        content: Text('Yakin ingin menghapus "${item.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(false),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    await c.deleteCourse(item.id);
                    Get.snackbar(
                      'Berhasil',
                      'Kelas berhasil dihapus.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                onManageLessons: () {
                  Get.to(
                    () => const ManageLessonsScreen(),
                    arguments: {
                      'courseId': item.id,
                      'courseName': item.name,
                      'description': item.description,
                      'status': item.status,
                    },
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
