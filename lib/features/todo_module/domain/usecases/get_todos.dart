import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repo;
  GetTodos(this.repo);

  Future<List<TodoEntity>> call({
    int limit = 20,
    TodoEntity? lastItem,
    bool? completed,
  }) {
    return repo.getTodos(
      limit: limit,
      lastItem: lastItem,
      completed: completed,
    );
  }
}
