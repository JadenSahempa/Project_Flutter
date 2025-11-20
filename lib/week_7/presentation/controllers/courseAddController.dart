import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/usecases/create_course.dart';
import 'course_controller.dart';

class CourseAddController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final namaC = TextEditingController();
  final hargaC = TextEditingController();

  // 🔥 multi kategori
  final kategori = <String>[].obs; // contoh: ['prakerja', 'spl']

  // 🔥 field tambahan
  final ratingC = TextEditingController();
  final thumbC = TextEditingController();

  final isSubmitting = false.obs;

  late final CreateCourseUseCase createCourseUseCase;
  CourseController? listCtrl;

  @override
  void onInit() {
    super.onInit();

    createCourseUseCase = Get.find<CreateCourseUseCase>();

    if (Get.isRegistered<CourseController>(tag: 'popular')) {
      listCtrl = Get.find<CourseController>(tag: 'popular');
    }
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final hargaText = hargaC.text.trim();
    final hargaInt = int.tryParse(hargaText);
    if (hargaInt == null) {
      Get.snackbar('Validasi', 'Harga tidak valid');
      return;
    }

    if (kategori.isEmpty) {
      Get.snackbar('Validasi', 'Pilih minimal 1 kategori');
      return;
    }

    final priceStr = (hargaInt + .0).toStringAsFixed(2);

    final ratingText = ratingC.text.trim();
    final rating = ratingText.isEmpty ? null : ratingText;

    final thumbText = thumbC.text.trim();
    final thumbnail = thumbText.isEmpty ? null : thumbText;

    try {
      isSubmitting.value = true;

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await createCourseUseCase(
        name: namaC.text.trim(),
        categoryTag: kategori.toList(),
        price: priceStr,
        rating: rating,
        thumbnail: thumbnail,
      );

      await listCtrl?.reload();

      Get.back(); // tutup dialog loading
      Get.back(result: true); // kembali ke tab popular
    } catch (e) {
      Get.back(); // tutup dialog loading
      Get.snackbar('Gagal', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    namaC.dispose();
    hargaC.dispose();
    ratingC.dispose();
    thumbC.dispose();
    super.onClose();
  }
}
