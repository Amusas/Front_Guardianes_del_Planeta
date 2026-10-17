import '../entities/child_achievement_entity.dart';
import '../repositories/child_profile_repository.dart';

class GetMyChildAchievementsUseCase {
  final ChildProfileRepository _repository;

  GetMyChildAchievementsUseCase(this._repository);

  Future<List<ChildAchievementEntity>> execute() {
    return _repository.getMyAchievements();
  }
}
