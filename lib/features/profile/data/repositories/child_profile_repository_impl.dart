import '../../domain/entities/child_profile_entity.dart';
import '../../domain/entities/child_achievement_entity.dart';
import '../../domain/repositories/child_profile_repository.dart';
import '../datasources/child_profile_remote_data_source.dart';

class ChildProfileRepositoryImpl implements ChildProfileRepository {
  final ChildProfileRemoteDataSource _remoteDataSource;

  ChildProfileRepositoryImpl({required ChildProfileRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ChildProfileEntity> getMyProfile() async {
    final model = await _remoteDataSource.getMyProfile();
    return model.toEntity();
  }

  @override
  Future<List<ChildAchievementEntity>> getAllAchievements() async {
    final models = await _remoteDataSource.getAllAchievements();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<ChildAchievementEntity>> getMyAchievements() async {
    final models = await _remoteDataSource.getMyAchievements();
    return models.map((m) => m.toEntity(isUnlocked: true)).toList();
  }
}
