// presentation/screens/course_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/course_list_controller.dart';
import '../controllers/course_add_controller.dart';
import '../controllers/course_edit_controller.dart';
import 'course_add_screens.dart';
import 'course_edit_screens.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CourseListController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Kelas Terpopuler')),

      body: Obx(() {
        if (c.error.value != null) {
          return Center(child: Text(c.error.value!));
        }
        if (c.items.isEmpty && c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => c.reload(),
          child: ListView.builder(
            itemCount: c.items.length,
            itemBuilder: (ctx, i) {
              final it = c.items[i];
              return ListTile(
                title: Text(it.name),
                subtitle: Text('Rp ${it.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigasi ke halaman Edit
                    Get.to(
                      () => EditKelasScreen(courseId: it.id),
                      binding: BindingsBuilder(() {
                        Get.put(
                          CourseEditController(
                            courseId: it.id,
                            getCourseById: Get.find(),
                            updateCourse: Get.find(),
                          ),
                        );
                      }),
                    );
                  },
                ),
              );
            },
          ),
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => const TambahKelasScreen(),
            binding: BindingsBuilder(() {
              Get.put(
                CourseAddController(
                  createCourse: Get.find(),
                  listController:
                      Get.find<CourseListController>(), // biar auto refresh
                ),
              );
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
