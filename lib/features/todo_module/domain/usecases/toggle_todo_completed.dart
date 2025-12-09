import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class ToggleTodoCompleted {
  final TodoRepository repo;
  ToggleTodoCompleted(this.repo);

  Future<TodoEntity> call(String id) => repo.toggleCompleted(id);
}
