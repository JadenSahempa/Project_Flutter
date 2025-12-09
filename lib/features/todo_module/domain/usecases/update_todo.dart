import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class UpdateTodo {
  final TodoRepository repo;
  UpdateTodo(this.repo);

  Future<TodoEntity> call(TodoEntity todo) {
    return repo.updateTodo(todo);
  }
}
