import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../models/course_model.dart';
import '../providers/course_api_service.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseApiService api;
  CourseRepositoryImpl(this.api);

  @override
  Future<List<Course>> getCourses() async {
    final ms = await api.getCourses();
    return ms.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Course> createCourse({
    required String title,
    required int price,
    required String category,
  }) async {
    final m = await api.createCourse(
      title: title,
      price: price,
      category: category,
    );
    return m.toEntity();
  }

  @override
  Future<Course> getCourseById(String id) async =>
      (await api.getCourseById(id)).toEntity();

  @override
  Future<Course> updateCourse({
    required String id,
    required String title,
    required int price,
    required String category,
  }) async {
    final m = await api.updateCourse(
      id: id,
      title: title,
      price: price,
      category: category,
    );
    return m.toEntity();
  }

  @override
  Future<void> deleteCourse(String id) => api.deleteCourse(id);
}
