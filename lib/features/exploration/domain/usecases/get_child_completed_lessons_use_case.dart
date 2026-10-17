import '../repositories/lesson_repository.dart';

class GetChildCompletedLessonsUseCase {
  final LessonRepository _repository;

  GetChildCompletedLessonsUseCase(this._repository);

  Future<List<int>> call() async {
    return await _repository.getCompletedLessonIds();
  }
}
