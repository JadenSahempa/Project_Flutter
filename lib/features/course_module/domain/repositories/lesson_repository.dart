import '../entities/lesson_entity.dart';

abstract class LessonRepository {
  /// Ambil semua materi untuk 1 course, diurutkan berdasarkan [order].
  Future<List<LessonEntity>> getLessons(String courseId);

  /// Tambah materi baru.
  ///
  /// - [courseId] = id course induk
  /// - [title]    = judul materi
  /// - [content]  = isi materi (sementara text dulu)
  ///
  /// Order akan dihitung otomatis (last + 1).
  Future<LessonEntity> createLesson({
    required String courseId,
    required String title,
    required String content,
    required int order,
  });

  /// Update materi (judul & isi).
  Future<LessonEntity> updateLesson({
    required String courseId,
    required String id,
    required String title,
    required String content,
    required int order,
  });

  /// Hapus materi.
  Future<void> deleteLesson({required String courseId, required String id});
}
