import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  const TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.completed,
    required super.createdAt,
    required super.updatedAt,
    super.reminderAt,
  });

  factory TodoModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TodoModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      completed: data['completed'] as bool? ?? false,
      reminderAt: data['reminderAt'] != null
          ? (data['reminderAt'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'reminderAt': reminderAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  TodoModel copyWith({
    String? title,
    String? description,
    bool? completed,
    DateTime? reminderAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoModel(
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
