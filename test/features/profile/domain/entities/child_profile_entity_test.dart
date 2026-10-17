import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/profile/domain/entities/child_profile_entity.dart';

void main() {
  group('ChildProfileEntity Level Progression Tests', () {
    test('calculates Level 1 for 0 XP', () {
      final profile = ChildProfileEntity(
        id: 1,
        name: 'Andrés Jr',
        totalXp: 0,
        streakCount: 1,
      );

      expect(profile.levelNumber, 1);
      expect(profile.levelName, 'Semilla Guardiana');
      expect(profile.currentLevelRequiredXp, 0);
      expect(profile.nextLevelRequiredXp, 500);
      expect(profile.levelProgressRatio, 0.0);
    });

    test('calculates Level 1 and progress ratio for 180 XP', () {
      final profile = ChildProfileEntity(
        id: 1,
        name: 'Andrés Jr',
        totalXp: 180,
        streakCount: 2,
      );

      expect(profile.levelNumber, 1);
      expect(profile.levelName, 'Semilla Guardiana');
      expect(profile.currentLevelRequiredXp, 0);
      expect(profile.nextLevelRequiredXp, 500);
      expect(profile.levelProgressRatio, closeTo(0.36, 0.01));
    });

    test('calculates Level 3 and progress ratio for 1250 XP', () {
      final profile = ChildProfileEntity(
        id: 2,
        name: 'Juanito',
        totalXp: 1250,
        streakCount: 3,
      );

      expect(profile.levelNumber, 3);
      expect(profile.levelName, 'Guardián de los Mares');
      expect(profile.currentLevelRequiredXp, 1000);
      expect(profile.nextLevelRequiredXp, 1500);
      // In level 3: 250 XP out of 500 required -> 50%
      expect(profile.levelProgressRatio, closeTo(0.50, 0.01));
    });

    test('calculates Level 6 max level for 2600 XP', () {
      final profile = ChildProfileEntity(
        id: 3,
        name: 'Maestro',
        totalXp: 2600,
        streakCount: 10,
      );

      expect(profile.levelNumber, 6);
      expect(profile.levelName, 'Maestro Guardián');
      expect(profile.levelProgressRatio, 1.0);
    });
  });
}
