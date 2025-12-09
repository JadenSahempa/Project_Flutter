import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_course_detail.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/update_course.dart';
import 'course_controller.dart';

class CourseEditController extends GetxController {
  final String courseId;
  final GetCourseDetailUseCase getCourseDetailUseCase;
  final UpdateCourseUseCase updateCourseUseCase;

  CourseEditController({
    required this.courseId,
    required this.getCourseDetailUseCase,
    required this.updateCourseUseCase,
  });

  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final ratingC = TextEditingController();
  final thumbC = TextEditingController();
  final deskripsiC = TextEditingController();

  final kategori = <String>[].obs;
  final status = 'draft'.obs;

  CourseEntity? currentCourse;

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    isLoading.value = true;
    try {
      final course = await getCourseDetailUseCase(courseId);
      currentCourse = course;

      namaC.text = course.name;
      hargaC.text = course.price;
      ratingC.text = course.rating ?? '';
      thumbC.text = course.thumbnail ?? '';
      deskripsiC.text = course.description ?? '';
      kategori.assignAll(course.categoryTag);
      status.value = course.status;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail course: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleKategori(String tag) {
    if (kategori.contains(tag)) {
      kategori.remove(tag);
    } else {
      kategori.add(tag);
    }
  }

  Future<void> submitUpdate() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isSubmitting.value = true;
    try {
      final hargaText = hargaC.text.trim();
      final price = hargaText.isEmpty ? null : hargaText;
      // final rating = ratingC.text.trim().isEmpty ? null : ratingC.text.trim();
      final thumb = thumbC.text.trim().isEmpty ? null : thumbC.text.trim();
      final desc = deskripsiC.text.trim().isEmpty
          ? null
          : deskripsiC.text.trim();

      await updateCourseUseCase(
        id: courseId,
        name: namaC.text.trim(),
        categoryTag: kategori.toList(),
        price: price,
        // rating: rating,
        thumbnail: thumb,
        description: desc,
        status: status.value,
      );

      final courseController = Get.find<CourseController>();
      await courseController.reload();

      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Gagal update course: $e');
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
    deskripsiC.dispose();
    super.onClose();
  }
}
