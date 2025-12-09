// import '../../domain/entities/course_entity.dart';
// import '../../domain/repositories/course_repository.dart';
// import '../datasources/course_remote_data_source.dart';

// class CourseRepositoryImpl implements CourseRepository {
//   final CourseRemoteDataSource remote;

//   CourseRepositoryImpl({required this.remote});

//   @override
//   Future<CoursePage> getCourses({
//     required int limit,
//     required int offset,
//     List<String>? categoryTag,
//   }) async {
//     // Di sini bisa tambahin caching, mapping, dsb kalau suatu saat perlu
//     return remote.getCourses(
//       limit: limit,
//       offset: offset,
//       categoryTag: categoryTag,
//     );
//   }

//   @override
//   Future<CourseEntity> createCourse({
//     required String name,
//     required List<String> categoryTag,
//     String price = '0.00',
//     String? rating,
//     String? thumbnail,
//   }) async {
//     final model = await remote.createCourse(
//       name: name,
//       categoryTag: categoryTag,
//       price: price,
//       rating: rating,
//       thumbnail: thumbnail,
//     );
//     return model;
//   }

//   @override
//   Future<CourseEntity> getCourseById(String id) async {
//     final model = await remote.getCourseById(id);
//     return model;
//   }

//   @override
//   Future<CourseEntity> updateCourse({
//     required String id,
//     required String name,
//     required List<String> categoryTag,
//     String price = '0.00',
//     String? rating,
//     String? thumbnail,
//   }) async {
//     final model = await remote.updateCourse(
//       id: id,
//       name: name,
//       categoryTag: categoryTag,
//       price: price,
//       rating: rating,
//       thumbnail: thumbnail,
//     );
//     return model;
//   }

//   @override
//   Future<void> deleteCourse(String id) {
//     return remote.deleteCourse(id);
//   }
// }
