import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/models/ecosystem_model.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/entities/lesson.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/repositories/lesson_repository.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/usecases/get_lessons_by_ecosystem_use_case.dart';
import 'package:guardianes_del_planeta/features/exploration/presentation/controllers/lesson_controller.dart';
import 'package:guardianes_del_planeta/features/exploration/presentation/screens/exploration_route_screen.dart';

class MockLessonRepository implements LessonRepository {
  List<Lesson> lessonsToReturn = [];
  bool shouldThrow = false;

  @override
  Future<List<Lesson>> getLessonsByEcosystem(int ecosystemId) async {
    if (shouldThrow) {
      throw Exception('Error al conectar con la ruta de exploración.');
    }
    return lessonsToReturn;
  }

  @override
  Future<void> completeLesson(int lessonId) async {}

  @override
  Future<List<int>> getCompletedLessonIds() async => [];
}

void main() {
  late MockLessonRepository mockRepository;
  late GetLessonsByEcosystemUseCase useCase;
  late LessonController lessonController;

  const testEcosystem = EcosystemModel(
    id: 'bosque_andino',
    numericId: 1,
    name: 'Bosque Andino',
    subtitle: 'El hogar del oso de anteojos',
    description: 'Ecosistema de alta montaña',
    backgroundGradient: LinearGradient(colors: [Colors.green, Colors.teal]),
    primaryColor: Colors.green,
    secondaryColor: Colors.lightGreen,
    isLocked: false,
    progress: 0.33,
    totalActivities: 3,
    completedActivities: 1,
    mainIcon: Icons.forest_rounded,
  );

  setUp(() {
    mockRepository = MockLessonRepository();
    useCase = GetLessonsByEcosystemUseCase(mockRepository);
    lessonController = LessonController(getLessonsByEcosystemUseCase: useCase);
  });

  Widget createWidgetUnderTest({EcosystemModel? ecosystem}) {
    return MaterialApp(
      home: ChangeNotifierProvider<LessonController>.value(
        value: lessonController,
        child: ExplorationRouteScreen(
          ecosystem: ecosystem ?? testEcosystem,
          onBackToEcosystems: () {},
          onStartActivity: (_) {},
        ),
      ),
    );
  }

  group('ExplorationRouteScreen Widget Tests', () {
    testWidgets('renders loading state when status is loading', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      // First frame before async completes
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Cargando ruta de lecciones...'), findsOneWidget);
    });

    testWidgets('renders error state with retry button when error occurs', (tester) async {
      mockRepository.shouldThrow = true;
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('¡Ups! No pudimos conectar con la ruta'), findsOneWidget);
      expect(find.text('REINTENTAR'), findsOneWidget);
    });

    testWidgets('renders empty state when no lessons returned', (tester) async {
      mockRepository.lessonsToReturn = [];
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No hay lecciones registradas aún'), findsOneWidget);
      expect(find.text('VOLVER'), findsOneWidget);
    });

    testWidgets('renders route and lesson nodes when lessons loaded successfully', (tester) async {
      mockRepository.lessonsToReturn = [
        const Lesson(
          id: 1,
          ecosystemId: 1,
          title: 'Los habitantes del bosque',
          content: 'Conoce los insectos y plantas del dosel andino.',
          orderIndex: 1,
          xpReward: 50,
          isActive: true,
        ),
        const Lesson(
          id: 2,
          ecosystemId: 1,
          title: 'El ciclo del agua',
          content: 'Aprende cómo las nubes y bosques alimentan los ríos.',
          orderIndex: 2,
          xpReward: 50,
          isActive: true,
        ),
      ];

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Bosque Andino'), findsOneWidget);
      expect(find.text('Los habitantes del bosque'), findsOneWidget);
      expect(find.text('El ciclo del agua'), findsOneWidget);
    });
  });
}
