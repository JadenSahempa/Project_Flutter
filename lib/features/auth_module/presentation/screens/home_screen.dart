import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/auth_module/presentation/controller/auth_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/controllers/user_course_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/screens/course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageC = PageController();
  int _page = 0;

  // Controller dari GetX
  final AuthController authC = Get.find<AuthController>();
  final UserCourseController courseC = Get.find<UserCourseController>();

  @override
  void dispose() {
    _pageC.dispose();
    super.dispose();
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

    return value > 0;
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF0FA37F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HEADER HIJAU =================
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                decoration: const BoxDecoration(color: green),
                child: Row(
                  children: [
                    // 🔹 Avatar dinamis berdasarkan photoUrl profile
                    Obx(() {
                      final profile = authC.currentUserProfile.value;
                      final photoUrl = profile?.photoUrl;

                      return CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.teal.shade50,
                        foregroundImage:
                            (photoUrl != null && photoUrl.isNotEmpty)
                            ? NetworkImage(photoUrl)
                            : null,
                        child: const Icon(Icons.person, color: Colors.white),
                      );
                    }),
                    const SizedBox(width: 12),

                    // 🔹 Nama dinamis: profile.name > displayName > email > 'User'
                    Expanded(
                      child: Obx(() {
                        final profile = authC.currentUserProfile.value;
                        final user = authC.currentUser.value;

                        String name;

                        if (profile?.name != null &&
                            profile!.name!.trim().isNotEmpty) {
                          name = profile.name!.trim();
                        } else if (user?.displayName?.isNotEmpty ?? false) {
                          name = user!.displayName!.trim();
                        } else if (user?.email?.isNotEmpty ?? false) {
                          name = user!.email!.trim();
                        } else {
                          name = 'User';
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Halo,',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '$name 👋',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= BANNER SLIDER =================
              Container(
                transform: Matrix4.translationValues(0, -18, 0),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 14,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: PageView(
                            controller: _pageC,
                            onPageChanged: (i) => setState(() => _page = i),
                            children: const [
                              _HomeBanner(
                                imagePath: 'lib/assets/images/banner_1.png',
                                buttonText: 'IKUTAN SEKARANG',
                              ),
                              _HomeBanner(
                                imagePath: 'lib/assets/images/banner_2.png',
                                buttonText: 'PELAJARI',
                              ),
                              _HomeBanner(
                                imagePath: 'lib/assets/images/banner_3.png',
                                buttonText: 'DAFTAR',
                              ),
                              _HomeBanner(
                                imagePath: 'lib/assets/images/banner_4.png',
                                buttonText: 'LIHAT DETAIL',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // dots indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (i) {
                          final active = i == _page;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: active ? green : Colors.transparent,
                              border: Border.all(
                                color: active ? green : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              // ================= PROGRAM DARI LUARSEKOLAH =================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Program dari Luarsekolah',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        _ProgramCard(
                          icon: Icons.work_outline,
                          label: 'Prakerja',
                        ),
                        SizedBox(width: 12),
                        _ProgramCard(
                          icon: Icons.add_circle_outline,
                          label: 'magang+',
                        ),
                        SizedBox(width: 12),
                        _ProgramCard(
                          icon: Icons.subscriptions_outlined,
                          label: 'Subs',
                        ),
                        SizedBox(width: 12),
                        _ProgramCard(
                          icon: Icons.grid_view_rounded,
                          label: 'Lainnya',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ================= REDEEM VOUCHER PRAKERJA =================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.local_activity_outlined,
                            size: 20,
                            color: Colors.teal,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Redeem Voucher Prakerjamu',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Kamu pengguna Prakerja? Segera redeem vouchermu sekarang juga',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 46,
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          },
                          child: const Text('Masukkan Voucher Prakerja'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ================== BAGIAN POPULER (DINAMIS) ==================
              Obx(() {
                if (courseC.isLoadingCourses.value &&
                    courseC.publishedCourses.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final allCourses = courseC.publishedCourses;

                if (allCourses.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Belum ada kelas yang tersedia.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                // ================== 1. KELAS TERPOPULER (HANYA YANG PUNYA RATING) ==================
                final ratedCourses = allCourses.where(_hasValidRating).toList();

                // Sort: rating desc, lalu enrollmentCount desc
                ratedCourses.sort((a, b) {
                  final rb = _ratingValue(b);
                  final ra = _ratingValue(a);

                  if (rb.compareTo(ra) != 0) {
                    return rb.compareTo(ra); // rating tertinggi dulu
                  }
                  // kalau rating sama, lihat jumlah peserta
                  return b.enrollmentCount.compareTo(a.enrollmentCount);
                });

                final popularAll = ratedCourses.take(10).toList();

                // ================== 2. KELAS SPL & PRAKERJA (SEMUA KELAS, RATING BOLEH KOSONG) ==================
                bool hasTag(CourseEntity c, String tag) {
                  final tags = c.categoryTag
                      .map((e) => e.toString().toLowerCase())
                      .toList();
                  return tags.contains(tag.toLowerCase());
                }

                final splCourses = allCourses
                    .where((c) => hasTag(c, 'spl'))
                    .take(10)
                    .toList();

                final prakerjaCourses = allCourses
                    .where((c) => hasTag(c, 'prakerja'))
                    .take(10)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (popularAll.isNotEmpty) ...[
                      _PopularSection(
                        title: 'Kelas Terpopuler',
                        courses: popularAll,
                      ),
                      const SizedBox(height: 16),
                    ],

                    _PopularSection(
                      title: 'Kelas SPL',
                      courses: splCourses,
                      emptyText:
                          'Belum ada kelas dengan tag SPL yang tersedia.',
                    ),
                    const SizedBox(height: 16),

                    _PopularSection(
                      title: 'Kelas Prakerja',
                      courses: prakerjaCourses,
                      emptyText:
                          'Belum ada kelas dengan tag Prakerja yang tersedia.',
                    ),
                  ],
                );
              }),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= SMALL WIDGETS =================

class _HomeBanner extends StatelessWidget {
  final String imagePath;
  final String buttonText;

  const _HomeBanner({required this.imagePath, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
        Positioned(
          bottom: 10,
          right: 10,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.9),
              foregroundColor: Colors.black87,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(buttonText),
          ),
        ),
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ProgramCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: Colors.black87),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _PopularSection extends StatelessWidget {
  final String title;
  final List<CourseEntity> courses;
  final String? emptyText;

  const _PopularSection({
    required this.title,
    required this.courses,
    this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          height: 250,
          child: courses.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      emptyText ?? 'Belum ada kelas untuk kategori ini.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: courses.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return _PopularCourseCard(course: course);
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.zero,
              ),
              onPressed: () {
                // Nanti bisa diarahkan ke halaman "Kelas" dengan filter.
                Get.snackbar(
                  'Info',
                  'Gunakan tab "Kelas" untuk melihat daftar lengkap.',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                );
              },
              child: const Text(
                'Lihat Semua Kelas',
                style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularCourseCard extends StatelessWidget {
  final CourseEntity course;

  _PopularCourseCard({super.key, required this.course});

  List<String> _displayTags() {
    if (course.categoryTag.isEmpty) {
      return const ['Kelas'];
    }

    final lowerTags = course.categoryTag
        .map((e) => e.toString().toLowerCase())
        .toList();

    final List<String> result = [];

    if (lowerTags.contains('spl')) {
      result.add('SPL');
    }
    if (lowerTags.contains('prakerja')) {
      result.add('Prakerja');
    }

    if (result.isEmpty) {
      result.addAll(course.categoryTag.map((e) => e.toString()));
    }

    return result.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userCourseC = Get.find<UserCourseController>();
    final rating = (course.rating == null || course.rating!.trim().isEmpty)
        ? null
        : course.rating;
    final priceText = (course.price == '0.00' || course.price == '0')
        ? 'Gratis'
        : 'Rp ${course.price}';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await userCourseC.loadCourseDetail(course.id, course);
        Get.to(() => CourseDetailScreen(courseId: course.id));
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                height: 90,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: course.thumbnail == null
                    ? const Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.white,
                      )
                    : Image.network(
                        course.thumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),

            // isi kartu
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (final tag in _displayTags())
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF7F2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    course.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  if (rating != null) ...[
                    Row(
                      children: [
                        Text(
                          '$rating ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFFFB300),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ] else ...[
                    const SizedBox(height: 4),
                    const Text(
                      'Belum ada rating',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                  ],

                  Text(
                    priceText,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final String imagePath;
  final String countText;
  final String title;

  const _SubscriptionCard({
    required this.imagePath,
    required this.countText,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 16,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      countText,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
