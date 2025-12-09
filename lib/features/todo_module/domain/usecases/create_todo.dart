import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class CreateTodo {
  final TodoRepository repo;
  CreateTodo(this.repo);

  Future<TodoEntity> call({
    required String title,
    required String description,
    DateTime? reminderAt,
  }) {
    return repo.createTodo(
      title: title,
      description: description,
      reminderAt: reminderAt,
    );
  }
}
