import '../repositories/lesson_repository.dart';

class CompleteLessonUseCase {
  final LessonRepository _repository;

  CompleteLessonUseCase(this._repository);

  Future<void> call(int lessonId) async {
    return await _repository.completeLesson(lessonId);
  }
}
