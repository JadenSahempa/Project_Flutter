import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/todo_model.dart';

class TodoRemoteDataSource {
  final FirebaseFirestore _firestore;

  TodoRemoteDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _col {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception('User belum login. Tidak bisa memuat todo.');
    }

    return _firestore.collection('users').doc(uid).collection('todos');
  }

  Future<List<TodoModel>> getTodos({
    int limit = 20,
    DocumentSnapshot? startAfter,
    bool? completed,
  }) async {
    Query<Map<String, dynamic>> q = _col
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (completed != null) {
      q = q.where('completed', isEqualTo: completed);
    }

    if (startAfter != null) {
      q = q.startAfterDocument(startAfter);
    }

    final snap = await q.get();
    return snap.docs.map(TodoModel.fromFirestore).toList();
  }

  Future<TodoModel> createTodo({
    required String title,
    required String description,
    DateTime? reminderAt,
  }) async {
    final now = DateTime.now();
    final docRef = await _col.add({
      'title': title,
      'description': description,
      'completed': false,
      'reminderAt': reminderAt,
      'createdAt': now,
      'updatedAt': now,
    });

    final doc = await docRef.get();
    return TodoModel.fromFirestore(doc);
  }

  Future<TodoModel> updateTodo(TodoModel todo) async {
    final data = todo.toFirestore()..['updatedAt'] = DateTime.now();
    await _col.doc(todo.id).update(data);
    final doc = await _col.doc(todo.id).get();
    return TodoModel.fromFirestore(doc);
  }

  Future<void> deleteTodo(String id) async {
    await _col.doc(id).delete();
  }

  Future<TodoModel> toggleCompleted(String id) async {
    final ref = _col.doc(id);
    return _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final cur = TodoModel.fromFirestore(snap);
      final updated = cur.copyWith(
        completed: !cur.completed,
        updatedAt: DateTime.now(),
      );
      tx.update(ref, updated.toFirestore());
      return updated;
    });
  }
}
