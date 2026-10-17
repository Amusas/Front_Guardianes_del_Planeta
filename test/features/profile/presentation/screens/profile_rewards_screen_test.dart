import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/core/theme/app_theme.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/badge_model.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/avatar_config.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/controllers/child_profile_controller.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/screens/profile_rewards_screen.dart';
import 'package:guardianes_del_planeta/features/exploration/presentation/controllers/lesson_controller.dart';

class MockChildProfileController extends Mock implements ChildProfileController {}
class MockLessonController extends Mock implements LessonController {}

void main() {
  late MockChildProfileController mockProfileController;
  late MockLessonController mockLessonController;

  final testBadges = [
    const BadgeModel(
      id: 'first_step',
      title: 'Primer Paso',
      description: 'Completar la primera actividad',
      icon: Icons.directions_walk_rounded,
      primaryColor: Colors.orange,
      isUnlocked: true,
    ),
    const BadgeModel(
      id: 'first_lesson',
      title: 'Primera Lección',
      description: 'Completar primera lección',
      icon: Icons.menu_book_rounded,
      primaryColor: Colors.green,
      isUnlocked: false,
    ),
  ];

  setUp(() {
    mockProfileController = MockChildProfileController();
    mockLessonController = MockLessonController();

    when(() => mockProfileController.totalXp).thenReturn(180);
    when(() => mockProfileController.levelNumber).thenReturn(1);
    when(() => mockProfileController.levelName).thenReturn('Semilla Guardiana');
    when(() => mockProfileController.nextLevelRequiredXp).thenReturn(500);
    when(() => mockProfileController.levelProgressRatio).thenReturn(0.36);
    when(() => mockProfileController.childName).thenReturn('Andrés Jr');
    when(() => mockProfileController.streakCount).thenReturn(2);
    when(() => mockProfileController.badges).thenReturn(testBadges);
    when(() => mockProfileController.totalAchievementsCount).thenReturn(2);
    when(() => mockProfileController.unlockedAchievementsCount).thenReturn(1);
    when(() => mockProfileController.achievements).thenReturn([]);
    when(() => mockProfileController.avatarConfig).thenReturn(AvatarConfig.defaultConfig());
    when(() => mockProfileController.loadProfile(forceRefresh: any(named: 'forceRefresh')))
        .thenAnswer((_) async {});

    when(() => mockLessonController.completedLessonIds).thenReturn({1, 2});
    when(() => mockLessonController.loadUserProgress()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChildProfileController>.value(value: mockProfileController),
        ChangeNotifierProvider<LessonController>.value(value: mockLessonController),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: ProfileRewardsScreen(onBack: () {}),
      ),
    );
  }

  testWidgets('renders real XP, level, and badges from providers', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('Mi Perfil de Guardián'), findsOneWidget);

    // Verify Real Level and Title
    expect(find.text('Nivel 1'), findsOneWidget);
    expect(find.text('Semilla Guardiana'), findsOneWidget);

    // Verify Real XP details
    expect(find.text('180 / 500 XP para Nivel 2'), findsOneWidget);

    // Verify Stat Cards: 180 XP, 2 Lecciones, 1 Insignia
    expect(find.text('180'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Verify percentage text
    expect(find.text('36%'), findsOneWidget);

    // Verify real backend badges rendered in grid
    expect(find.text('1 / 2 Obtenidas'), findsOneWidget);
    expect(find.text('Primer Paso'), findsOneWidget);
    expect(find.text('Primera Lección'), findsOneWidget);
  });
}
