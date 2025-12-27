import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/course_lessons_controller.dart';
import 'lesson_form_screen.dart'; // paling atas file

class ManageLessonsScreen extends StatelessWidget {
  const ManageLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CourseLessonsController>();

    // Ambil info kelas dari arguments
    String? courseName;
    String? courseDescription;
    String status = 'draft';

    final args = Get.arguments;
    if (args is Map) {
      courseName = args['courseName'] as String?;
      courseDescription = args['description'] as String?;
      final s = args['status'] as String?;
      if (s != null && s.isNotEmpty) {
        status = s;
      }
    }

    final bool canEditLessons = status == 'draft' || status == 'maintenance';

    return Scaffold(
      appBar: AppBar(
        title: Text(courseName ?? 'Kelola Materi Kelas'),
        actions: [
          // badge status di AppBar
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _StatusPill(status: status),
            ),
          ),
          // IconButton(
          //   tooltip: 'Edit Info Kelas',
          //   icon: const Icon(Icons.edit),
          //   onPressed: () {
          //     // Biar gampang: buka EditKelasScreen kalau mau ubah status/nama/deskripsi
          //     Get.to(() => EditKelasScreen(courseId: c.courseId));
          //   },
          // ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.error.value != null) {
          return Center(child: Text('Terjadi error: ${c.error.value}'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: c.lessons.length + 1, // +1 untuk header info kelas
          itemBuilder: (context, index) {
            // Index 0: header info (nama + deskripsi + catatan status)
            if (index == 0) {
              return _CourseHeader(
                courseName: courseName,
                description: courseDescription,
                status: status,
                canEditLessons: canEditLessons,
              );
            }

            final lesson = c.lessons[index - 1];

            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${lesson.order}')),
                title: Text(lesson.title),
                subtitle: Text(
                  lesson.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () async {
                  if (!canEditLessons) {
                    Get.snackbar(
                      'Tidak bisa mengubah materi',
                      'Ubah status kelas ke Draft atau Maintenance dulu.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  final changed = await Get.to<bool>(
                    () => LessonFormScreen(lesson: lesson),
                  );

                  if (changed == true) {
                    await c.loadLessons();
                  }
                },

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    if (!canEditLessons) {
                      Get.snackbar(
                        'Tidak bisa menghapus materi',
                        'Ubah status kelas ke Draft atau Maintenance dulu.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Materi'),
                        content: Text('Hapus materi "${lesson.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) {
                      await c.deleteLesson(lesson.id);
                    }
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!canEditLessons) {
            Get.snackbar(
              'Tidak bisa menambah materi',
              'Ubah status kelas ke Draft atau Maintenance dulu.',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          final changed = await Get.to<bool>(() => const LessonFormScreen());

          // optional: kalau mau extra aman reload lagi
          if (changed == true) {
            await c.loadLessons();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Materi'),
      ),
    );
  }

  // ignore: unused_element
  Future<void> _showLessonForm({
    required BuildContext context,
    required CourseLessonsController controller,
    String? lessonId,
    String? initialTitle,
    String? initialContent,
    int? order,
  }) async {
    final titleC = TextEditingController(text: initialTitle ?? '');
    final contentC = TextEditingController(text: initialContent ?? '');
    final formKey = GlobalKey<FormState>();

    final isEdit = lessonId != null;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Materi' : 'Tambah Materi'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleC,
                    decoration: const InputDecoration(
                      labelText: 'Judul Materi',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: contentC,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Konten materi',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                if (isEdit) {
                  await controller.updateLesson(
                    id: lessonId,
                    // !
                    title: titleC.text.trim(),
                    content: contentC.text.trim(),
                    order: order ?? 1,
                  );
                } else {
                  await controller.addLesson(
                    title: titleC.text.trim(),
                    content: contentC.text.trim(),
                  );
                }

                Navigator.of(dialogContext).pop();
              },
              child: Text(isEdit ? 'Simpan' : 'Tambah'),
            ),
          ],
        );
      },
    );
  }
}

// ================== WIDGET KECIL: HEADER & BADGE STATUS ==================

class _CourseHeader extends StatelessWidget {
  final String? courseName;
  final String? description;
  final String status;
  final bool canEditLessons;

  const _CourseHeader({
    this.courseName,
    this.description,
    required this.status,
    required this.canEditLessons,
  });

  @override
  Widget build(BuildContext context) {
    final desc = description?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (courseName != null && courseName!.isNotEmpty) ...[
          Text(
            courseName!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
        ],
        Row(
          children: [
            // _StatusPill(status: status),
            const SizedBox(width: 8),
            if (!canEditLessons)
              const Flexible(
                child: Text(
                  'Kelas sudah Published. '
                  'Untuk mengubah materi, ubah status ke Draft atau Maintenance dulu.',
                  style: TextStyle(fontSize: 12, color: Colors.redAccent),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (desc.isNotEmpty) ...[
          const Text(
            'Deskripsi Kelas',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(desc),
          const SizedBox(height: 16),
        ],
        const Divider(),
        const SizedBox(height: 8),
      ],
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
        borderRadius: BorderRadius.circular(999),
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
