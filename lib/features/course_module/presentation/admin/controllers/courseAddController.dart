import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/usecases/create_course.dart';
import 'course_controller.dart';

class CourseAddController extends GetxController {
  final CreateCourseUseCase createCourseUseCase;

  CourseAddController({required this.createCourseUseCase});

  /// Form key
  final formKey = GlobalKey<FormState>();

  /// Field input
  final namaC = TextEditingController();
  final deskripsiC = TextEditingController();
  final hargaC = TextEditingController(
    text: '0.00',
  ); // untuk sekarang selalu gratis
  final thumbC = TextEditingController();

  /// Tipe kelas: SPL / Prakerja (bisa dua-duanya)
  final isSpl = false.obs;
  final isPrakerja = false.obs;

  /// Status kelas: draft / published / maintenance
  final status = 'draft'.obs;

  /// Loading state submit
  final isSubmitting = false.obs;

  /// Submit form: dipanggil dari tombol "Simpan"
  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final tags = <String>[];
    if (isSpl.value) tags.add('SPL');
    if (isPrakerja.value) tags.add('Prakerja');

    if (tags.isEmpty) {
      Get.snackbar(
        'Tipe kelas belum dipilih',
        'Pilih minimal salah satu: SPL atau Prakerja',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar(
        'Tidak ada user',
        'Silakan login ulang sebagai admin.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      await createCourseUseCase(
        name: namaC.text.trim(),
        categoryTag: tags,
        price: (hargaC.text.trim().isEmpty) ? '0.00' : hargaC.text.trim(),
        // 🔹 rating tidak diinput admin → biarkan null
        rating: null,
        thumbnail: thumbC.text.trim().isEmpty ? null : thumbC.text.trim(),
        description: deskripsiC.text.trim().isEmpty
            ? null
            : deskripsiC.text.trim(),
        status: status.value, // draft / published / maintenance
        createdBy: user.uid,
      );

      // Refresh list di CourseController admin
      if (Get.isRegistered<CourseController>()) {
        await Get.find<CourseController>().reload();
      }

      Get.back(); // kembali ke list
      Get.snackbar(
        'Berhasil',
        'Kelas berhasil dibuat.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal membuat kelas: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    namaC.dispose();
    deskripsiC.dispose();
    hargaC.dispose();
    thumbC.dispose();
    super.onClose();
  }
}
