import 'package:get/get.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/get_popular_courses.dart';
import '../../domain/usecases/delete_course.dart';
import 'package:luar_sekolah_lms/services/local_notifications_service.dart';

class CourseController extends GetxController {
  final GetPopularCoursesUseCase getPopularCourses;
  final DeleteCourseUseCase deleteCourseUseCase;
  final List<String> defaultTags;

  CourseController({
    required this.getPopularCourses,
    required this.deleteCourseUseCase,
    this.defaultTags = const ['prakerja', 'spl'],
  });

  final items = <CourseEntity>[].obs;
  final loading = false.obs;
  final error = RxnString();
  final limit = 20.obs;
  final offset = 0.obs;
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

      final page = await getPopularCourses(
        limit: limit.value,
        offset: offset.value,
        categoryTag: defaultTags,
      );

      items.addAll(page.courses);
      offset.value = page.offset + page.limit;
      hasMore.value = page.courses.isNotEmpty;
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      loading.value = true;
      error.value = null;

      await deleteCourseUseCase(id);

      await LocalNotificationsService.showNotification(
        title: 'Course Dihapus',
        body: 'Course berhasil dihapus.',
      );

      await reload();
    } catch (e) {
      error.value = e.toString();
      rethrow;
    } finally {
      loading.value = false;
    }
  }
}
