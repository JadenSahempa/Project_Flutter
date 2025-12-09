import 'package:get/get.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/create_todo.dart';
import '../../domain/usecases/update_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/toggle_todo_completed.dart';
import 'package:luar_sekolah_lms/services/local_notifications_service.dart';
// ^ sesuaikan path dengan project-mu ya

class TodoController extends GetxController {
  final GetTodos getTodos;
  final CreateTodo createTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;
  final ToggleTodoCompleted toggleTodoCompleted;

  TodoController({
    required this.getTodos,
    required this.createTodo,
    required this.updateTodo,
    required this.deleteTodo,
    required this.toggleTodoCompleted,
  });

  final items = <TodoEntity>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final hasMore = true.obs;
  final filterCompleted = RxnBool();

  static const int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    load(reset: true);
  }

  Future<void> load({bool reset = false}) async {
    if (isLoading.value) return;

    if (reset) {
      items.clear();
      hasMore.value = true;
      error.value = null;
    }

    if (!hasMore.value) return;

    try {
      isLoading.value = true;
      error.value = null;

      final page = await getTodos(
        limit: _limit,
        completed: filterCompleted.value,
      );

      if (page.isEmpty) {
        hasMore.value = false;
      } else {
        items.addAll(page);
        hasMore.value = page.length == _limit;
      }
    } catch (e) {
      error.value = 'Terjadi kesalahan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> create({
    required String title,
    required String description,
    DateTime? reminderAt,
  }) async {
    try {
      final todo = await createTodo(
        title: title,
        description: description,
        reminderAt: reminderAt,
      );
      items.insert(0, todo);

      if (reminderAt != null) {
        await LocalNotificationsService.scheduleTodoReminder(todo);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat todo: $e');
    }
  }

  Future<void> updateItem(TodoEntity todo) async {
    try {
      final updated = await updateTodo(todo);
      final idx = items.indexWhere((t) => t.id == todo.id);
      if (idx != -1) {
        items[idx] = updated;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal update todo: $e');
    }
  }

  Future<void> toggle(TodoEntity todo) async {
    final idx = items.indexWhere((t) => t.id == todo.id);
    if (idx == -1) return;

    final before = items[idx];
    items[idx] = before.copyWith(completed: !before.completed);

    try {
      final updated = await toggleTodoCompleted(todo.id);
      items[idx] = updated;
    } catch (e) {
      items[idx] = before;
      Get.snackbar('Error', 'Gagal toggle todo: $e');
    }
  }

  Future<void> remove(TodoEntity todo) async {
    final idx = items.indexWhere((t) => t.id == todo.id);
    if (idx == -1) return;
    final backup = items[idx];
    items.removeAt(idx);

    try {
      await deleteTodo(todo.id);
      await LocalNotificationsService.cancelTodoReminder(todo.id);
    } catch (e) {
      items.insert(idx, backup);
      Get.snackbar('Error', 'Gagal menghapus todo: $e');
    }
  }

  void setFilterCompleted(bool? completed) {
    filterCompleted.value = completed;
    load(reset: true);
  }

  Future<void> loadMore() => load(reset: false);

  Future<void> updateWithReminder(
    TodoEntity original, {
    required String title,
    required String description,
    DateTime? reminderAt,
  }) async {
    final idx = items.indexWhere((t) => t.id == original.id);
    if (idx == -1) return;

    final updated = original.copyWith(
      title: title,
      description: description,
      reminderAt: reminderAt,
      updatedAt: DateTime.now(),
    );

    // optimistik update di UI dulu
    final before = items[idx];
    items[idx] = updated;

    try {
      final saved = await updateTodo(updated);
      items[idx] = saved;

      // cancel reminder lama
      await LocalNotificationsService.cancelTodoReminder(original.id);

      // kalau ada reminder baru, schedule ulang
      if (saved.reminderAt != null) {
        await LocalNotificationsService.scheduleTodoReminder(saved);
      }
    } catch (e) {
      items[idx] = before;
      Get.snackbar('Error', 'Gagal mengupdate todo: $e');
    }
  }
}
