// lib/week_6/services/todo_api_service_http.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

const String _baseUrl = 'https://ls-lms.zoidify.my.id/';

const String _token = 'default-token';

class TodoApiServiceHttp {
  final http.Client _c;
  TodoApiServiceHttp({http.Client? client}) : _c = client ?? http.Client();

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Uri _u(String path, [Map<String, dynamic>? query]) =>
      Uri.parse(_baseUrl).replace(
        path: path,
        queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
      );

  void _ensureOK(http.Response r) {
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('HTTP ${r.statusCode}: ${r.body}');
    }
  }

  // LIST (pagination + optional filter)
  Future<List<Todo>> fetchTodos({
    int limit = 20,
    int offset = 0,
    bool? completed,
  }) async {
    final res = await _c
        .get(
          _u('/api/todos', {
            'limit': limit,
            'offset': offset,
            if (completed != null) 'completed': completed,
          }),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 15));
    _ensureOK(res);
    final j = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (j['todos'] as List).cast<Map<String, dynamic>>();
    return list.map(Todo.fromJson).toList();
  }

  // GET by ID
  Future<Todo> getTodo(String id) async {
    final res = await _c
        .get(_u('/api/todos/$id'), headers: _headers)
        .timeout(const Duration(seconds: 15));
    _ensureOK(res);
    return Todo.fromJson(jsonDecode(res.body));
  }

  // CREATE
  Future<Todo> createTodo({
    required String text,
    bool completed = false,
  }) async {
    final res = await _c
        .post(
          _u('/api/todos'),
          headers: _headers,
          body: jsonEncode({'text': text, 'completed': completed}),
        )
        .timeout(const Duration(seconds: 15));
    _ensureOK(res);
    return Todo.fromJson(jsonDecode(res.body));
  }

  // UPDATE (PUT – partial fields allowed)
  Future<Todo> updateTodo(String id, {String? text, bool? completed}) async {
    final body = <String, dynamic>{};
    if (text != null) body['text'] = text;
    if (completed != null) body['completed'] = completed;

    final res = await _c
        .put(_u('/api/todos/$id'), headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 15));
    _ensureOK(res);
    return Todo.fromJson(jsonDecode(res.body));
  }

  // DELETE
  Future<void> deleteTodo(String id) async {
    final res = await _c
        .delete(_u('/api/todos/$id'), headers: _headers, body: jsonEncode({}))
        .timeout(const Duration(seconds: 15));
    _ensureOK(res);
  }

  // TOGGLE
  Future<Todo> toggleTodo(String id) async {
    final res = await _c
        .patch(
          _u('/api/todos/$id/toggle'),
          headers: _headers,
          body: jsonEncode({}),
        )
        .timeout(const Duration(seconds: 15));
    _ensureOK(res);
    return Todo.fromJson(jsonDecode(res.body));
  }
}
