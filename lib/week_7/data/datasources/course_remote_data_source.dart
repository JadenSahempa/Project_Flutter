import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/course_model.dart';
import '../../domain/repositories/course_repository.dart';

abstract class CourseRemoteDataSource {
  Future<CoursePage> getCourses({
    required int limit,
    required int offset,
    List<String>? categoryTag,
  });

  Future<CourseModel> createCourse({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  });

  Future<CourseModel> getCourseById(String id);
  Future<CourseModel> updateCourse({
    required String id,
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  });

  Future<void> deleteCourse(String id);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final String baseUrl;
  final String token;
  final http.Client client;

  CourseRemoteDataSourceImpl({
    required this.baseUrl,
    required this.token,
    http.Client? client,
  }) : client = client ?? http.Client();

  // Data Source Impl GET COURSES
  @override
  Future<CoursePage> getCourses({
    required int limit,
    required int offset,
    List<String>? categoryTag,
  }) async {
    final uri = Uri.parse('$baseUrl/api/courses').replace(
      queryParameters: {
        'limit': '$limit',
        'offset': '$offset',
        if (categoryTag != null)
          for (var i = 0; i < categoryTag.length; i++)
            'categoryTag[$i]': categoryTag[i],
      },
    );

    final res = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal memuat courses (${res.statusCode})');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    // Sesuai JSON backend kamu
    final coursesJson = body['courses'] as List? ?? [];

    final courses = coursesJson
        .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final respLimit = body['limit'] as int? ?? limit;
    final respOffset = body['offset'] as int? ?? offset;

    return CoursePage(courses: courses, limit: respLimit, offset: respOffset);
  }

  // impl Data Source CREATE COURSE
  @override
  Future<CourseModel> createCourse({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  }) async {
    final uri = Uri.parse('$baseUrl/api/courses');

    final body = <String, dynamic>{
      'name': name,
      'price': price,
      'categoryTag': categoryTag,
      if (thumbnail != null && thumbnail.trim().isNotEmpty)
        'thumbnail': thumbnail,
      if (rating != null && rating.trim().isNotEmpty) 'rating': rating,
    };

    final res = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final m = jsonDecode(res.body) as Map<String, dynamic>;
      return CourseModel.fromJson(m);
    } else if (res.statusCode == 404) {
      throw Exception('Course not found (404)');
    } else if (res.statusCode == 500) {
      throw Exception('Course validation failed (500)');
    }
    throw Exception('Failed to create course (${res.statusCode})');
  }

  // impl Data Source EDIT COURSE
  @override
  Future<CourseModel> getCourseById(String id) async {
    final uri = Uri.parse('$baseUrl/api/course/$id');

    final res = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail course (${res.statusCode})');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return CourseModel.fromJson(body);
  }

  // impl Data Source EDIT UPDATE COURSE
  @override
  Future<CourseModel> updateCourse({
    required String id,
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  }) async {
    final uri = Uri.parse('$baseUrl/api/course/$id');

    // Payload inti, sesuai field yang didukung API
    final payload = <String, dynamic>{
      'name': name,
      'price': price,
      'categoryTag': categoryTag,
      if (thumbnail != null && thumbnail.trim().isNotEmpty)
        'thumbnail': thumbnail.trim(),
      if (rating != null && rating.trim().isNotEmpty) 'rating': rating.trim(),
    };

    final res = await client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      // 💥 WAJIB dibungkus dalam "data"
      body: jsonEncode({'data': payload}),
    );

    if (res.statusCode != 200) {
      // sementara tulis ke log biar bisa cek pesan error backend
      // ignore: avoid_print
      print('Update course error ${res.statusCode}: ${res.body}');
      throw Exception('Gagal update course (${res.statusCode})');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    return CourseModel.fromJson(body);
  }

  // impl Data Source DELETE COURSE
  @override
  Future<void> deleteCourse(String id) async {
    final uri = Uri.parse('$baseUrl/api/course/$id');

    final res = await client.delete(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      // Bisa disesuaikan dengan respon backend kamu
      throw Exception('Gagal menghapus course (${res.statusCode})');
    }
  }
}
