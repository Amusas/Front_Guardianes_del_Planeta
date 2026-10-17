import '../entities/lesson.dart';
import '../repositories/lesson_repository.dart';

class GetLessonsByEcosystemUseCase {
  final LessonRepository _repository;

  GetLessonsByEcosystemUseCase(this._repository);

  Future<List<Lesson>> call(int ecosystemId) async {
    return await _repository.getLessonsByEcosystem(ecosystemId);
  }
}
