import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/course_module/presentation/admin/controllers/courseEditController.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_course_detail.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/update_course.dart';

class EditKelasScreen extends StatelessWidget {
  final String courseId;

  const EditKelasScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(
      CourseEditController(
        courseId: courseId,
        getCourseDetailUseCase: Get.find<GetCourseDetailUseCase>(),
        updateCourseUseCase: Get.find<UpdateCourseUseCase>(),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kelas')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Obx(() {
                        if (c.isLoading.value) {
                          return const SizedBox(
                            height: 180,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        return Form(
                          key: c.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Informasi Kelas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // ================= NAMA KELAS =================
                              const Text('Nama Kelas'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: c.namaC,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                    ? 'Nama kelas wajib diisi'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // ================= HARGA KELAS =================
                              const Text('Harga Kelas'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: c.hargaC,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'e.g 1000000 atau 1000000.00',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ================= DESKRIPSI =================
                              const Text('Deskripsi Kelas'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: c.deskripsiC,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Tuliskan deskripsi singkat tentang kelas ini',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ================= KATEGORI =================
                              const Text('Kategori (bisa pilih lebih dari 1)'),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _TagChip(
                                    label: 'SPL',
                                    value: 'SPL',
                                    group: c.kategori,
                                    onToggle: c.toggleKategori,
                                  ),
                                  _TagChip(
                                    label: 'Prakerja',
                                    value: 'Prakerja',
                                    group: c.kategori,
                                    onToggle: c.toggleKategori,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // ================= THUMBNAIL =================
                              const Text('URL Thumbnail (opsional)'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: c.thumbC,
                                decoration: const InputDecoration(
                                  hintText:
                                      'https://contoh.com/gambar-thumbnail.png',
                                  border: OutlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ================= STATUS =================
                              const Text('Status Kelas'),
                              const SizedBox(height: 6),
                              Obx(
                                () => DropdownButtonFormField<String>(
                                  value: c.status.value,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'draft',
                                      child: Text('Draft'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'published',
                                      child: Text('Published'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'maintenance',
                                      child: Text('Maintenance'),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) c.status.value = v;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // ================= BUTTONS =================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Batal'),
                                  ),
                                  const SizedBox(width: 12),
                                  Obx(
                                    () => ElevatedButton(
                                      onPressed: c.isSubmitting.value
                                          ? null
                                          : c.submitUpdate,
                                      child: c.isSubmitting.value
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                      Colors.white,
                                                    ),
                                              ),
                                            )
                                          : const Text('Simpan Perubahan'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final String value;
  final RxList<String> group;
  final void Function(String value) onToggle;

  const _TagChip({
    required this.label,
    required this.value,
    required this.group,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = group.contains(value);
      return FilterChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) => onToggle(value),
      );
    });
  }
}
