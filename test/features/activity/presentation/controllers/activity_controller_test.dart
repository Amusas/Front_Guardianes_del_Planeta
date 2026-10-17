import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_attempt_model.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_model.dart';
import 'package:guardianes_del_planeta/features/activity/domain/repositories/activity_repository.dart';
import 'package:guardianes_del_planeta/features/activity/domain/usecases/get_activities_by_lesson_use_case.dart';
import 'package:guardianes_del_planeta/features/activity/domain/usecases/submit_activity_attempt_use_case.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/controllers/activity_controller.dart';

class MockActivityRepository implements ActivityRepository {
  final List<ActivityModel> activities;
  final bool shouldThrow;
  Map<String, dynamic>? lastSubmittedPayload;
  int? lastSubmittedActivityId;

  MockActivityRepository({required this.activities, this.shouldThrow = false});

  @override
  Future<List<ActivityModel>> getActivitiesByLessonId(int lessonId) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    return activities;
  }

  @override
  Future<ActivityAttemptResponseModel> submitAttempt(int activityId, Map<String, dynamic> payload) async {
    if (shouldThrow) {
      throw Exception('Network error');
    }
    lastSubmittedActivityId = activityId;
    lastSubmittedPayload = payload;
    return const ActivityAttemptResponseModel(
      isCorrect: true,
      attemptNumber: 1,
      xpAwarded: 15,
      totalXp: 15,
      currentLevel: 1,
      levelUp: false,
      activityCompleted: true,
      lessonCompleted: false,
      ecosystemCompleted: false,
      streakCount: 1,
    );
  }
}

void main() {
  group('ActivityController Tests', () {
    late List<ActivityModel> sampleActivities;

    setUp(() {
      sampleActivities = [
        ActivityModel.fromJson({
          'id': 1,
          'lessonId': 10,
          'type': 'MULTIPLE_CHOICE',
          'title': 'Pregunta 1',
          'configurationJson': '{"question":"¿Pregunta 1?","options":["A","B"],"correctOption":0}',
          'xpReward': 10,
          'orderIndex': 1,
        }),
        ActivityModel.fromJson({
          'id': 2,
          'lessonId': 10,
          'type': 'TRUE_FALSE',
          'title': 'Pregunta 2',
          'configurationJson': '{"statement":"¿Pregunta 2?","options":["Verdadero","Falso"],"correctOption":0}',
          'xpReward': 15,
          'orderIndex': 2,
        }),
      ];
    });

    test('loadActivities sets loaded state on success', () async {
      final repo = MockActivityRepository(activities: sampleActivities);
      final useCase = GetActivitiesByLessonUseCase(repo);
      final controller = ActivityController(getActivitiesByLessonUseCase: useCase);

      await controller.loadActivities(10);

      expect(controller.status, ActivityStatus.loaded);
      expect(controller.totalActivities, 2);
      expect(controller.currentIndex, 0);
      expect(controller.currentActivity?.title, 'Pregunta 1');
      expect(controller.isLastActivity, isFalse);
    });

    test('loadActivities sets error state on failure', () async {
      final repo = MockActivityRepository(activities: [], shouldThrow: true);
      final useCase = GetActivitiesByLessonUseCase(repo);
      final controller = ActivityController(getActivitiesByLessonUseCase: useCase);

      await controller.loadActivities(10);

      expect(controller.status, ActivityStatus.error);
      expect(controller.errorMessage, isNotNull);
    });

    test('checkAnswer evaluates correctly and updates XP', () async {
      final repo = MockActivityRepository(activities: sampleActivities);
      final useCase = GetActivitiesByLessonUseCase(repo);
      final controller = ActivityController(getActivitiesByLessonUseCase: useCase);

      await controller.loadActivities(10);

      controller.setAnswer(0);
      expect(controller.canCheck, isTrue);

      final isCorrect = await controller.checkAnswer();
      expect(isCorrect, isTrue);
      expect(controller.isAnswerChecked, isTrue);
      expect(controller.isAnswerCorrect, isTrue);
      expect(controller.totalXpEarned, 10);
      expect(controller.completedActivitiesCount, 1);
    });

    test('checkAnswer calls SubmitActivityAttemptUseCase and awards backend XP', () async {
      final repo = MockActivityRepository(activities: sampleActivities);
      final getUseCase = GetActivitiesByLessonUseCase(repo);
      final submitUseCase = SubmitActivityAttemptUseCase(repo);
      final controller = ActivityController(
        getActivitiesByLessonUseCase: getUseCase,
        submitActivityAttemptUseCase: submitUseCase,
      );

      await controller.loadActivities(10);
      controller.setAnswer(0);

      final isCorrect = await controller.checkAnswer();
      expect(isCorrect, isTrue);
      expect(repo.lastSubmittedActivityId, 1);
      expect(repo.lastSubmittedPayload, isNotNull);
      expect(controller.totalXpEarned, 15);
      expect(controller.lastAttemptResult?.isCorrect, isTrue);
    });

    test('skipActivity skips question and advances immediately', () async {
      final repo = MockActivityRepository(activities: sampleActivities);
      final useCase = GetActivitiesByLessonUseCase(repo);
      final controller = ActivityController(getActivitiesByLessonUseCase: useCase);

      await controller.loadActivities(10);

      expect(controller.currentIndex, 0);
      controller.skipActivity();

      expect(controller.currentIndex, 1);
      expect(controller.skippedActivitiesCount, 1);
      expect(controller.currentActivity?.title, 'Pregunta 2');

      // Skip the last activity should complete the session
      controller.skipActivity();
      expect(controller.status, ActivityStatus.completed);
      expect(controller.skippedActivitiesCount, 2);
    });

    test('nextActivity moves to next activity or completes on last activity', () async {
      final repo = MockActivityRepository(activities: sampleActivities);
      final useCase = GetActivitiesByLessonUseCase(repo);
      final controller = ActivityController(getActivitiesByLessonUseCase: useCase);

      await controller.loadActivities(10);

      controller.setAnswer(0);
      await controller.checkAnswer();
      controller.nextActivity();

      expect(controller.currentIndex, 1);
      expect(controller.isLastActivity, isTrue);

      controller.setAnswer(0);
      await controller.checkAnswer();
      controller.nextActivity();

      expect(controller.status, ActivityStatus.completed);
      expect(controller.totalXpEarned, 25);
    });
  });
}
