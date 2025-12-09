import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/course_module/presentation/user/controllers/user_course_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/widgets/lesson_tile.dart';
import 'package:luar_sekolah_lms/main_shell.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UserCourseController>();

    // Pastikan detail + lesson + progress + review ke-load
    c.loadCourseDetail(courseId);

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            c.selectedCourse.value?.name ?? 'Detail Kelas',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: Obx(() {
        if (c.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.detailError.value != null) {
          return Center(child: Text('Terjadi error: ${c.detailError.value}'));
        }

        final course = c.selectedCourse.value;
        if (course == null) {
          return const Center(child: Text('Data kelas tidak ditemukan.'));
        }

        final isEnrolled = c.isEnrolled(course.id);
        final my = c.currentUserReview.value;
        final reviewCount = course.reviewCount;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== INFO UTAMA KELAS =====
              Text(
                course.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (course.rating != null &&
                      course.rating!.toString().trim().isNotEmpty) ...[
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      course.rating!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (reviewCount > 0) ...[
                      const SizedBox(width: 6),
                      Text(
                        '($reviewCount ulasan)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),
                  ],
                  Text(
                    course.price == '0.00' ? 'Gratis' : 'Rp ${course.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: course.categoryTag
                    .map(
                      (t) => Chip(
                        label: Text(t),
                        backgroundColor: Colors.purple.shade50,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              if ((course.description ?? '').isNotEmpty) ...[
                const Text(
                  'Deskripsi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(course.description!),
                const SizedBox(height: 16),
              ],

              // ===== TOMBOL ENROLL / UNENROLL =====
              // ===== TOMBOL ENROLL / UNENROLL =====
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: c.isProcessingEnroll.value
                            ? null
                            : () async {
                                if (isEnrolled) {
                                  // 🔔 Konfirmasi sebelum UNENROLL
                                  final confirm =
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Batalkan enroll?',
                                            ),
                                            content: const Text(
                                              'Kamu akan keluar dari kelas ini.\n\n'
                                              'Review & rating yang sudah kamu berikan '
                                              'juga akan dihapus. Lanjutkan?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(false);
                                                },
                                                child: const Text('Batal'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(true);
                                                },
                                                child: const Text(
                                                  'Ya, batalkan',
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ) ??
                                      false;

                                  if (!confirm) return;

                                  await c.unenroll(course.id);
                                } else {
                                  // 🔔 Konfirmasi sebelum ENROLL
                                  final confirm =
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Enroll kelas ini?',
                                            ),
                                            content: Text(
                                              'Kamu akan mendaftar ke kelas:\n\n'
                                              '"${course.name}".\n\n'
                                              'Setelah enroll, kelas ini akan muncul '
                                              'di menu Kelasku dan progres belajarmu '
                                              'akan tercatat.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(false);
                                                },
                                                child: const Text('Batal'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop(true);
                                                },
                                                child: const Text('Ya, enroll'),
                                              ),
                                            ],
                                          );
                                        },
                                      ) ??
                                      false;

                                  if (!confirm) return;

                                  await c.enroll(course.id);
                                }
                              },
                        child: c.isProcessingEnroll.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                isEnrolled
                                    ? 'Batalkan Enroll'
                                    : 'Enroll Kelas Ini',
                              ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ===== CTA KE HALAMAN BELAJAR (SETELAH ENROLL) =====
              if (isEnrolled) ...[
                const Text(
                  'Kamu sudah enroll di kelas ini.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Klik tombol di bawah untuk mulai belajar dan melihat daftar materi.',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // kasih tahu: kalau back dari CourseLearn → ke My Courses (Kelasku)
                      Get.to(
                        () => CourseLearnScreen(
                          courseId: course.id,
                          backToMyCourses: true,
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_circle_fill),
                    label: const Text('Mulai Belajar'),
                  ),
                ),

                const SizedBox(height: 24),
              ],

              // ===== RATING & KOMENTAR =====
              const Text(
                'Rating & Komentar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),

              if (isEnrolled) ...[
                _MyReviewForm(
                  initialRating: my?.rating ?? 0,
                  initialComment: my?.comment ?? '',
                  isSubmitting: c.isSendingReview.value,
                  onSubmit: (rating, comment) {
                    c.ratingValue.value = rating.toDouble();
                    c.reviewTextC.text = comment;
                    c.submitReview(course.id);
                  },
                  onDelete: my == null
                      ? null
                      : () => c.deleteUserReview(course.id),
                ),
              ] else ...[
                const Text(
                  'Enroll dulu untuk bisa memberi rating dan komentar 😊',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],

              const SizedBox(height: 12),

              if (c.isLoadingReviews.value)
                const Center(child: CircularProgressIndicator())
              else if (c.reviews.isEmpty)
                const Text('Belum ada ulasan untuk kelas ini.')
              else
                Column(
                  children: c.reviews.map((r) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            (r.userName != null && r.userName!.isNotEmpty)
                                ? r.userName![0].toUpperCase()
                                : 'U',
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                r.userName ?? 'Pengguna',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              children: List.generate(5, (i) {
                                final idx = i + 1;
                                return Icon(
                                  idx <= r.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 16,
                                  color: Colors.amber,
                                );
                              }),
                            ),
                          ],
                        ),
                        subtitle: Text(r.comment),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _MyReviewForm extends StatefulWidget {
  final int initialRating;
  final String initialComment;
  final bool isSubmitting;
  final void Function(int rating, String comment) onSubmit;
  final VoidCallback? onDelete;

  const _MyReviewForm({
    required this.initialRating,
    required this.initialComment,
    required this.isSubmitting,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<_MyReviewForm> createState() => _MyReviewFormState();
}

class _MyReviewFormState extends State<_MyReviewForm> {
  late int rating;
  late TextEditingController commentC;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
    commentC = TextEditingController(text: widget.initialComment);
  }

  @override
  void didUpdateWidget(covariant _MyReviewForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      rating = widget.initialRating;
    }
    if (oldWidget.initialComment != widget.initialComment) {
      commentC.text = widget.initialComment;
    }
  }

  @override
  void dispose() {
    commentC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating kamu',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (i) {
                final idx = i + 1;
                return IconButton(
                  onPressed: widget.isSubmitting
                      ? null
                      : () {
                          setState(() => rating = idx);
                        },
                  icon: Icon(
                    idx <= rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: commentC,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Tulis komentar tentang kelas ini (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: widget.isSubmitting || rating == 0
                      ? null
                      : () {
                          widget.onSubmit(rating, commentC.text.trim());
                        },
                  child: widget.isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.initialRating == 0
                              ? 'Kirim Review'
                              : 'Update Review',
                        ),
                ),
                const SizedBox(width: 8),
                if (widget.onDelete != null)
                  TextButton(
                    onPressed: widget.isSubmitting ? null : widget.onDelete,
                    child: const Text('Hapus'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CourseLearnScreen extends StatelessWidget {
  final String courseId;
  final bool backToMyCourses;

  const CourseLearnScreen({
    super.key,
    required this.courseId,
    this.backToMyCourses = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UserCourseController>();

    // Load detail kalau belum ada / beda id
    if (c.selectedCourse.value == null ||
        c.selectedCourse.value!.id != courseId ||
        c.lessons.isEmpty) {
      c.loadCourseDetail(courseId);
    }

    return WillPopScope(
      onWillPop: () async {
        if (backToMyCourses) {
          // ⬅️ Mode "balik ke Kelasku":
          // ganti UserMainScreen & initialIndex sesuai struktur aplikasi kamu.
          Get.offAll(() => const MainShell(initialIndex: 1));
          return false; // kita handle sendiri, jangan pop default
        }
        // mode biasa: biarkan Flutter pop ke route sebelumnya (bisa CourseDetail)
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Obx(
            () => Text(
              c.selectedCourse.value?.name ?? 'Belajar Kelas',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          actions: [
            // TextButton.icon(
            //   onPressed: () {
            //     Get.to(() => CourseDetailScreen(courseId: courseId));
            //   },
            //   icon: const Icon(Icons.info_outline),
            //   label: const Text('Lihat info & review kelas'),
            // ),
          ],
        ),
        body: Obx(() {
          if (c.isLoadingDetail.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (c.detailError.value != null) {
            return Center(child: Text('Terjadi error: ${c.detailError.value}'));
          }

          final course = c.selectedCourse.value;
          if (course == null) {
            return const Center(child: Text('Data kelas tidak ditemukan.'));
          }

          final isEnrolled = c.isEnrolled(course.id);
          if (!isEnrolled) {
            // Safety kalau somehow user belum enroll tapi masuk sini
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Kamu belum enroll di kelas ini.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => CourseDetailScreen(courseId: courseId));
                      },
                      child: const Text('Lihat detail & enroll'),
                    ),
                  ],
                ),
              ),
            );
          }

          final lessons = c.lessons;
          final progress = c.progressPercent;
          final progressText = '${(progress * 100).round()}%';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Proses Belajar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: LinearProgressIndicator(value: progress)),
                    const SizedBox(width: 12),
                    Text(progressText),
                  ],
                ),
                const SizedBox(height: 24),

                const Text(
                  'Daftar Materi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),

                if (lessons.isEmpty)
                  const Text('Belum ada materi yang tersedia.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      final completed = c.isLessonCompleted(lesson.id);

                      return LessonTile(
                        index: index + 1,
                        title: lesson.title,
                        contentPreview: lesson.content,
                        completed: completed,
                        onTap: () {
                          Get.to(
                            () => LessonLearnScreen(
                              courseId: course.id,
                              lessonId: lesson.id,
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class LessonLearnScreen extends StatelessWidget {
  final String courseId;
  final String lessonId;

  const LessonLearnScreen({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<UserCourseController>();

    // Cari lesson berdasarkan id
    final lessons = c.lessons;
    final index = lessons.indexWhere((l) => l.id == lessonId);

    if (index == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Materi tidak ditemukan')),
        body: const Center(child: Text('Materi ini tidak ditemukan.')),
      );
    }

    final lesson = lessons[index];

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'Detail kelas',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Get.to(() => CourseDetailScreen(courseId: courseId));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul materi
            Text(
              'Materi ${index + 1}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              lesson.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),

            // Konten materi (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  lesson.content,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tombol "Aku sudah mengerti" / "Tandai belum mengerti"
            // Tombol "Aku sudah mengerti" / "Tandai belum mengerti"
            SafeArea(
              top: false,
              child: Obx(() {
                final completed = c.isLessonCompleted(lessonId);
                final isLoading = c.isTogglingLesson.value;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final before =
                                completed; // simpan status sebelum toggle

                            await c.toggleLessonCompleted(lessonId);

                            // Snackbar feedback
                            if (before == false) {
                              Get.snackbar(
                                'Mantap! 🎉',
                                'Materi ini telah ditandai sebagai sudah dipahami.',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                              );
                            } else {
                              Get.snackbar(
                                'Status diubah',
                                'Materi ini ditandai belum dipahami.',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                              );
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            completed
                                ? 'Tandai belum mengerti'
                                : 'Aku sudah mengerti',
                          ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
