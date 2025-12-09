class CourseProgressEntity {
  final String courseId;
  final String userId;
  final List<String> completedLessonIds;
  final DateTime updatedAt;

  const CourseProgressEntity({
    required this.courseId,
    required this.userId,
    required this.completedLessonIds,
    required this.updatedAt,
  });

  bool isLessonCompleted(String lessonId) {
    return completedLessonIds.contains(lessonId);
  }
}
