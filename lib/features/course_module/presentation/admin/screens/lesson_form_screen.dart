import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/course_lessons_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/entities/lesson_entity.dart';

class LessonFormScreen extends StatefulWidget {
  final LessonEntity? lesson; // null = tambah, ada isi = edit

  const LessonFormScreen({super.key, this.lesson});

  @override
  State<LessonFormScreen> createState() => _LessonFormScreenState();
}

class _LessonFormScreenState extends State<LessonFormScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleC;
  late TextEditingController contentC;

  late CourseLessonsController c;
  late bool isEdit;

  @override
  void initState() {
    super.initState();
    c = Get.find<CourseLessonsController>();

    isEdit = widget.lesson != null;
    titleC = TextEditingController(text: widget.lesson?.title ?? '');
    contentC = TextEditingController(text: widget.lesson?.content ?? '');
  }

  @override
  void dispose() {
    titleC.dispose();
    contentC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;

    if (isEdit) {
      await c.updateLesson(
        id: widget.lesson!.id,
        title: titleC.text.trim(),
        content: contentC.text.trim(),
        order: widget.lesson!.order,
      );
    } else {
      await c.addLesson(
        title: titleC.text.trim(),
        content: contentC.text.trim(),
      );
    }

    // balik ke screen sebelumnya, kasih tanda berhasil
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Materi' : 'Tambah Materi')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleC,
                decoration: const InputDecoration(labelText: 'Judul Materi'),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: contentC,
                maxLines: 8,
                decoration: const InputDecoration(labelText: 'Konten materi'),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: Text(isEdit ? 'Simpan' : 'Tambah'),
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
