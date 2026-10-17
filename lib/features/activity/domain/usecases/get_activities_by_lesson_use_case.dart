import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';

class GetActivitiesByLessonUseCase {
  final ActivityRepository _repository;

  GetActivitiesByLessonUseCase(this._repository);

  Future<List<ActivityModel>> call(int lessonId) async {
    final activities = await _repository.getActivitiesByLessonId(lessonId);
    final sorted = List<ActivityModel>.from(activities);
    sorted.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return sorted;
  }
}
