import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<({List<CourseModel> courses, int total, int limit, int offset})>
  fetch({required int limit, required int offset, List<String> categoryTag});

  Future<CourseModel> create({
    required String name,
    required List<String> categoryTag,
    String price,
    String? rating,
    String? thumbnail,
  });

  Future<CourseModel> getById(String id);
  Future<CourseModel> update({
    required String id,
    required String name,
    required List<String> categoryTag,
    required String price,
    String? rating,
    String? thumbnail,
  });
  Future<void> delete(String id);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final String baseUrl;
  final String token;
  final http.Client client;

  CourseRemoteDataSourceImpl({
    required this.baseUrl,
    required this.token,
    required this.client,
  });

  Map<String, String> get _headers => {'Authorization': 'Bearer $token'};

  @override
  Future<({List<CourseModel> courses, int total, int limit, int offset})>
  fetch({
    required int limit,
    required int offset,
    List<String> categoryTag = const [],
  }) async {
    final qp = <String, String>{'limit': '$limit', 'offset': '$offset'};
    for (var i = 0; i < categoryTag.length; i++) {
      qp['categoryTag[$i]'] = categoryTag[i];
    }
    final uri = Uri.parse('$baseUrl/api/courses').replace(queryParameters: qp);
    final res = await client.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch courses (${res.statusCode})');
    }
    final m = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (m['courses'] as List)
        .map((e) => CourseModel.fromJson(e))
        .toList();
    return (
      courses: list,
      total: (m['total'] as num).toInt(),
      limit: (m['limit'] as num).toInt(),
      offset: (m['offset'] as num).toInt(),
    );
  }

  @override
  Future<CourseModel> create({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  }) async {
    final uri = Uri.parse('$baseUrl/api/courses');
    final payload = {
      'name': name,
      'price': price, // harus string pattern "####.##"
      'categoryTag': categoryTag,
      if (rating != null && rating.isNotEmpty) 'rating': rating,
      if (thumbnail != null && thumbnail.isNotEmpty) 'thumbnail': thumbnail,
    };

    final headers = {
      ..._headers,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    print('[POST] $baseUrl/api/courses');
    print('Body: ${jsonEncode(payload)}'); // debug log

    final res = await client.post(
      Uri.parse('$baseUrl/api/courses'),
      headers: headers,
      body: jsonEncode(payload), // ✅ TANPA "data"
    );

    print('Response: ${res.statusCode} ${res.body}');

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
        'failed to create course(${res.statusCode}): ${res.body}',
      );
    }
    return CourseModel.fromJson(jsonDecode(res.body));
  }

  @override
  Future<void> delete(String id) async {
    final uri = Uri.parse('$baseUrl/api/course/$id');
    final res = await client.delete(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('Failed to delete course (${res.statusCode})');
    }
  }

  @override
  Future<CourseModel> getById(String id) async {
    final uri = Uri.parse('$baseUrl/api/course/$id');
    final res = await client.get(uri, headers: _headers);
    if (res.statusCode != 200) {
      throw Exception('Failed to get course (${res.statusCode})');
    }
    return CourseModel.fromJson(jsonDecode(res.body));
  }

  @override
  Future<CourseModel> update({
    required String id,
    required String name,
    required List<String> categoryTag,
    required String price,
    String? rating,
    String? thumbnail,
  }) async {
    final uri = Uri.parse('$baseUrl/api/course/$id');
    final payload = {
      'name': name,
      'price': price,
      'categoryTag': categoryTag,
      if (rating != null && rating.isNotEmpty) 'rating': rating,
      if (thumbnail != null && thumbnail.isNotEmpty) 'thumbnail': thumbnail,
    };
    final res = await client.put(
      uri,
      headers: {..._headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'data': payload}),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update course (${res.statusCode})');
    }
    return CourseModel.fromJson(jsonDecode(res.body));
  }
}
