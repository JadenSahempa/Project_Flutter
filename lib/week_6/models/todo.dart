class Todo {
  final String id; // uuid (string)
  final String text; // isi todo
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Todo({
    required this.id,
    required this.text,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
  });

  Todo copyWith({String? text, bool? completed, DateTime? updatedAt}) => Todo(
    id: id,
    text: text ?? this.text,
    completed: completed ?? this.completed,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Todo.fromJson(Map<String, dynamic> j) => Todo(
    id: j['id'] as String,
    text: j['text'] as String,
    completed: j['completed'] as bool,
    createdAt: DateTime.parse(j['createdAt'] as String),
    updatedAt: DateTime.parse(j['updatedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'completed': completed,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
