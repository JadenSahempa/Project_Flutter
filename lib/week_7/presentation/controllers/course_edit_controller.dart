import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luar_sekolah_lms/week_7/services/course_api_service.dart';
import 'package:luar_sekolah_lms/week_7/models/course.dart';
import 'package:luar_sekolah_lms/week_7/presentation/controllers/course_controller.dart';

class CourseEditController extends GetxController {
  final String courseId;
  CourseEditController({required this.courseId});

  final formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final ratingC = TextEditingController();
  final thumbC = TextEditingController();
  final kategori = RxList<String>();

  final loading = false.obs;
  final error = RxnString();

  late final CourseApiService api;
  CourseController? listCtrl;
  Course? initial;

  @override
  void onInit() {
    super.onInit();
    api = Get.find<CourseApiService>();
    if (Get.isRegistered<CourseController>(tag: 'popular')) {
      listCtrl = Get.find<CourseController>(tag: 'popular');
    }
    fetch();
  }

  Future<void> fetch() async {
    try {
      loading.value = true;
      error.value = null;
      final c = await api.getById(courseId);
      initial = c;

      namaC.text = c.name;
      hargaC.text = c.price;
      ratingC.text = c.rating ?? '';
      thumbC.text = c.thumbnail ?? '';
      kategori.assignAll(c.categoryTag);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final parsed =
        double.tryParse(hargaC.text.trim()) ??
        double.tryParse(initial?.price ?? '0') ??
        0;
    final priceStr = parsed.toStringAsFixed(2);

    final tags = kategori
        .map((e) => e.toLowerCase().trim())
        .where((e) => e.isNotEmpty)
        .toList();

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final updated = await api.updateCourse(
        id: courseId.trim(),
        name: namaC.text.trim(),
        categoryTag: tags,
        price: priceStr,
        rating: (ratingC.text.trim().isEmpty) ? null : ratingC.text.trim(),
        thumbnail: (thumbC.text.trim().isEmpty) ? null : thumbC.text.trim(),
      );

      await listCtrl?.reload();
      Get.back();
      Get.back(result: updated);
      Get.snackbar(
        'Berhasil',
        'Course berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
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
