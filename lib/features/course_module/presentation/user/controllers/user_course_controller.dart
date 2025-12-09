import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luar_sekolah_lms/services/local_notifications_service.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/entities/lesson_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_progress_entity.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_courses.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_lessons.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_course_progress.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/toggle_lesson_completed.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/usecases/enroll_in_course.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_user_enrollments.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/unenroll_from_course.dart';

import 'package:luar_sekolah_lms/features/mycourse_module/presentation/controllers/my_courses_controller.dart';

// Review / Rating + Komentar
import 'package:luar_sekolah_lms/features/course_module/domain/entities/review_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_reviews.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_user_review.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/upsert_review.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/delete_review.dart';

class UserCourseController extends GetxController {
  // ===== USECASES (Course & Lesson & Progress) =====
  final GetCoursesUseCase getCoursesUseCase;
  final GetLessonsUseCase getLessonsUseCase;
  final GetCourseProgressUseCase getCourseProgressUseCase;
  final ToggleLessonCompletedUseCase toggleLessonCompletedUseCase;

  // Enrollment
  final EnrollInCourseUseCase enrollInCourseUseCase;
  final UnenrollFromCourseUseCase unenrollFromCourseUseCase;
  final GetUserEnrollmentsUseCase getUserEnrollmentsUseCase;

  // Review
  final GetReviewsUseCase getReviewsUseCase;
  final GetUserReviewUseCase getUserReviewUseCase;
  final UpsertReviewUseCase upsertReviewUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;

  UserCourseController({
    required this.getCoursesUseCase,
    required this.getLessonsUseCase,
    required this.getCourseProgressUseCase,
    required this.toggleLessonCompletedUseCase,
    required this.enrollInCourseUseCase,
    required this.unenrollFromCourseUseCase,
    required this.getUserEnrollmentsUseCase,
    required this.getReviewsUseCase,
    required this.getUserReviewUseCase,
    required this.upsertReviewUseCase,
    required this.deleteReviewUseCase,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }
    return user.uid;
  }

  // ===== LIST COURSE (PUBLISHED) =====
  final isLoadingCourses = false.obs;
  final coursesError = RxnString();
  final publishedCourses = <CourseEntity>[].obs;

  // ===== ENROLLMENT STATE =====
  final isLoadingEnrollments = false.obs;
  final enrolledCourseIds = <String>{}.obs; // pakai Set String
  final isProcessingEnroll = false.obs;

  // ===== DETAIL + LESSONS + PROGRESS =====
  final isLoadingDetail = false.obs;
  final detailError = RxnString();
  final selectedCourse = Rxn<CourseEntity>();
  final lessons = <LessonEntity>[].obs;

  final isLoadingProgress = false.obs;
  final currentProgress = Rxn<CourseProgressEntity>();

  // List id lesson yang sudah selesai (sumber utama untuk UI)
  final completedLessonIds = <String>[].obs;
  final isTogglingLesson = false.obs;

  // ===== REVIEW & KOMENTAR =====
  final reviews = <ReviewEntity>[].obs;
  final isLoadingReviews = false.obs;

  final currentUserReview = Rxn<ReviewEntity>();
  final isSendingReview = false.obs;
  final isEditingReview = false.obs;

  final reviewTextC = TextEditingController();
  final ratingValue = 0.0.obs; // 0.0–5.0

  bool get hasUserReview => currentUserReview.value != null;

  @override
  void onInit() {
    super.onInit();
    loadPublishedCourses();
    loadUserEnrollments();
  }

