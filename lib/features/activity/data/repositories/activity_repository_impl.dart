import '../../domain/models/activity_model.dart';
import '../../domain/models/activity_attempt_model.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_remote_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource _remoteDataSource;

  ActivityRepositoryImpl({required ActivityRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<ActivityModel>> getActivitiesByLessonId(int lessonId) async {
    return await _remoteDataSource.getActivitiesByLessonId(lessonId);
  }

  @override
  Future<ActivityAttemptResponseModel> submitAttempt(int activityId, Map<String, dynamic> payload) async {
    return await _remoteDataSource.submitAttempt(activityId, payload);
  }
}
