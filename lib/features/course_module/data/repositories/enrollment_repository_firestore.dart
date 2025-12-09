import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/enrollment_entity.dart';
import '../../domain/repositories/enrollment_repository.dart';

class EnrollmentRepositoryFirestore implements EnrollmentRepository {
  final FirebaseFirestore firestore;

  EnrollmentRepositoryFirestore(this.firestore);

  // Dokumen enrollment di subcollection user
  DocumentReference<Map<String, dynamic>> _doc({
    required String userId,
    required String courseId,
  }) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('enrollments')
        .doc(courseId);
  }

  // Dokumen course utama
  DocumentReference<Map<String, dynamic>> _courseDoc(String courseId) {
    return firestore.collection('courses').doc(courseId);
  }

  @override
  Future<void> enroll({
    required String userId,
    required String courseId,
  }) async {
    final now = DateTime.now();
    final enrollRef = _doc(userId: userId, courseId: courseId);
    final courseRef = _courseDoc(courseId);

    await firestore.runTransaction((tx) async {
      // ⬅️ 1x READ di awal
      final enrollSnap = await tx.get(enrollRef);

      // Kalau sudah pernah enroll, jangan double-count
      if (enrollSnap.exists) {
        return;
      }

      // ⬅️ Setelah itu BARU boleh write-write
      tx.set(enrollRef, {
        'courseId': courseId,
        'userId': userId,
        'enrolledAt': Timestamp.fromDate(now),
      }, SetOptions(merge: true));

      // Tidak perlu baca courseRef: langsung increment atomik
      tx.update(courseRef, {'enrollmentCount': FieldValue.increment(1)});
    });
  }

  @override
  Future<void> unenroll({
    required String userId,
    required String courseId,
  }) async {
    final enrollRef = _doc(userId: userId, courseId: courseId);
    final courseRef = _courseDoc(courseId);

    await firestore.runTransaction((tx) async {
      // ⬅️ 1x READ di awal
      final enrollSnap = await tx.get(enrollRef);

      // Kalau belum pernah enroll, nggak perlu apa-apa
      if (!enrollSnap.exists) {
        return;
      }

      // ⬅️ Setelah itu BARU write
      tx.delete(enrollRef);

      // Kurangi enrollmentCount (bisa jadi negatif kalau datanya berantakan,
      // tapi di flow normal harusnya aman)
      tx.update(courseRef, {'enrollmentCount': FieldValue.increment(-1)});
    });
  }

  @override
  Future<List<EnrollmentEntity>> getUserEnrollments(String userId) async {
    final snap = await firestore
        .collection('users')
        .doc(userId)
        .collection('enrollments')
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();

      return EnrollmentEntity(
        id: doc.id,
        courseId: data['courseId'] as String? ?? doc.id,
        userId: data['userId'] as String? ?? userId,
        enrolledAt:
            (data['enrolledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  @override
  Future<bool> isEnrolled({
    required String userId,
    required String courseId,
  }) async {
    final ref = _doc(userId: userId, courseId: courseId);
    final snap = await ref.get();
    return snap.exists;
  }
}
