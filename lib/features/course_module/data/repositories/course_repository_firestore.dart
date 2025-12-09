import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';
import '../models/course_model.dart';

class CourseRepositoryFirestore implements CourseRepository {
  final FirebaseFirestore firestore;

  CourseRepositoryFirestore(this.firestore);

  CollectionReference<Map<String, dynamic>> get _col =>
      firestore.collection('courses');

  @override
  Future<List<CourseEntity>> getCourses() async {
    final snap = await _col.orderBy('createdAt', descending: true).get();
    return snap.docs.map((d) => CourseModel.fromDoc(d)).toList();
  }

  @override
  Future<CourseEntity> getCourseById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) {
      throw Exception('Course tidak ditemukan');
    }
    return CourseModel.fromDoc(doc);
  }

  @override
  Future<CourseEntity> createCourse({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
    String? description,
    String status = 'draft',
    required String createdBy,
  }) async {
    final now = DateTime.now();
    final model = CourseModel(
      id: '', // Firestore akan isi
      name: name,
      price: price,
      categoryTag: categoryTag,
      thumbnail: thumbnail,
      rating: rating,
      description: description ?? '',
      status: status,
      enrollmentCount: 0,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
    );

    final ref = await _col.add(model.toMap());
    final createdDoc = await ref.get();
    return CourseModel.fromDoc(createdDoc);
  }

  @override
  Future<CourseEntity> updateCourse({
    required String id,
    required String name,
    required List<String> categoryTag,
    String? price,
    String? rating,
    String? thumbnail,
    String? description,
    String? status,
  }) async {
    final now = DateTime.now();
    final updates = <String, dynamic>{
      'name': name,
      'categoryTag': categoryTag,
      'updatedAt': Timestamp.fromDate(now),
      if (price != null) 'price': price,
      if (rating != null) 'rating': rating,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
    };

    await _col.doc(id).update(updates);
    final newDoc = await _col.doc(id).get();
    return CourseModel.fromDoc(newDoc);
  }

  @override
  Future<void> deleteCourse(String id) {
    return _col.doc(id).delete();
  }
}
