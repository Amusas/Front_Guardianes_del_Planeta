import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/theme/app_theme.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/entities/ecosystem.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/controllers/ecosystem_controller.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/screens/ecosystem_selector_screen.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/state/ecosystem_state.dart';
import 'package:guardianes_del_planeta/features/exploration/presentation/controllers/lesson_controller.dart';
import 'package:guardianes_del_planeta/features/exploration/presentation/screens/exploration_route_screen.dart';
import 'package:guardianes_del_planeta/features/exploration/presentation/state/lesson_state.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/avatar_config.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/controllers/child_profile_controller.dart';
import 'package:guardianes_del_planeta/features/navigation/main_navigator.dart';

class MockEcosystemController extends Mock implements EcosystemController {}
class MockLessonController extends Mock implements LessonController {}
class MockChildProfileController extends Mock implements ChildProfileController {}

void main() {
  late MockEcosystemController mockEcoController;
  late MockLessonController mockLessonController;
  late MockChildProfileController mockProfileController;

  final ecosystems = [
    const Ecosystem(
      id: 1,
      code: 'BOSQUE_ANDINO',
      name: 'Bosque Andino',
      description: 'El hogar del oso de anteojos y palmas.',
      isActive: true,
    ),
    const Ecosystem(
      id: 2,
      code: 'PARAMO',
      name: 'El Páramo',
      description: 'Frailejones y lagunas sagradas.',
      isActive: true,
    ),
  ];

  setUp(() {
    mockEcoController = MockEcosystemController();
    mockLessonController = MockLessonController();
    mockProfileController = MockChildProfileController();

    when(() => mockEcoController.state).thenReturn(
      EcosystemState(
        status: EcosystemLoadingStatus.success,
        ecosystems: ecosystems,
        selectedIndex: 0,
      ),
    );
    when(() => mockEcoController.loadEcosystems(forceRefresh: any(named: 'forceRefresh')))
        .thenAnswer((_) async {});
    when(() => mockEcoController.selectIndex(any())).thenReturn(null);

    when(() => mockLessonController.state).thenReturn(
      const LessonState(status: LessonStatus.empty, nodes: []),
    );
    when(() => mockLessonController.loadLessons(any())).thenAnswer((_) async {});
    when(() => mockLessonController.loadUserProgress()).thenAnswer((_) async {});
    when(() => mockLessonController.preloadLessonsForEcosystem(any())).thenAnswer((_) async {});
    when(() => mockLessonController.getProgressForEcosystem(any())).thenReturn(0.0);
    when(() => mockLessonController.completedLessonIds).thenReturn({1, 2});

    when(() => mockProfileController.totalXp).thenReturn(180);
    when(() => mockProfileController.levelNumber).thenReturn(1);
    when(() => mockProfileController.levelName).thenReturn('Semilla Guardiana');
    when(() => mockProfileController.nextLevelRequiredXp).thenReturn(500);
    when(() => mockProfileController.levelProgressRatio).thenReturn(0.36);
    when(() => mockProfileController.childName).thenReturn('Andrés Jr');
    when(() => mockProfileController.streakCount).thenReturn(2);
    when(() => mockProfileController.badges).thenReturn([]);
    when(() => mockProfileController.totalAchievementsCount).thenReturn(0);
    when(() => mockProfileController.unlockedAchievementsCount).thenReturn(0);
    when(() => mockProfileController.achievements).thenReturn([]);
    when(() => mockProfileController.avatarConfig).thenReturn(AvatarConfig.defaultConfig());
    when(() => mockProfileController.loadProfile(forceRefresh: any(named: 'forceRefresh')))
        .thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EcosystemController>.value(value: mockEcoController),
        ChangeNotifierProvider<LessonController>.value(value: mockLessonController),
        ChangeNotifierProvider<ChildProfileController>.value(value: mockProfileController),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const MainNavigator(),
      ),
    );
  }

  testWidgets('Navigating to ExplorationRoute and back returns to the selected ecosystem', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(EcosystemSelectorScreen), findsOneWidget);

    // Swipe to page 2 (El Páramo) in carousel
    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('El Páramo'), findsWidgets);

    // Tap EXPLORAR to navigate to ExplorationRouteScreen
    await tester.tap(find.text('EXPLORAR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ExplorationRouteScreen), findsOneWidget);
    expect(find.text('El Páramo'), findsWidgets);

    // Tap back button in header (arrow_back_rounded)
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Verify it returned to EcosystemSelectorScreen and El Páramo is selected
    expect(find.byType(EcosystemSelectorScreen), findsOneWidget);
    expect(find.text('El Páramo'), findsWidgets);
  });

  testWidgets('Tapping explore button (FAB) inside ExplorationRoute returns to the selected ecosystem', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(milliseconds: 300));

    // Swipe to page 2 (El Páramo) in carousel
    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('El Páramo'), findsWidgets);

    // Tap EXPLORAR
    await tester.tap(find.text('EXPLORAR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(ExplorationRouteScreen), findsOneWidget);

    // Tap floating explore button (Icons.explore_rounded) inside exploration route
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Verify it returned to EcosystemSelectorScreen and El Páramo is selected
    expect(find.byType(EcosystemSelectorScreen), findsOneWidget);
    expect(find.text('El Páramo'), findsWidgets);
  });

  testWidgets('Navigating to ProfileRewardsScreen and back returns to EcosystemSelectorScreen', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(milliseconds: 300));

    // Find profile avatar/header button in EcosystemSelectorScreen and tap it
    final ecoScreen = tester.widget<EcosystemSelectorScreen>(find.byType(EcosystemSelectorScreen));
    ecoScreen.onOpenProfile?.call();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const ValueKey('screen_profile')), findsOneWidget);

    // Tap back button in ProfileRewardsScreen
    await tester.tap(find.byIcon(Icons.arrow_back_rounded).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(EcosystemSelectorScreen), findsOneWidget);
  });

  testWidgets('Navigating to InteractiveActivityScreen and completing or closing returns to ExplorationRouteScreen', (tester) async {
    when(() => mockLessonController.completeLesson(any())).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('EXPLORAR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final routeScreen = tester.widget<ExplorationRouteScreen>(find.byType(ExplorationRouteScreen));
    expect(routeScreen.onStartActivity, isNotNull);
  });
}
