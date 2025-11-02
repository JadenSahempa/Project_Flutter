import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  static const _defaultBaseUrl = 'https://ls-lms.zoidify.my.id';
  static const _defaultToken = 'default-token';

  final String baseUrl;
  final String token;

  CourseApiService({String? baseUrl, String? token})
    : baseUrl = baseUrl ?? _defaultBaseUrl,
      token = token ?? _defaultToken;

  Future<({List<Course> courses, int total, int limit, int offset})> fetch({
    required int limit,
    required int offset,
    List<String> categoryTag = const [],
  }) async {
    final qp = <String, String>{'limit': '$limit', 'offset': '$offset'};
    for (var i = 0; i < categoryTag.length; i++) {
      qp['categoryTag[$i]'] = categoryTag[i];
    }
    final uri = Uri.parse('$baseUrl/api/courses').replace(queryParameters: qp);
    final res = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final m = jsonDecode(res.body) as Map<String, dynamic>;
      final list = (m['courses'] as List)
          .map((e) => Course.fromJson(e))
          .toList();
      return (
        courses: list,
        total: (m['total'] as num).toInt(),
        limit: (m['limit'] as num).toInt(),
        offset: (m['offset'] as num).toInt(),
      );
    } else if (res.statusCode == 404) {
      throw Exception('Course not found (404)');
    } else if (res.statusCode == 500) {
      throw Exception('Course validation failed (500)');
    }
    throw Exception('Failed to load courses (${res.statusCode})');
  }

  Future<Course> create({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating, // nullable, pattern: ^\d(\.\d)?$
    String? thumbnail, // nullable, URL
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

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final m = jsonDecode(res.body) as Map<String, dynamic>;
      return Course.fromJson(m);
    } else if (res.statusCode == 404) {
      throw Exception('Course not found (404)');
    } else if (res.statusCode == 500) {
      throw Exception('Course validation failed (500)');
    }
    throw Exception('Failed to create course (${res.statusCode})');
  }

  Future<void> deleteCourse(String id) async {
    final uri = Uri.parse('$baseUrl/api/course/$id');
    final res = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({}),
    );

    if (res.statusCode == 200) {
      // opsional: cek payloadnya kalau mau
      // final m = jsonDecode(res.body) as Map<String, dynamic>;
      // final success = m['success'] == true;
      return;
    } else if (res.statusCode == 404) {
      throw Exception('Course not found (404)');
    } else if (res.statusCode == 500) {
      throw Exception('Course validation failed (500)');
    }
    throw Exception('Failed to delete course (${res.statusCode})');
  }

  Future<Course> getById(String id) async {
    final uri = Uri.parse('$baseUrl/api/course/$id');
    final res = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      return Course.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    } else if (res.statusCode == 404) {
      throw Exception('Course not found (404)');
    } else if (res.statusCode == 500) {
      throw Exception('Course validation failed (500)');
    }
    throw Exception('Failed to load course (${res.statusCode})');
  }

  Future<Course> updateCourse({
    required String id,
    String? name,
    List<String>? categoryTag,
    String? price, // "0.00"
    String? rating, // "4.5"
    String? thumbnail, // URL
  }) async {
    final uri = Uri.parse('$baseUrl/api/course/$id');

    final payload = <String, dynamic>{
      if (name != null) 'name': name,
      if (categoryTag != null) 'categoryTag': categoryTag,
      if (price != null) 'price': price,
      if (rating != null && rating.trim().isNotEmpty) 'rating': rating.trim(),
      if (thumbnail != null && thumbnail.trim().isNotEmpty)
        'thumbnail': thumbnail.trim(),
    };

    final res = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'data': payload}), // <-- WAJIB dibungkus "data"
    );

    if (res.statusCode == 200) {
      return Course.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    } else if (res.statusCode == 404) {
      throw Exception('Course not found (404)');
    } else if (res.statusCode == 500) {
      throw Exception('Course validation failed (500)');
    }
    throw Exception('Failed to update course (${res.statusCode}): ${res.body}');
  }
}
