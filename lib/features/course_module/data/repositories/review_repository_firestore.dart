import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewRepositoryFirestore implements ReviewRepository {
  final FirebaseFirestore firestore;

  ReviewRepositoryFirestore(this.firestore);

  DocumentReference<Map<String, dynamic>> _doc({
    required String courseId,
    required String userId,
  }) {
    return firestore
        .collection('courses')
        .doc(courseId)
        .collection('reviews')
        .doc(userId); // 1 user = 1 review
  }

  CollectionReference<Map<String, dynamic>> _col(String courseId) {
    return firestore.collection('courses').doc(courseId).collection('reviews');
  }

  DocumentReference<Map<String, dynamic>> _courseDoc(String courseId) {
    return firestore.collection('courses').doc(courseId);
  }

  // 🔥 PRIVATE: hitung ulang rata-rata rating + reviewCount
  Future<void> _recalculateCourseRating(String courseId) async {
    final snap = await _col(courseId).get();

    if (snap.docs.isEmpty) {
      // Kalau belum ada review sama sekali
      await _courseDoc(courseId).update({'rating': null, 'reviewCount': 0});
      return;
    }

    double total = 0;
    for (final doc in snap.docs) {
      final data = doc.data();
      final r = (data['rating'] as num?)?.toDouble() ?? 0.0;
      total += r;
    }

    final count = snap.docs.length;
    final avg = total / count;

    await _courseDoc(courseId).update({
      'rating': avg, // disimpan sebagai double (boleh)
      'reviewCount': count, // jumlah ulasan
    });
  }

  @override
  Future<List<ReviewEntity>> getReviews(String courseId) async {
    final snap = await _col(
      courseId,
    ).orderBy('createdAt', descending: true).get();

    return snap.docs.map((doc) {
      final data = doc.data();
      return ReviewEntity(
        id: doc.id,
        courseId: courseId,
        userId: data['userId'] as String? ?? doc.id,
        userName: data['userName'] as String? ?? '',
        rating: (data['rating'] as num?)?.toInt() ?? 0,
        comment: data['comment'] as String? ?? '',
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt:
            (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }

  @override
  Future<ReviewEntity?> getUserReview({
    required String courseId,
    required String userId,
  }) async {
    final ref = _doc(courseId: courseId, userId: userId);
    final snap = await ref.get();
    if (!snap.exists) return null;

    final data = snap.data()!;
    return ReviewEntity(
      id: snap.id,
      courseId: courseId,
      userId: data['userId'] as String? ?? userId,
      userName: data['userName'] as String? ?? '',
      rating: (data['rating'] as num?)?.toInt() ?? 0,
      comment: data['comment'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  Future<void> upsertReview({
    required String courseId,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    final ref = _doc(courseId: courseId, userId: userId);

    await ref.set({
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // ⬅️ setelah review disimpan, hitung ulang rating agregat
    await _recalculateCourseRating(courseId);
  }

  @override
  Future<void> deleteReview({
    required String courseId,
    required String userId,
  }) async {
    final ref = _doc(courseId: courseId, userId: userId);
    await ref.delete();

    // ⬅️ setelah review dihapus, hitung ulang lagi
    await _recalculateCourseRating(courseId);
  }
}
