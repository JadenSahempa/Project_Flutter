class LessonEntity {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final int order;
  // final bool isPreview;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  const LessonEntity({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.order,
    // required this.isPreview,
    // required this.createdAt,
    // required this.updatedAt,
  });
}
