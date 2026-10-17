import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_attempt_model.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_model.dart';
import 'package:guardianes_del_planeta/features/activity/domain/repositories/activity_repository.dart';
import 'package:guardianes_del_planeta/features/activity/domain/usecases/get_activities_by_lesson_use_case.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/controllers/activity_controller.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/screens/interactive_activity_screen.dart';

class MockActivityRepository implements ActivityRepository {
  List<ActivityModel> activities = [];

  @override
  Future<List<ActivityModel>> getActivitiesByLessonId(int lessonId) async => activities;

  @override
  Future<ActivityAttemptResponseModel> submitAttempt(int activityId, Map<String, dynamic> payload) async {
    return const ActivityAttemptResponseModel(
      isCorrect: true,
      attemptNumber: 1,
      xpAwarded: 10,
      totalXp: 10,
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
  testWidgets('Simulate mouse hover across InteractiveActivityScreen for all activity types', (tester) async {
    final mockRepo = MockActivityRepository();
    mockRepo.activities = [
      ActivityModel.fromJson({
        'id': 1,
        'lessonId': 10,
        'type': 'MULTIPLE_CHOICE',
        'title': 'Identifica la especie',
        'configurationJson': '{"question":"¿Cuál es el Colibrí?","options":["Colibrí","Oso"],"correctAnswer":"Colibrí"}',
        'xpReward': 10,
        'orderIndex': 1,
      }),
      ActivityModel.fromJson({
        'id': 2,
        'lessonId': 10,
        'type': 'CLASSIFICATION',
        'title': 'Clasifica los residuos',
        'configurationJson': '{"instruction":"Clasifica","categories":[{"id":"org","name":"Orgánico"},{"id":"rec","name":"Reciclable"}],"items":[{"id":"1","name":"Manzana"},{"id":"2","name":"Botella"}]}',
        'xpReward': 10,
        'orderIndex': 2,
      }),
      ActivityModel.fromJson({
        'id': 3,
        'lessonId': 10,
        'type': 'ORDERING',
        'title': 'Ordena el ciclo',
        'configurationJson': '{"instruction":"Ordena","steps":["Paso 1","Paso 2","Paso 3"]}',
        'xpReward': 10,
        'orderIndex': 3,
      }),
      ActivityModel.fromJson({
        'id': 4,
        'lessonId': 10,
        'type': 'DRAG_AND_DROP',
        'title': 'Ubica en el hábitat',
        'configurationJson': '{"instruction":"Ubica","targets":[{"zone":"rio","name":"Río"},{"zone":"arbol","name":"Árbol"}],"elements":[{"id":"1","name":"Pez"},{"id":"2","name":"Pájaro"}]}',
        'xpReward': 10,
        'orderIndex': 4,
      }),
    ];

    final controller = ActivityController(
      getActivitiesByLessonUseCase: GetActivitiesByLessonUseCase(mockRepo),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ActivityController>.value(
          value: controller,
          child: InteractiveActivityScreen(
            lessonId: 10,
            onClose: () {},
            onActivityComplete: () {},
          ),
        ),
      ),
    );

    // Initial loading frame with mouse move
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    await gesture.moveTo(const Offset(200, 200));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Loaded frame - move mouse across screen
    for (double y = 0; y < 600; y += 50) {
      for (double x = 0; x < 400; x += 100) {
        await gesture.moveTo(Offset(x, y));
        await tester.pump(const Duration(milliseconds: 16));
      }
    }
  });
}
