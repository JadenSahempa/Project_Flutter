import '../entities/course_entity.dart';

class CoursePage {
  final List<CourseEntity> courses;
  final int limit;
  final int offset;

  const CoursePage({
    required this.courses,
    required this.limit,
    required this.offset,
  });
}

abstract class CourseRepository {
  Future<CoursePage> getCourses({
    required int limit,
    required int offset,
    List<String>? categoryTag,
  });

  Future<CourseEntity> createCourse({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  });

  Future<CourseEntity> getCourseById(String id);

  Future<CourseEntity> updateCourse({
    required String id,
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  });

  Future<void> deleteCourse(String id);
}
