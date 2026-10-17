import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/data/models/register_child_request_model.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/entities/child_profile_entity.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/entities/guardian_child_dashboard_entity.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/usecases/get_guardian_child_dashboard_use_case.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/usecases/get_guardian_children_use_case.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/usecases/register_child_for_guardian_use_case.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/controllers/guardian_dashboard_controller.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/state/guardian_dashboard_state.dart';

class MockGetGuardianChildrenUseCase extends Mock implements GetGuardianChildrenUseCase {}
class MockGetGuardianChildDashboardUseCase extends Mock implements GetGuardianChildDashboardUseCase {}
class MockRegisterChildForGuardianUseCase extends Mock implements RegisterChildForGuardianUseCase {}

class FakeRegisterChildRequestModel extends Fake implements RegisterChildRequestModel {}

void main() {
  late MockGetGuardianChildrenUseCase mockGetChildrenUseCase;
  late MockGetGuardianChildDashboardUseCase mockGetDashboardUseCase;
  late MockRegisterChildForGuardianUseCase mockRegisterChildUseCase;
  late GuardianDashboardController controller;

  setUpAll(() {
    registerFallbackValue(FakeRegisterChildRequestModel());
  });

  setUp(() {
    mockGetChildrenUseCase = MockGetGuardianChildrenUseCase();
    mockGetDashboardUseCase = MockGetGuardianChildDashboardUseCase();
    mockRegisterChildUseCase = MockRegisterChildForGuardianUseCase();

    controller = GuardianDashboardController(
      getChildrenUseCase: mockGetChildrenUseCase,
      getChildDashboardUseCase: mockGetDashboardUseCase,
      registerChildUseCase: mockRegisterChildUseCase,
    );
  });

  final child1 = ChildProfileEntity(
    id: 1,
    name: 'Andrés',
    totalXp: 500,
    streakCount: 3,
    age: 9,
    dateOfBirth: DateTime(2015, 6, 1),
  );

  final child2 = ChildProfileEntity(
    id: 2,
    name: 'Camila',
    totalXp: 800,
    streakCount: 5,
    age: 10,
    dateOfBirth: DateTime(2014, 2, 20),
  );

  const dashboard1 = GuardianChildDashboardEntity(
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
    ecosystemProgress: [],
    xpHistory: [],
    recentActivities: [],
  );

  const dashboard2 = GuardianChildDashboardEntity(
    childId: 2,
    name: 'Camila',
    username: 'camila_eco',
    age: 10,
    totalXp: 800,
    levelNumber: 2,
    levelName: 'Explorador del Agua',
    currentLevelRequiredXp: 500,
    nextLevelRequiredXp: 1000,
    nextLevelName: 'Guardián de los Mares',
    levelProgressPercentage: 60.0,
    completedLessonsCount: 5,
    totalLessonsCount: 15,
    totalAttemptsCount: 12,
    correctAttemptsCount: 12,
    accuracyPercentage: 100.0,
    currentStreak: 5,
    unlockedAchievementsCount: 4,
    totalAchievementsCount: 6,
    achievements: [],
    ecosystemProgress: [],
    xpHistory: [],
    recentActivities: [],
  );

  group('GuardianDashboardController Tests', () {
    test('initial state is initial with empty lists', () {
      expect(controller.state.status, GuardianDashboardStatus.initial);
      expect(controller.state.children, isEmpty);
      expect(controller.state.selectedChildId, isNull);
      expect(controller.state.dashboard, isNull);
    });

    test('loadDashboard sets status to empty when guardian has 0 children', () async {
      when(() => mockGetChildrenUseCase()).thenAnswer((_) async => []);

      await controller.loadDashboard();

      expect(controller.state.status, GuardianDashboardStatus.empty);
      expect(controller.state.children, isEmpty);
      expect(controller.state.selectedChildId, isNull);
    });

    test('loadDashboard sets status to loaded with 1 child and loads dashboard', () async {
      when(() => mockGetChildrenUseCase()).thenAnswer((_) async => [child1]);
      when(() => mockGetDashboardUseCase(1)).thenAnswer((_) async => dashboard1);

      await controller.loadDashboard();

      expect(controller.state.status, GuardianDashboardStatus.loaded);
      expect(controller.state.children.length, 1);
      expect(controller.state.selectedChildId, 1);
      expect(controller.state.dashboard?.name, 'Andrés');
      expect(controller.state.dashboard?.accuracyPercentage, 87.5);
    });

    test('loadDashboard sets status to loaded with multiple children and switches child', () async {
      when(() => mockGetChildrenUseCase()).thenAnswer((_) async => [child1, child2]);
      when(() => mockGetDashboardUseCase(1)).thenAnswer((_) async => dashboard1);
      when(() => mockGetDashboardUseCase(2)).thenAnswer((_) async => dashboard2);

      await controller.loadDashboard();

      expect(controller.state.status, GuardianDashboardStatus.loaded);
      expect(controller.state.children.length, 2);
      expect(controller.state.selectedChildId, 1);

      // Cambiar de niño
      await controller.selectChild(2);

      expect(controller.state.selectedChildId, 2);
      expect(controller.state.dashboard?.name, 'Camila');
      expect(controller.state.dashboard?.accuracyPercentage, 100.0);
    });

    test('loadDashboard sets status to error when usecase throws', () async {
      when(() => mockGetChildrenUseCase()).thenThrow(Exception('Error de conexión'));

      await controller.loadDashboard();

      expect(controller.state.status, GuardianDashboardStatus.error);
      expect(controller.state.errorMessage, 'Error de conexión');
    });

    test('registerChild registers child, reloads dashboard and selects new child', () async {
      const newChild = ChildProfileEntity(
        id: 3,
        name: 'Mateo',
        totalXp: 0,
        streakCount: 0,
      );

      const dashboardNew = GuardianChildDashboardEntity(
        childId: 3,
        name: 'Mateo',
        username: 'mateo123',
        totalXp: 0,
        levelNumber: 1,
        levelName: 'Semilla Guardiana',
        currentLevelRequiredXp: 0,
        nextLevelRequiredXp: 500,
        nextLevelName: 'Explorador del Agua',
        levelProgressPercentage: 0.0,
        completedLessonsCount: 0,
        totalLessonsCount: 15,
        totalAttemptsCount: 0,
        correctAttemptsCount: 0,
        accuracyPercentage: 0.0,
        currentStreak: 0,
        unlockedAchievementsCount: 0,
        totalAchievementsCount: 6,
        achievements: [],
        ecosystemProgress: [],
        xpHistory: [],
        recentActivities: [],
      );

      when(() => mockRegisterChildUseCase(any())).thenAnswer((_) async => newChild);
      when(() => mockGetChildrenUseCase()).thenAnswer((_) async => [child1, newChild]);
      when(() => mockGetDashboardUseCase(3)).thenAnswer((_) async => dashboardNew);

      final success = await controller.registerChild(
        username: 'mateo123',
        password: 'password123',
        name: 'Mateo',
        dateOfBirth: DateTime(2017, 1, 1),
      );

      expect(success, isTrue);
      expect(controller.state.selectedChildId, 3);
      expect(controller.state.dashboard?.name, 'Mateo');
    });

    test('registerChild sets creationErrorMessage when usecase throws', () async {
      when(() => mockRegisterChildUseCase(any()))
          .thenThrow(Exception('El nombre de usuario ya está registrado.'));

      final success = await controller.registerChild(
        username: 'duplicado',
        password: 'password123',
        name: 'Mateo',
        dateOfBirth: DateTime(2017, 1, 1),
      );

      expect(success, isFalse);
      expect(controller.state.creationErrorMessage, 'El nombre de usuario ya está registrado.');
    });

    test('reset clears state back to initial empty state', () async {
      when(() => mockGetChildrenUseCase()).thenAnswer((_) async => [child1]);
      when(() => mockGetDashboardUseCase(1)).thenAnswer((_) async => dashboard1);

      await controller.loadDashboard();
      expect(controller.state.status, GuardianDashboardStatus.loaded);
      expect(controller.state.children, isNotEmpty);

      controller.reset();
      expect(controller.state.status, GuardianDashboardStatus.initial);
      expect(controller.state.children, isEmpty);
      expect(controller.state.dashboard, isNull);
      expect(controller.state.selectedChildId, isNull);
    });
  });
}
