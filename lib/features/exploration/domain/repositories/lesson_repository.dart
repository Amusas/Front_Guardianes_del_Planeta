import '../../domain/entities/lesson.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getLessonsByEcosystem(int ecosystemId);
  Future<void> completeLesson(int lessonId);
  Future<List<int>> getCompletedLessonIds();
}
