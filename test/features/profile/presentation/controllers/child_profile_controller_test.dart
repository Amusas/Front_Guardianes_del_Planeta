import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/features/profile/domain/entities/child_profile_entity.dart';
import 'package:guardianes_del_planeta/features/profile/domain/entities/child_achievement_entity.dart';
import 'package:guardianes_del_planeta/features/profile/domain/usecases/get_my_child_profile_use_case.dart';
import 'package:guardianes_del_planeta/features/profile/domain/usecases/get_my_child_achievements_use_case.dart';
import 'package:guardianes_del_planeta/features/profile/domain/usecases/get_all_achievements_use_case.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/controllers/child_profile_controller.dart';

class MockGetMyChildProfileUseCase extends Mock implements GetMyChildProfileUseCase {}
class MockGetMyChildAchievementsUseCase extends Mock implements GetMyChildAchievementsUseCase {}
class MockGetAllAchievementsUseCase extends Mock implements GetAllAchievementsUseCase {}

void main() {
  late MockGetMyChildProfileUseCase mockProfileUseCase;
  late MockGetMyChildAchievementsUseCase mockMyAchievementsUseCase;
  late MockGetAllAchievementsUseCase mockAllAchievementsUseCase;
  late ChildProfileController controller;

  setUp(() {
    mockProfileUseCase = MockGetMyChildProfileUseCase();
    mockMyAchievementsUseCase = MockGetMyChildAchievementsUseCase();
    mockAllAchievementsUseCase = MockGetAllAchievementsUseCase();
    controller = ChildProfileController(
      getMyChildProfileUseCase: mockProfileUseCase,
      getMyChildAchievementsUseCase: mockMyAchievementsUseCase,
      getAllAchievementsUseCase: mockAllAchievementsUseCase,
    );
  });

  group('ChildProfileController Tests', () {
    test('initial state has default fallback values', () {
      expect(controller.totalXp, 0);
      expect(controller.levelNumber, 1);
      expect(controller.levelName, 'Semilla Guardiana');
      expect(controller.childName, 'Explorador');
      expect(controller.streakCount, 0);
      expect(controller.isLoading, false);
      expect(controller.errorMessage, isNull);
      expect(controller.badges, isEmpty);
    });

    test('loadProfile updates profile and marks unlocked achievements in badges', () async {
      final mockProfile = ChildProfileEntity(
        id: 2,
        name: 'Juanito Guardián',
        totalXp: 750,
        streakCount: 4,
      );

      final allAchievements = [
        const ChildAchievementEntity(
          id: 1,
          code: 'FIRST_STEP',
          title: 'Primer Paso',
          description: 'Completar primera actividad',
          conditionType: 'FIRST_ACTIVITY',
          conditionValue: 1,
          visualKey: 'BADGE_FIRST_STEP',
        ),
        const ChildAchievementEntity(
          id: 2,
          code: 'FIRST_LESSON',
          title: 'Primera Lección',
          description: 'Completar primera lección',
          conditionType: 'FIRST_LESSON',
          conditionValue: 1,
          visualKey: 'BADGE_FIRST_LESSON',
        ),
      ];

      // Child only unlocked FIRST_LESSON
      final myUnlocked = [
        ChildAchievementEntity(
          id: 2,
          code: 'FIRST_LESSON',
          title: 'Primera Lección',
          description: 'Completar primera lección',
          conditionType: 'FIRST_LESSON',
          conditionValue: 1,
          visualKey: 'BADGE_FIRST_LESSON',
          isUnlocked: true,
          unlockedAt: DateTime(2026, 10, 16, 10, 0),
        ),
      ];

      when(() => mockProfileUseCase.execute()).thenAnswer((_) async => mockProfile);
      when(() => mockAllAchievementsUseCase.execute()).thenAnswer((_) async => allAchievements);
      when(() => mockMyAchievementsUseCase.execute()).thenAnswer((_) async => myUnlocked);

      await controller.loadProfile();

      expect(controller.isLoading, false);
      expect(controller.profile, mockProfile);
      expect(controller.totalXp, 750);
      expect(controller.levelNumber, 2);
      expect(controller.levelName, 'Explorador del Agua');
      expect(controller.childName, 'Juanito Guardián');
      expect(controller.streakCount, 4);

      // Verify badges: exactly 2 badges, 1 unlocked (FIRST_LESSON), 1 locked (FIRST_STEP)
      expect(controller.badges.length, 2);
      expect(controller.totalAchievementsCount, 2);
      expect(controller.unlockedAchievementsCount, 1);

      final firstStepBadge = controller.badges.firstWhere((b) => b.id == 'first_step');
      expect(firstStepBadge.isUnlocked, isFalse);

      final firstLessonBadge = controller.badges.firstWhere((b) => b.id == 'first_lesson');
      expect(firstLessonBadge.isUnlocked, isTrue);
      expect(firstLessonBadge.dateUnlocked, '16 Oct 2026');
    });

    test('addExperienceLocally increases total XP and updates level', () async {
      final mockProfile = ChildProfileEntity(
        id: 1,
        name: 'Andrés',
        totalXp: 450,
        streakCount: 2,
      );
      when(() => mockProfileUseCase.execute()).thenAnswer((_) async => mockProfile);
      when(() => mockAllAchievementsUseCase.execute()).thenAnswer((_) async => []);
      when(() => mockMyAchievementsUseCase.execute()).thenAnswer((_) async => []);

      await controller.loadProfile();
      expect(controller.totalXp, 450);
      expect(controller.levelNumber, 1);

      controller.addExperienceLocally(60);
      expect(controller.totalXp, 510);
      expect(controller.levelNumber, 2);
      expect(controller.levelName, 'Explorador del Agua');
    });
  });
}
