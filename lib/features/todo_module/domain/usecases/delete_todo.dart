import '../repositories/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repo;
  DeleteTodo(this.repo);

  Future<void> call(String id) => repo.deleteTodo(id);
}
