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

class FallbackMockActivityRepository implements ActivityRepository {
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
  testWidgets('Test full fallback activities flow with mouse tracking', (tester) async {
    final mockRepo = FallbackMockActivityRepository();
    mockRepo.activities = [
      // 1. MULTIPLE_CHOICE
      ActivityModel.fromJson({
        'id': 1,
        'lessonId': 1,
        'type': 'MULTIPLE_CHOICE',
        'title': '¿Dónde vive el oso de anteojos?',
        'configurationJson': '''
{
  "question": "¿Dónde vive el oso de anteojos?",
  "options": ["En el desierto caliente", "En el bosque andino y de niebla", "En el fondo del mar"],
  "correctAnswer": "En el bosque andino y de niebla",
  "correctOption": 1,
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 1,
      }),
      // 2. TRUE_FALSE
      ActivityModel.fromJson({
        'id': 2,
        'lessonId': 1,
        'type': 'TRUE_FALSE',
        'title': 'El bosque andino es hogar de muchos animales',
        'configurationJson': '''
{
  "statement": "El bosque andino es hogar de muchos animales, aves e insectos.",
  "options": ["Verdadero", "Falso"],
  "correctAnswer": "Verdadero",
  "correctOption": 0,
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 2,
      }),
      // 3. CLASSIFICATION
      ActivityModel.fromJson({
        'id': 3,
        'lessonId': 1,
        'type': 'CLASSIFICATION',
        'title': '¿Quiénes viven en el bosque?',
        'configurationJson': '''
{
  "instructions": "Separa los seres vivos del bosque de los objetos que no son vivos:",
  "categories": [
    {"id": "vivos", "name": "Seres vivos del bosque"},
    {"id": "no_vivos", "name": "Objetos no vivos"}
  ],
  "items": [
    {"id": "oso", "name": "Oso de anteojos"},
    {"id": "palma", "name": "Palma de cera"},
    {"id": "botella", "name": "Botella plástica"},
    {"id": "llanta", "name": "Llanta vieja"}
  ],
  "correctAnswers": {
    "oso": "vivos",
    "palma": "vivos",
    "botella": "no_vivos",
    "llanta": "no_vivos"
  },
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 3,
      }),
      // 4. ORDERING
      ActivityModel.fromJson({
        'id': 4,
        'lessonId': 1,
        'type': 'ORDERING',
        'title': 'El camino del agua',
        'configurationJson': '''
{
  "instructions": "Organiza los tres pasos sobre cómo el agua de la lluvia llega a una quebrada:",
  "steps": [
    "La lluvia cae sobre las hojas y el musgo",
    "El agua se infiltra y viaja por el suelo",
    "El agua brota limpia en la quebrada"
  ],
  "correctSequence": [0, 1, 2],
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 4,
      }),
      // 5. DRAG_AND_DROP
      ActivityModel.fromJson({
        'id': 5,
        'lessonId': 1,
        'type': 'DRAG_AND_DROP',
        'title': 'Construye tu bosque andino',
        'configurationJson': '''
{
  "instructions": "Ubica cada elemento en su lugar correcto dentro del hábitat:",
  "targets": [
    {"zone": "bosque", "name": "El Bosque"},
    {"zone": "agua", "name": "La Quebrada"},
    {"zone": "rama", "name": "Las Ramas"}
  ],
  "elements": [
    {"id": "arbol", "name": "Árbol nativo"},
    {"id": "pez", "name": "Pez de montaña"},
    {"id": "ave", "name": "Pájaro andino"}
  ],
  "correctAnswers": {
    "arbol": "bosque",
    "pez": "agua",
    "ave": "rama"
  },
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 5,
      }),
    ];

    final controller = ActivityController(
      getActivitiesByLessonUseCase: GetActivitiesByLessonUseCase(mockRepo),
    );

    await tester.binding.setSurfaceSize(const Size(1280, 800));

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<ActivityController>.value(
          value: controller,
          child: InteractiveActivityScreen(
            lessonId: 1,
            onClose: () {},
            onActivityComplete: () {},
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Check multiple choice elements
    expect(find.text('¿Dónde vive el oso de anteojos?'), findsWidgets);
    expect(find.text('En el bosque andino y de niebla'), findsOneWidget);
    expect(find.text('Actividad 1 de 5'), findsOneWidget);

    // Mouse movement sweeping across screen
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: const Offset(10, 10));
    for (double y = 0; y < 800; y += 50) {
      for (double x = 0; x < 1280; x += 100) {
        await gesture.moveTo(Offset(x, y));
        await tester.pump(const Duration(milliseconds: 5));
      }
    }

    // Tap on option
    await tester.tap(find.text('En el bosque andino y de niebla'));
    await tester.pump();

    // Check check button
    expect(find.text('COMPROBAR'), findsOneWidget);
  });
}
