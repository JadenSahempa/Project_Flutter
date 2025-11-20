import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/get_course_detail.dart';
import '../../domain/usecases/update_course.dart';
import 'course_controller.dart';

class CourseEditController extends GetxController {
  final String courseId;

  CourseEditController({required this.courseId});

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final ratingC = TextEditingController();
  final thumbC = TextEditingController();

  // 🔥 multi kategori juga
  final kategori = <String>[].obs; // contoh: ['prakerja', 'spl']

  late final GetCourseDetailUseCase _getDetail;
  late final UpdateCourseUseCase _updateCourse;
  CourseController? listCtrl;

  CourseEntity? course;

  @override
  void onInit() {
    super.onInit();

    _getDetail = Get.find<GetCourseDetailUseCase>();
    _updateCourse = Get.find<UpdateCourseUseCase>();

    if (Get.isRegistered<CourseController>(tag: 'popular')) {
      listCtrl = Get.find<CourseController>(tag: 'popular');
    }

    loadDetail();
  }

  Future<void> loadDetail() async {
    try {
      isLoading.value = true;

      final result = await _getDetail(courseId);
      course = result;

      namaC.text = result.name;

      if (result.price.endsWith('.00')) {
        hargaC.text = result.price.substring(0, result.price.length - 3);
      } else {
        hargaC.text = result.price;
      }

      ratingC.text = result.rating ?? '';
      thumbC.text = result.thumbnail ?? '';

      // 🔥 assign semua kategori dari backend
      kategori.assignAll(result.categoryTag.map((e) => e.toLowerCase()));
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
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
    final thumb = thumbText.isEmpty ? null : thumbText;

    try {
      isSubmitting.value = true;

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _updateCourse(
        id: courseId,
        name: namaC.text.trim(),
        categoryTag: kategori.toList(), // 🔥 kirim semua kategori
        price: priceStr,
        rating: rating,
        thumbnail: thumb,
      );

      await listCtrl?.reload();

      Get.back(); // tutup loading
      Get.back(result: true);
    } catch (e) {
      Get.back();
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
