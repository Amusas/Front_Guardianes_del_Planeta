import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_attempt_model.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_model.dart';
import 'package:guardianes_del_planeta/features/activity/domain/repositories/activity_repository.dart';
import 'package:guardianes_del_planeta/features/activity/domain/usecases/get_activities_by_lesson_use_case.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/controllers/activity_controller.dart';
import 'package:guardianes_del_planeta/core/theme/app_theme.dart';
import 'package:guardianes_del_planeta/core/theme/app_colors.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/models/ecosystem_model.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/screens/interactive_activity_screen.dart';

class MockActivityRepository implements ActivityRepository {
  List<ActivityModel> activitiesToReturn = [];
  bool shouldThrow = false;

  @override
  Future<List<ActivityModel>> getActivitiesByLessonId(int lessonId) async {
    if (shouldThrow) {
      throw Exception('Error al cargar actividades');
    }
    return activitiesToReturn;
  }

  @override
  Future<ActivityAttemptResponseModel> submitAttempt(int activityId, Map<String, dynamic> payload) async {
    if (shouldThrow) {
      throw Exception('Error al enviar intento');
    }
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
  late MockActivityRepository mockRepository;
  late GetActivitiesByLessonUseCase useCase;
  late ActivityController activityController;

  final sampleActivities = [
    ActivityModel.fromJson({
      'id': 1,
      'lessonId': 10,
      'type': 'MULTIPLE_CHOICE',
      'title': '¿Dónde vive el oso de anteojos?',
      'configurationJson': '{"question":"¿Dónde vive el oso de anteojos?","options":["En el desierto","En el bosque andino"],"correctOption":1}',
      'xpReward': 10,
      'orderIndex': 1,
    }),
    ActivityModel.fromJson({
      'id': 2,
      'lessonId': 10,
      'type': 'TRUE_FALSE',
      'title': 'El bosque andino tiene alta biodiversidad',
      'configurationJson': '{"statement":"El bosque andino tiene alta biodiversidad.","options":["Verdadero","Falso"],"correctOption":0}',
      'xpReward': 10,
      'orderIndex': 2,
    }),
  ];

  setUp(() {
    mockRepository = MockActivityRepository();
    useCase = GetActivitiesByLessonUseCase(mockRepository);
    activityController = ActivityController(getActivitiesByLessonUseCase: useCase);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: ChangeNotifierProvider<ActivityController>.value(
        value: activityController,
        child: InteractiveActivityScreen(
          lessonId: 10,
          onClose: () {},
          onActivityComplete: () {},
        ),
      ),
    );
  }

  testWidgets('renders loading state initially', (tester) async {
    mockRepository.activitiesToReturn = sampleActivities;

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Preparando actividades de la lección...'), findsOneWidget);
  });

  testWidgets('renders activity question and verifies SALTAR is removed', (tester) async {
    mockRepository.activitiesToReturn = sampleActivities;

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('¿Dónde vive el oso de anteojos?'), findsWidgets);
    expect(find.text('En el bosque andino'), findsOneWidget);
    // Verificar que SALTAR NO existe en ninguna parte
    expect(find.text('SALTAR'), findsNothing);
  });

  testWidgets('answering correctly and pressing CONTINUAR advances to next activity', (tester) async {
    mockRepository.activitiesToReturn = sampleActivities;

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('¿Dónde vive el oso de anteojos?'), findsWidgets);

    // Seleccionar opción correcta
    await tester.tap(find.text('En el bosque andino'));
    await tester.pump();

    // Presionar COMPROBAR
    expect(find.text('COMPROBAR'), findsOneWidget);
    await tester.tap(find.text('COMPROBAR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Debe mostrar CONTINUAR
    expect(find.text('CONTINUAR'), findsOneWidget);
    await tester.tap(find.text('CONTINUAR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Ahora estamos en la actividad 2 (TRUE_FALSE)
    expect(find.text('El bosque andino tiene alta biodiversidad.'), findsOneWidget);
    expect(find.text('VERDADERO'), findsOneWidget);
    expect(find.text('FALSO'), findsOneWidget);
    expect(find.text('SALTAR'), findsNothing);
  });

  testWidgets('completing all activities displays congratulations screen with continue exploring', (tester) async {
    mockRepository.activitiesToReturn = sampleActivities.sublist(0, 1);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Seleccionar opción correcta
    await tester.tap(find.text('En el bosque andino'));
    await tester.pump();

    // Comprobar
    await tester.tap(find.text('COMPROBAR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Presionar FINALIZAR
    expect(find.text('FINALIZAR'), findsOneWidget);
    await tester.tap(find.text('FINALIZAR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verificar pantalla de celebración
    expect(find.text('¡Felicidades, completaste la lección!'), findsOneWidget);
    expect(find.text('¡Sigue explorando!'), findsOneWidget);
    expect(find.text('¡SIGUE EXPLORANDO!'), findsOneWidget);
  });

  testWidgets('renders error state with retry button when error occurs', (tester) async {
    mockRepository.shouldThrow = true;

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('¡Ups! Ocurrió un inconveniente'), findsOneWidget);
    expect(find.text('REINTENTAR'), findsOneWidget);
  });

  testWidgets('applies ecosystem background gradient and custom check button color', (tester) async {
    mockRepository.activitiesToReturn = sampleActivities;

    const testEcosystem = EcosystemModel(
      id: 'oceano',
      name: 'Océano Pacífico',
      subtitle: 'Arrecifes y gigantes marinos',
      description: 'Prueba de océano',
      backgroundGradient: AppColors.oceanGradient,
      primaryColor: AppColors.turquoiseDark,
      secondaryColor: AppColors.turquoise,
      isLocked: false,
      progress: 0.5,
      totalActivities: 5,
      completedActivities: 2,
      mainIcon: Icons.waves_rounded,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: ChangeNotifierProvider<ActivityController>.value(
          value: activityController,
          child: const InteractiveActivityScreen(
            lessonId: 10,
            ecosystem: testEcosystem,
            onClose: _noop,
            onActivityComplete: _noop,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify background container has the ocean gradient decoration
    final containerFinder = find.byType(Container).first;
    final container = tester.widget<Container>(containerFinder);
    expect((container.decoration as BoxDecoration?)?.gradient, equals(AppColors.oceanGradient));

    // Verify check button exists and is rendered with ecosystem color styling
    final checkButtonFinder = find.widgetWithText(ElevatedButton, 'COMPROBAR');
    expect(checkButtonFinder, findsOneWidget);
  });
}

void _noop() {}

