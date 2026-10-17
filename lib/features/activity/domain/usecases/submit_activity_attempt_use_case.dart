import '../models/activity_attempt_model.dart';
import '../repositories/activity_repository.dart';

class SubmitActivityAttemptUseCase {
  final ActivityRepository _repository;

  SubmitActivityAttemptUseCase(this._repository);

  Future<ActivityAttemptResponseModel> call(int activityId, Map<String, dynamic> payload) async {
    return await _repository.submitAttempt(activityId, payload);
  }
}