  @override
  void onClose() {
    reviewTextC.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // LIST COURSE PUBLISHED
  // ---------------------------------------------------------------------------
  Future<void> loadPublishedCourses() async {
    isLoadingCourses.value = true;
    coursesError.value = null;

    try {
      final all = await getCoursesUseCase();
      final filtered = all
          .where((c) => c.status.toLowerCase() == 'published')
          .toList();
      filtered.sort((a, b) => a.name.compareTo(b.name));
      publishedCourses.assignAll(filtered);
    } catch (e) {
      coursesError.value = e.toString();
    } finally {
      isLoadingCourses.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // ENROLLMENT
  // ---------------------------------------------------------------------------
  Future<void> loadUserEnrollments() async {
    isLoadingEnrollments.value = true;
    try {
      final uid = _userId;
      final enrollments = await getUserEnrollmentsUseCase(uid);
      final ids = enrollments.map((e) => e.courseId).toSet();
      enrolledCourseIds.assignAll(ids);
    } catch (_) {
      // boleh diabaikan; bisa tambahkan snackbar kalau mau
    } finally {
      isLoadingEnrollments.value = false;
    }
  }

  bool isEnrolled(String courseId) => enrolledCourseIds.contains(courseId);

  Future<void> enroll(String courseId) async {
    isProcessingEnroll.value = true;
    try {
      final uid = _userId;

      // 1. Enroll di Firestore
      await enrollInCourseUseCase(userId: uid, courseId: courseId);

      // 2. Update state enrolled
      if (!enrolledCourseIds.contains(courseId)) {
        enrolledCourseIds.add(courseId);
      }

      // 3. Sinkronkan Kelasku
      if (Get.isRegistered<MyCoursesController>()) {
        await Get.find<MyCoursesController>().loadMyCourses();
      }

      // 4. Cari data course untuk ambil nama kelas
      //    - coba cari di publishedCourses
      //    - kalau tidak ketemu, fallback ke selectedCourse
      final course =
          publishedCourses.firstWhereOrNull((c) => c.id == courseId) ??
          selectedCourse.value;

      final courseName = course?.name ?? 'kelas';

      // 5. 🔔 Local notification (muncul di tray notifikasi HP)
      await LocalNotificationsService.showNotification(
        title: 'Kamu sudah enroll $courseName',
        body: 'Selamat belajar! 🎓',
      );

      // 6. Snackbar konfirmasi di dalam app
      Get.snackbar(
        'Berhasil',
        'Kamu berhasil enroll ke kelas ini 🎉',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal enroll: $e',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isProcessingEnroll.value = false;
    }
  }

  Future<void> unenroll(String courseId) async {
    final uid = _userId;

    isProcessingEnroll.value = true;
    try {
      // 1. batalkan enroll di Firestore (enrollments + enrollmentCount--)
      await unenrollFromCourseUseCase(userId: uid, courseId: courseId);

      // 2. update state lokal
      enrolledCourseIds.remove(courseId);

      // 3. sinkronkan Kelasku
      if (Get.isRegistered<MyCoursesController>()) {
        await Get.find<MyCoursesController>().loadMyCourses();
      }

      // 4. coba hapus review user untuk course ini (kalau ada)
      try {
        await deleteReviewUseCase(courseId: courseId, userId: uid);

        // refresh data review & rating di UI
        await loadReviews(courseId);
        await loadUserReview(courseId);
        await loadPublishedCourses(); // supaya rating agregat di list ikut turun
      } catch (_) {
        // kalau gagal hapus review, jangan blokir proses unenroll
      }

      // 🔔 snackbar konfirmasi unenroll + hapus review
      Get.snackbar(
        'Berhasil',
        'Enroll untuk kelas ini dibatalkan dan review kamu juga dihapus.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membatalkan enroll: $e',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isProcessingEnroll.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // DETAIL COURSE + LESSONS + PROGRESS + REVIEW
  // ---------------------------------------------------------------------------
  Future<void> loadCourseDetail(
    String courseId, [
    CourseEntity? initial,
  ]) async {
    final uid = _userId;
    isLoadingDetail.value = true;
    detailError.value = null;

    try {
      // set selectedCourse
      if (initial != null) {
        selectedCourse.value = initial;
      } else {
        final found = publishedCourses.firstWhereOrNull(
          (c) => c.id == courseId,
        );
        selectedCourse.value = found;
      }

      // lessons
      final ls = await getLessonsUseCase(courseId);
      lessons.assignAll(ls);

      // progress
      final CourseProgressEntity? progress = await getCourseProgressUseCase(
        userId: uid,
        courseId: courseId,
      );
      currentProgress.value = progress;
      final completedIds = progress?.completedLessonIds ?? <String>[];
      completedLessonIds.assignAll(completedIds);

      // reviews & review user
      await loadReviews(courseId);
      await loadUserReview(courseId);
    } catch (e) {
      detailError.value = e.toString();
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // PROGRESS
  // ---------------------------------------------------------------------------
  Future<void> loadProgress(String courseId) async {
    isLoadingProgress.value = true;
    try {
      final uid = _userId;
      final progress = await getCourseProgressUseCase(
        userId: uid,
        courseId: courseId,
      );
      currentProgress.value = progress;
      final completedIds = progress?.completedLessonIds ?? <String>[];
      completedLessonIds.assignAll(completedIds);
    } catch (_) {
      // boleh diabaikan
    } finally {
      isLoadingProgress.value = false;
    }
  }

  bool isLessonCompleted(String lessonId) {
    return completedLessonIds.contains(lessonId);
  }

  double _ratingValue(CourseEntity c) {
    if (c.rating == null) return 0;
    return double.tryParse(c.rating!.trim()) ?? 0;
  }

  bool _hasValidRating(CourseEntity c) {
    final raw = c.rating;
    if (raw == null) return false;

    final trimmed = raw.trim();
    if (trimmed.isEmpty) return false;

    final value = double.tryParse(trimmed);
    if (value == null) return false;

    // rating > 0 baru dianggap valid
    return value > 0;
  }

  bool _hasTag(CourseEntity c, String tag) {
    final tags = c.categoryTag.map((e) => e.toString().toLowerCase()).toList();
    return tags.contains(tag.toLowerCase());
  }

  List<CourseEntity> get popularCourses {
    final rated = publishedCourses.where(_hasValidRating).toList();

    rated.sort((a, b) {
      final rb = _ratingValue(b);
      final ra = _ratingValue(a);

      if (rb.compareTo(ra) != 0) {
        return rb.compareTo(ra); // rating terbesar dulu
      }
      return b.enrollmentCount.compareTo(
        a.enrollmentCount,
      ); // peserta terbanyak
    });

    return rated;
  }

  List<CourseEntity> get splCourses {
    return publishedCourses.where((c) => _hasTag(c, 'spl')).toList();
  }

  List<CourseEntity> get prakerjaCourses {
    return publishedCourses.where((c) => _hasTag(c, 'prakerja')).toList();
  }

  double get progressPercent {
    if (lessons.isEmpty) return 0.0;
    final done = completedLessonIds.length;
    return done / lessons.length;
  }

  Future<void> toggleLessonCompleted(String lessonId) async {
    final course = selectedCourse.value;
    if (course == null) return;

    isTogglingLesson.value = true;
    try {
      final uid = _userId;
      final updated = await toggleLessonCompletedUseCase(
        userId: uid,
        courseId: course.id,
        lessonId: lessonId,
      );

      currentProgress.value = updated;
      completedLessonIds.assignAll(updated.completedLessonIds);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengubah status materi: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isTogglingLesson.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // REVIEW & KOMENTAR
  // ---------------------------------------------------------------------------
  Future<void> loadReviews(String courseId) async {
    isLoadingReviews.value = true;
    try {
      final list = await getReviewsUseCase(courseId);
      reviews.assignAll(list);
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> loadUserReview(String courseId) async {
    final uid = _userId;
    final review = await getUserReviewUseCase(courseId: courseId, userId: uid);
    currentUserReview.value = review;

    if (review != null) {
      ratingValue.value = review.rating.toDouble();
      reviewTextC.text = review.comment;
      isEditingReview.value = false;
    } else {
      ratingValue.value = 0.0;
      reviewTextC.clear();
      isEditingReview.value = false;
    }
  }

  void startEditReview() {
    final r = currentUserReview.value;
    if (r == null) return;
    ratingValue.value = r.rating.toDouble();
    reviewTextC.text = r.comment;
    isEditingReview.value = true;
  }

  Future<void> submitReview(String courseId) async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar(
        'Oops',
        'Kamu harus login dulu untuk memberi review',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isEnrolled(courseId)) {
      Get.snackbar(
        'Belum Enroll',
        'Enroll dulu sebelum memberikan rating ya 😊',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final rating = ratingValue.value;
    final comment = reviewTextC.text.trim();

    if (rating <= 0) {
      Get.snackbar(
        'Oops',
        'Silakan pilih rating dulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSendingReview.value = true;
    try {
      await upsertReviewUseCase(
        courseId: courseId,
        userId: user.uid,
        userName: user.displayName ?? (user.email ?? 'User'),
        rating: rating,
        comment: comment,
      );

      await loadReviews(courseId);
      await loadUserReview(courseId);
      await loadPublishedCourses(); // supaya rating agregat di list ikut update

      // setelah submit → form disembunyikan (1 user 1 review)
      isEditingReview.value = false;

      Get.snackbar(
        'Terima kasih!',
        'Review kamu sudah tersimpan 🙏',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan review: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSendingReview.value = false;
    }
  }

  Future<void> deleteUserReview(String courseId) async {
    final uid = _userId;
    if (currentUserReview.value == null) return;

    isSendingReview.value = true;
    try {
      await deleteReviewUseCase(courseId: courseId, userId: uid);

      currentUserReview.value = null;
      ratingValue.value = 0.0;
      reviewTextC.clear();
      isEditingReview.value = false;

      await loadReviews(courseId);
      await loadPublishedCourses();

      Get.snackbar(
        'Berhasil',
        'Review kamu sudah dihapus.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus review: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSendingReview.value = false;
    }
  }
}
