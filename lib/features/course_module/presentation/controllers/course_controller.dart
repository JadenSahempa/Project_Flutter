import 'package:get/get.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/get_popular_courses.dart';
import '../../domain/usecases/delete_course.dart';
import 'package:luar_sekolah_lms/services/local_notifications_service.dart';

import 'pagination_controller.dart';

class CourseController extends GetxController {
  final GetPopularCoursesUseCase getPopularCourses;
  final DeleteCourseUseCase deleteCourseUseCase;
  final List<String> defaultTags;

  CourseController({
    required this.getPopularCourses,
    required this.deleteCourseUseCase,
    this.defaultTags = const ['prakerja', 'spl'],
  });

  /// Pagination controller untuk CourseEntity
  late final PaginationController<CourseEntity> paging;

  @override
  void onInit() {
    super.onInit();

    // Inisialisasi pagination
    paging = PaginationController<CourseEntity>(
      pageSize: 20,
      fetchPage: (page, pageSize) async {
        // page dimulai dari 0
        final offset = page * pageSize;

        final coursePage = await getPopularCourses(
          limit: pageSize,
          offset: offset,
          categoryTag: defaultTags,
        );

        return coursePage.courses;
      },
    );

    // Load pertama kali
    paging.loadFirstPage();
  }

  Future<void> reload() => paging.loadFirstPage();

  Future<void> loadMore() => paging.loadNextPage();

  Future<void> deleteCourse(String id) async {
    try {
      await deleteCourseUseCase(id);

      await LocalNotificationsService.showNotification(
        title: 'Course Dihapus',
        body: 'Course berhasil dihapus.',
      );

      // Setelah delete, reload dari page pertama
      await paging.loadFirstPage();
    } catch (e) {
      rethrow;
    }
  }
}
