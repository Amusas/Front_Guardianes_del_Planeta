import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/theme/app_theme.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/entities/child_profile_entity.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/entities/guardian_child_dashboard_entity.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/controllers/guardian_dashboard_controller.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/screens/guardian_dashboard_screen.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/state/guardian_dashboard_state.dart';

class MockGuardianDashboardController extends Mock implements GuardianDashboardController {}

void main() {
  late MockGuardianDashboardController mockController;

  setUp(() {
    mockController = MockGuardianDashboardController();
    when(() => mockController.loadDashboard(preferredChildId: any(named: 'preferredChildId')))
        .thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GuardianDashboardController>.value(value: mockController),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: GuardianDashboardScreen(
          onBackToChildExperience: () {},
        ),
      ),
    );
  }

  const sampleDashboard = GuardianChildDashboardEntity(
    childId: 1,
    name: 'Andrés',
    username: 'andresito',
    age: 9,
    totalXp: 500,
    levelNumber: 2,
    levelName: 'Explorador del Agua',
    currentLevelRequiredXp: 500,
    nextLevelRequiredXp: 1000,
    nextLevelName: 'Guardián de los Mares',
    levelProgressPercentage: 0.0,
    completedLessonsCount: 3,
    totalLessonsCount: 15,
    totalAttemptsCount: 8,
    correctAttemptsCount: 7,
    accuracyPercentage: 87.5,
    currentStreak: 3,
    unlockedAchievementsCount: 2,
    totalAchievementsCount: 6,
    achievements: [],
    ecosystemProgress: [
      EcosystemProgress(
        ecosystemId: 1,
        code: 'BOSQUE_ANDINO',
        name: 'Bosque Andino',
        completedLessons: 3,
        totalLessons: 5,
        progressPercentage: 60.0,
      ),
    ],
    xpHistory: [
      XpHistoryItem(
        id: 1,
        amount: 50,
        type: 'ACTIVITY',
        description: 'El ciclo del agua',
        createdAt: null,
      ),
    ],
    recentActivities: [
      RecentActivity(
        title: 'El ciclo del agua',
        description: 'Respuesta correcta',
        type: 'ACTIVITY',
        xpAwarded: 50,
        timestamp: null,
        isSuccess: true,
      ),
    ],
  );

  const sampleChild = ChildProfileEntity(
    id: 1,
    name: 'Andrés',
    totalXp: 500,
    streakCount: 3,
  );

  group('GuardianDashboardScreen Widget Tests', () {
    testWidgets('renders loading state when status is loading', (tester) async {
      when(() => mockController.state).thenReturn(
        const GuardianDashboardState(status: GuardianDashboardStatus.loading),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Dashboard del Acudiente'), findsOneWidget);
    });

    testWidgets('renders empty state when guardian has no children', (tester) async {
      when(() => mockController.state).thenReturn(
        const GuardianDashboardState(status: GuardianDashboardStatus.empty),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('¡Bienvenido al Panel del Acudiente!'), findsOneWidget);
      expect(find.text('Crear Perfil Infantil'), findsOneWidget);
    });

    testWidgets('renders error state with retry button when error occurs', (tester) async {
      when(() => mockController.state).thenReturn(
        const GuardianDashboardState(
          status: GuardianDashboardStatus.error,
          errorMessage: 'No se pudo conectar con el servidor',
        ),
      );
      when(() => mockController.loadDashboard()).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Error al cargar los datos'), findsOneWidget);
      expect(find.text('No se pudo conectar con el servidor'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);

      await tester.tap(find.text('Reintentar'));
      verify(() => mockController.loadDashboard()).called(2);
    });

    testWidgets('automatically calls loadDashboard when mounted on screen', (tester) async {
      when(() => mockController.state).thenReturn(
        const GuardianDashboardState(status: GuardianDashboardStatus.loaded),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      verify(() => mockController.loadDashboard()).called(1);
    });

    testWidgets('renders loaded dashboard with metrics, child selector and charts', (tester) async {
      when(() => mockController.state).thenReturn(
        GuardianDashboardState(
          status: GuardianDashboardStatus.loaded,
          children: [sampleChild],
          selectedChildId: 1,
          dashboard: sampleDashboard,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // Child selector
      expect(find.text('Andrés'), findsWidgets);

      // Level card
      expect(find.text('Explorador del Agua'), findsOneWidget);
      expect(find.text('500 XP'), findsWidgets);

      // Metric cards
      expect(find.text('3 / 15'), findsOneWidget); // Lecciones
      expect(find.text('8'), findsOneWidget); // Actividades
      expect(find.text('87.5%'), findsOneWidget); // Precisión
      expect(find.text('3 días'), findsOneWidget); // Racha
      expect(find.text('2 / 6'), findsOneWidget); // Logros

      // Ecosystem progress
      expect(find.text('Progreso por Ecosistema'), findsOneWidget);
      expect(find.text('Bosque Andino'), findsOneWidget);

      // XP evolution and recent activities
      expect(find.text('Evolución de Experiencia (XP)'), findsOneWidget);
      expect(find.text('Actividad Reciente'), findsOneWidget);
    });

    testWidgets('tapping child in selector calls selectChild on controller', (tester) async {
      const child2 = ChildProfileEntity(
        id: 2,
        name: 'Camila',
        totalXp: 800,
        streakCount: 5,
      );

      when(() => mockController.state).thenReturn(
        GuardianDashboardState(
          status: GuardianDashboardStatus.loaded,
          children: [sampleChild, child2],
          selectedChildId: 1,
          dashboard: sampleDashboard,
        ),
      );
      when(() => mockController.selectChild(2)).thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Camila'), findsOneWidget);
      await tester.tap(find.text('Camila'));
      verify(() => mockController.selectChild(2)).called(1);
    });
  });
}
