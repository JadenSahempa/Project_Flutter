import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../data/datasources/todo_remote_data_source.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/create_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo_completed.dart';
import '../../domain/usecases/update_todo.dart';
import '../controllers/todo_controller.dart';

class TodoBindings extends Bindings {
  @override
  void dependencies() {
    // 1. DataSource (Firestore)
    Get.lazyPut(() => TodoRemoteDataSource(FirebaseFirestore.instance));

    // 2. Repository — REGISTER SEBAGAI TIPE TodoRepository
    Get.lazyPut<TodoRepository>(
      () => TodoRepositoryImpl(Get.find<TodoRemoteDataSource>()),
    );

    // 3. UseCases
    Get.lazyPut(() => GetTodos(Get.find<TodoRepository>()));
    Get.lazyPut(() => CreateTodo(Get.find<TodoRepository>()));
    Get.lazyPut(() => UpdateTodo(Get.find<TodoRepository>()));
    Get.lazyPut(() => DeleteTodo(Get.find<TodoRepository>()));
    Get.lazyPut(() => ToggleTodoCompleted(Get.find<TodoRepository>()));

    // 4. Controller
    Get.lazyPut(
      () => TodoController(
        getTodos: Get.find<GetTodos>(),
        createTodo: Get.find<CreateTodo>(),
        updateTodo: Get.find<UpdateTodo>(),
        deleteTodo: Get.find<DeleteTodo>(),
        toggleTodoCompleted: Get.find<ToggleTodoCompleted>(),
      ),
    );
  }
}
