import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../data/datasources/course_remote_data_source.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/usecases/get_popular_courses.dart';
import '../../domain/usecases/delete_course.dart';
import '../controllers/course_controller.dart';
import '../../domain/usecases/create_course.dart';
import '../../domain/usecases/get_course_detail.dart';
import '../../domain/usecases/update_course.dart';

class CourseBindings extends Bindings {
  final String baseUrl;
  final String token;

  CourseBindings({required this.baseUrl, required this.token});

  @override
  void dependencies() {
    // DataSource
    Get.lazyPut<CourseRemoteDataSource>(
      () => CourseRemoteDataSourceImpl(
        baseUrl: baseUrl,
        token: token,
        client: http.Client(),
      ),
    );

    // Repository
    Get.lazyPut<CourseRepository>(
      () => CourseRepositoryImpl(remote: Get.find()),
    );

    // UseCase
    Get.lazyPut<GetPopularCoursesUseCase>(
      () => GetPopularCoursesUseCase(Get.find()),
    );

    Get.lazyPut<CreateCourseUseCase>(
      () => CreateCourseUseCase(Get.find()),
      fenix: true,
    );

    Get.lazyPut<GetCourseDetailUseCase>(
      () => GetCourseDetailUseCase(Get.find()),
      fenix: true,
    );

    Get.lazyPut<UpdateCourseUseCase>(
      () => UpdateCourseUseCase(Get.find()),
      fenix: true,
    );

    Get.lazyPut<DeleteCourseUseCase>(() => DeleteCourseUseCase(Get.find()));

    // Controller
    Get.lazyPut<CourseController>(
      () => CourseController(
        getPopularCourses: Get.find(),
        deleteCourseUseCase: Get.find(),
      ),
      tag: 'popular',
    );
  }
}
