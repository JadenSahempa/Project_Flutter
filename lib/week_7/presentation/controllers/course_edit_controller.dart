// week_7/presentation/controllers/course_edit_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/get_course_by_id.dart';
import '../../domain/usecases/update_course.dart';

class CourseEditController extends GetxController {
  final String courseId;
  final GetCourseById getCourseById;
  final UpdateCourse updateCourse;

  CourseEditController({
    required this.courseId,
    required this.getCourseById,
    required this.updateCourse,
  });

  // ---- UI/Form state
  final formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final ratingC = TextEditingController();
  final thumbC = TextEditingController();
  final kategori = <String>[].obs;

  // ---- Loading & error agar match dengan screen
  final loading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetch(); // load data awal
  }

  // Dipanggil saat retry di screen
  Future<void> fetch() async {
    loading.value = true;
    error.value = null;
    try {
      final c = await getCourseById(courseId);
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
    if (!formKey.currentState!.validate()) return;
    final priceNum = double.tryParse(hargaC.text.trim()) ?? 0;
    final priceStr = priceNum.toStringAsFixed(2);

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await updateCourse(
        id: courseId,
        name: namaC.text.trim(),
        categoryTag: kategori.toList(),
        price: priceStr,
        rating: ratingC.text.trim().isEmpty ? null : ratingC.text.trim(),
        thumbnail: thumbC.text.trim().isEmpty ? null : thumbC.text.trim(),
      );
      Get.back(); // close dialog
      Get.back(result: true); // kembali dari halaman edit
    } catch (e) {
      Get.back();
      Get.snackbar('Gagal', e.toString());
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
