import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getTodos({
    int limit,
    TodoEntity? lastItem, // untuk paging sederhana
    bool? completed,
  });

  Future<TodoEntity> createTodo({
    required String title,
    required String description,
    DateTime? reminderAt,
  });

  Future<TodoEntity> updateTodo(TodoEntity todo);

  Future<void> deleteTodo(String id);

  Future<TodoEntity> toggleCompleted(String id);
}
