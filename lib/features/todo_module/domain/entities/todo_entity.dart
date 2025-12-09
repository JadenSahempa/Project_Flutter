class TodoEntity {
  final String id;
  final String title; // nama todo
  final String description; // deskripsi todo
  final bool completed;
  final DateTime? reminderAt; // tanggal + jam reminder (boleh null)
  final DateTime createdAt;
  final DateTime updatedAt;

  const TodoEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
    this.reminderAt,
  });

  TodoEntity copyWith({
    String? title,
    String? description,
    bool? completed,
    DateTime? reminderAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      reminderAt: reminderAt ?? this.reminderAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
