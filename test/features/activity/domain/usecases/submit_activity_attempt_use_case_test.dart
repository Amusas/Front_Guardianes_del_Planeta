import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_attempt_model.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_model.dart';
import 'package:guardianes_del_planeta/features/activity/domain/repositories/activity_repository.dart';
import 'package:guardianes_del_planeta/features/activity/domain/usecases/submit_activity_attempt_use_case.dart';

class MockActivityRepository implements ActivityRepository {
  int? calledActivityId;
  Map<String, dynamic>? calledPayload;
  bool shouldThrow = false;

  @override
  Future<List<ActivityModel>> getActivitiesByLessonId(int lessonId) async {
    return [];
  }

  @override
  Future<ActivityAttemptResponseModel> submitAttempt(
    int activityId,
    Map<String, dynamic> payload,
  ) async {
    if (shouldThrow) {
      throw Exception('Server error');
    }
    calledActivityId = activityId;
    calledPayload = payload;
    return const ActivityAttemptResponseModel(
      isCorrect: true,
      attemptNumber: 1,
      xpAwarded: 20,
      totalXp: 120,
      currentLevel: 2,
      levelUp: true,
      previousLevel: 1,
      activityCompleted: true,
      lessonCompleted: true,
      ecosystemCompleted: false,
      streakCount: 3,
    );
  }
}

void main() {
  group('SubmitActivityAttemptUseCase Tests', () {
    test('calls repository.submitAttempt with given activityId and payload', () async {
      final mockRepo = MockActivityRepository();
      final useCase = SubmitActivityAttemptUseCase(mockRepo);

      final payload = {'answer': 'En el manglar', 'option': 0};
      final result = await useCase(5, payload);

      expect(mockRepo.calledActivityId, 5);
      expect(mockRepo.calledPayload, payload);
      expect(result.isCorrect, isTrue);
      expect(result.xpAwarded, 20);
      expect(result.levelUp, isTrue);
      expect(result.lessonCompleted, isTrue);
    });

    test('rethrows exception when repository throws', () async {
      final mockRepo = MockActivityRepository()..shouldThrow = true;
      final useCase = SubmitActivityAttemptUseCase(mockRepo);

      expect(
        () => useCase(1, {}),
        throwsA(isA<Exception>()),
      );
    });
  });
}
