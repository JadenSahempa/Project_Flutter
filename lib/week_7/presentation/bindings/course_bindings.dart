import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../data/datasources/course_remote_data_source.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/usecases/get_courses.dart';
import '../../domain/usecases/get_course_by_id.dart';
import '../../domain/usecases/create_course.dart';
import '../../domain/usecases/update_course.dart';
import '../../domain/usecases/delete_course.dart';
import '../controllers/course_list_controller.dart';

class CourseBindings extends Bindings {
  final String baseUrl;
  final String token;
  CourseBindings({required this.baseUrl, required this.token});

  @override
  void dependencies() {
    // Data source & repo
    Get.lazyPut<CourseRemoteDataSource>(
      () => CourseRemoteDataSourceImpl(
        baseUrl: baseUrl,
        token: token,
        client: http.Client(),
      ),
      fenix: true,
    );
    Get.lazyPut<CourseRepository>(
      () => CourseRepositoryImpl(Get.find()),
      fenix: true,
    );

    // Use cases
    Get.lazyPut(() => GetCourses(Get.find()), fenix: true);
    Get.lazyPut(() => GetCourseById(Get.find()), fenix: true);
    Get.lazyPut(() => CreateCourse(Get.find()), fenix: true);
    Get.lazyPut(() => UpdateCourse(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteCourse(Get.find()), fenix: true);

    // Controller list — biar tetap ada sepanjang sesi (tab “Kelas”)
    Get.put(CourseListController(getCourses: Get.find()), permanent: true);
  }
}
