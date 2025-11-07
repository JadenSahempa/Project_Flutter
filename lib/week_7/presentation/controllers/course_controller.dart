import 'package:get/get.dart';
import 'package:luar_sekolah_lms/week_7/models/course.dart';
import 'package:luar_sekolah_lms/week_7/services/course_api_service.dart';

class CourseController extends GetxController {
  final CourseApiService api;
  final List<String> defaultTags;
  CourseController({
    required this.api,
    this.defaultTags = const ['prakerja', 'spl'],
  });

  final items = <Course>[].obs;
  final loading = false.obs;
  final error = RxnString();
  final limit = 20.obs, offset = 0.obs;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  Future<void> reload() async {
    items.clear();
    offset.value = 0;
    hasMore.value = true;
    await _loadPage();
  }

  Future<void> loadMore() async {
    if (loading.value || !hasMore.value) return;
    await _loadPage();
  }

  Future<void> _loadPage() async {
    try {
      loading.value = true;
      error.value = null;
      final resp = await api.fetch(
        limit: limit.value,
        offset: offset.value,
        categoryTag: defaultTags,
      );
      items.addAll(resp.courses);
      offset.value = resp.offset + resp.limit;
      hasMore.value = resp.courses.isNotEmpty;
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
}
