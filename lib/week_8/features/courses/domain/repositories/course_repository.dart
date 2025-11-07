import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<Course> createCourse({
    required String title,
    required int price,
    required String category,
  });
  Future<Course> updateCourse({
    required String id,
    required String title,
    required int price,
    required String category,
  });
  Future<void> deleteCourse(String id);
}
