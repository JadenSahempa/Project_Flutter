import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todo_controller.dart';
import '../widgets/todo_form_dialog.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  late final ScrollController _scroll;
  late final TodoController c;

  @override
  void initState() {
    super.initState();
    c = Get.find<TodoController>();
    _scroll = ScrollController();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      c.loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _openCreateDialog() async {
    final result = await showDialog<TodoFormResult>(
      context: context,
      builder: (_) => const TodoFormDialog(),
    );

    if (result == null) return;

    await c.create(
      title: result.title,
      description: result.description,
      reminderAt: result.reminderAt,
    );
  }

  Future<void> _openEditDialog(todo) async {
    final result = await showDialog<TodoFormResult>(
      context: context,
      builder: (_) => TodoFormDialog(
        titleText: "Edit To-Do",
        initialTitle: todo.title,
        initialDescription: todo.description,
        initialReminderAt: todo.reminderAt,
      ),
    );

    if (result == null) return;

    await c.updateWithReminder(
      todo,
      title: result.title,
      description: result.description,
      reminderAt: result.reminderAt,
    );
  }

  Future<void> _deleteTodo(todo) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus To-Do'),
        content: Text('Anda yakin ingin menghapus "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await c.remove(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List Belajar')),

      body: Obx(() {
        if (c.isLoading.value && c.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.error.value != null && c.items.isEmpty) {
          return Center(
            child: Text(
              c.error.value!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (c.items.isEmpty) {
          return const Center(child: Text('Belum ada To-Do.'));
        }

        return ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.all(12),
          itemCount: c.items.length + (c.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= c.items.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final todo = c.items[index];

            return Card(
              child: ListTile(
                leading: IconButton(
                  icon: Icon(
                    todo.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: todo.completed ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => c.toggle(todo),
                ),

                title: Text(
                  todo.title,
                  style: todo.completed
                      ? const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        )
                      : null,
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (todo.description.isNotEmpty) Text(todo.description),

                    if (todo.reminderAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.alarm, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              todo.reminderAt.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                onTap: () => _openEditDialog(todo),

                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteTodo(todo),
                ),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
