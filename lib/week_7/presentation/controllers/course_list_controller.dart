import 'package:get/get.dart';
import '../../domain/entities/course.dart';
import '../../domain/usecases/get_courses.dart';

class CourseListController extends GetxController {
  final GetCourses getCourses;
  CourseListController({required this.getCourses});

  final items = <Course>[].obs;
  final loading = false.obs;
  final error = RxnString();
  final limit = 20.obs, offset = 0.obs;
  final hasMore = true.obs;
  final defaultTags = const ['prakerja', 'spl'];

  Future<void> reload() async {
    offset.value = 0;
    items.clear();
    hasMore.value = true;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (loading.value || !hasMore.value) return;
    loading.value = true;
    error.value = null;
    try {
      final r = await getCourses(
        limit: limit.value,
        offset: offset.value,
        categoryTag: defaultTags,
      );
      items.addAll(r.courses);
      offset.value = r.offset + r.limit;
      hasMore.value = r.courses.isNotEmpty;
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
}
