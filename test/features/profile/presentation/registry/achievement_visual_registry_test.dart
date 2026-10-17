import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/core/theme/app_colors.dart';
import 'package:guardianes_del_planeta/features/profile/domain/entities/child_achievement_entity.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/registry/achievement_visual_registry.dart';

void main() {
  group('AchievementVisualRegistry Tests', () {
    test('maps FIRST_STEP correctly', () {
      final achievement = const ChildAchievementEntity(
        id: 1,
        code: 'FIRST_STEP',
        title: 'Primer Paso',
        description: 'Completar la primera actividad educativa.',
        conditionType: 'FIRST_ACTIVITY',
        conditionValue: 1,
        visualKey: 'BADGE_FIRST_STEP',
        isUnlocked: true,
      );

      final badge = AchievementVisualRegistry.toBadgeModel(achievement);

      expect(badge.id, 'first_step');
      expect(badge.title, 'Primer Paso');
      expect(badge.isUnlocked, isTrue);
      expect(badge.icon, Icons.directions_walk_rounded);
      expect(badge.primaryColor, AppColors.coral);
      expect(badge.xpBonus, 50);
    });

    test('maps FIRST_LESSON correctly with formatted unlock date', () {
      final achievement = ChildAchievementEntity(
        id: 2,
        code: 'FIRST_LESSON',
        title: 'Primera Lección',
        description: 'Completar con éxito tu primera lección ambiental.',
        conditionType: 'FIRST_LESSON',
        conditionValue: 1,
        visualKey: 'BADGE_FIRST_LESSON',
        isUnlocked: true,
        unlockedAt: DateTime(2026, 10, 16, 12, 30),
      );

      final badge = AchievementVisualRegistry.toBadgeModel(achievement);

      expect(badge.id, 'first_lesson');
      expect(badge.isUnlocked, isTrue);
      expect(badge.dateUnlocked, '16 Oct 2026');
      expect(badge.icon, Icons.menu_book_rounded);
      expect(badge.primaryColor, AppColors.forestGreen);
      expect(badge.xpBonus, 100);
    });

    test('maps locked achievement correctly', () {
      final achievement = const ChildAchievementEntity(
        id: 4,
        code: 'SEVEN_DAY_STREAK',
        title: 'Racha Imparable',
        description: 'Mantener una racha activa de 7 días consecutivos.',
        conditionType: 'STREAK_REACHED',
        conditionValue: 7,
        visualKey: 'BADGE_SEVEN_STREAK',
        isUnlocked: false,
      );

      final badge = AchievementVisualRegistry.toBadgeModel(achievement);

      expect(badge.isUnlocked, isFalse);
      expect(badge.dateUnlocked, isNull);
      expect(badge.icon, Icons.local_fire_department_rounded);
      expect(badge.primaryColor, AppColors.gold);
    });
  });
}
