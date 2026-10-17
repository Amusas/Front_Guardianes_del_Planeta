import '../entities/child_profile_entity.dart';
import '../entities/child_achievement_entity.dart';

abstract class ChildProfileRepository {
  Future<ChildProfileEntity> getMyProfile();
  Future<List<ChildAchievementEntity>> getAllAchievements();
  Future<List<ChildAchievementEntity>> getMyAchievements();
}
