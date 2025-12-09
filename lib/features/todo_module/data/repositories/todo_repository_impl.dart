import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_remote_data_source.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remote;

  TodoRepositoryImpl(this.remote);

  @override
  Future<List<TodoEntity>> getTodos({
    int limit = 20,
    TodoEntity? lastItem,
    bool? completed,
  }) async {
    // Paging dengan lastItem belum dipakai di sini supaya simpel
    final list = await remote.getTodos(limit: limit, completed: completed);
    return list;
  }

  @override
  Future<TodoEntity> createTodo({
    required String title,
    required String description,
    DateTime? reminderAt,
  }) {
    return remote.createTodo(
      title: title,
      description: description,
      reminderAt: reminderAt,
    );
  }

  @override
  Future<void> deleteTodo(String id) => remote.deleteTodo(id);

  @override
  Future<TodoEntity> updateTodo(TodoEntity todo) {
    final model = TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      completed: todo.completed,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
      reminderAt: todo.reminderAt,
    );
    return remote.updateTodo(model);
  }

  @override
  Future<TodoEntity> toggleCompleted(String id) => remote.toggleCompleted(id);
}
