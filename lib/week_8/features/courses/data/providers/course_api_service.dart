import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

class CourseApiService {
  final http.Client _c;
  final String baseUrl;
  final String token;
  CourseApiService({
    http.Client? client,
    required this.baseUrl,
    required this.token,
  }) : _c = client ?? http.Client();

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Uri _u(String path) =>
      Uri.parse('$baseUrl${path.startsWith('/') ? '' : '/'}$path');

  Future<List<CourseModel>> getCourses() async {
    final r = await _c.get(_u('/api/courses'), headers: _headers);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('GET /courses gagal: ${r.statusCode}');
    }
    final body = jsonDecode(r.body);
    final list = (body is List)
        ? body
        : (body['courses'] ?? body['data'] ?? []);
    return (list as List).map((e) => CourseModel.fromJson(e)).toList();
  }

  Future<CourseModel> getCourseById(String id) async {
    final r = await _c.get(_u('/api/course/$id'), headers: _headers);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('GET /courses/$id gagal: ${r.statusCode}\n${r.body}');
    }
    final m = jsonDecode(r.body) as Map<String, dynamic>;
    return CourseModel.fromJson(m);
  }

  Future<CourseModel> createCourse({
    required String title,
    required int price,
    required String category,
  }) async {
    final r = await _c.post(
      _u('/api/courses'),
      headers: _headers,
      body: jsonEncode({'title': title, 'price': price, 'category': category}),
    );
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('POST /courses gagal: ${r.statusCode}');
    }
    final body = jsonDecode(r.body);
    return CourseModel.fromJson(
      body is Map<String, dynamic> ? (body['course'] ?? body) : body,
    );
  }

  Future<CourseModel> updateCourse({
    required String id,
    required String title,
    required int price,
    required String category,
  }) async {
    final r = await _c.put(
      _u('/api/courses/$id'),
      headers: _headers,
      body: jsonEncode({'title': title, 'price': price, 'category': category}),
    );
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('PUT /courses/$id gagal: ${r.statusCode}');
    }
    final body = jsonDecode(r.body);
    return CourseModel.fromJson(
      body is Map<String, dynamic> ? (body['course'] ?? body) : body,
    );
  }

  Future<void> deleteCourse(String id) async {
    final r = await _c.delete(_u('/api/courses/$id'), headers: _headers);
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('DELETE /courses/$id gagal: ${r.statusCode}');
    }
  }
}
