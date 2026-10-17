import '../models/activity_model.dart';
import '../models/activity_attempt_model.dart';

abstract class ActivityRepository {
  Future<List<ActivityModel>> getActivitiesByLessonId(int lessonId);
  Future<ActivityAttemptResponseModel> submitAttempt(int activityId, Map<String, dynamic> payload);
}
