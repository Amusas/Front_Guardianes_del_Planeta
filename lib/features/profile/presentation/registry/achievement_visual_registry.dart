import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/child_achievement_entity.dart';
import '../../domain/models/badge_model.dart';

class AchievementVisualRegistry {
  AchievementVisualRegistry._();

  /// Convierte una entidad de logro del backend en el modelo de insignia visual para la UI
  static BadgeModel toBadgeModel(ChildAchievementEntity achievement) {
    final code = achievement.code.toUpperCase();
    final visualKey = achievement.visualKey.toUpperCase();

    IconData icon;
    Color primaryColor;
    int xpBonus;

    if (code == 'FIRST_STEP' || visualKey == 'BADGE_FIRST_STEP') {
      icon = Icons.directions_walk_rounded;
      primaryColor = AppColors.coral;
      xpBonus = 50;
    } else if (code == 'FIRST_LESSON' || visualKey == 'BADGE_FIRST_LESSON') {
      icon = Icons.menu_book_rounded;
      primaryColor = AppColors.forestGreen;
      xpBonus = 100;
    } else if (code == 'WATER_PROTECTOR' || visualKey == 'BADGE_WATER_PROTECTOR') {
      icon = Icons.shield_moon_rounded;
      primaryColor = AppColors.turquoise;
      xpBonus = 100;
    } else if (code == 'SEVEN_DAY_STREAK' || visualKey == 'BADGE_SEVEN_STREAK') {
      icon = Icons.local_fire_department_rounded;
      primaryColor = AppColors.gold;
      xpBonus = 150;
    } else if (code == 'ECOSYSTEM_EXPLORER' || visualKey == 'BADGE_ECOSYSTEM_EXPLORER') {
      icon = Icons.public_rounded;
      primaryColor = AppColors.emerald;
      xpBonus = 200;
    } else if (code == 'XP_MASTER' || visualKey == 'BADGE_XP_MASTER') {
      icon = Icons.military_tech_rounded;
      primaryColor = AppColors.goldDark;
      xpBonus = 250;
    } else if (code == 'LEVEL_UP_3' || visualKey == 'BADGE_LEVEL_3') {
      icon = Icons.waves_rounded;
      primaryColor = const Color(0xFF0288D1);
      xpBonus = 150;
    } else {
      icon = Icons.emoji_events_rounded;
      primaryColor = AppColors.forestGreen;
      xpBonus = 100;
    }

    String? formattedDate;
    if (achievement.unlockedAt != null) {
      final dt = achievement.unlockedAt!;
      final months = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ];
      formattedDate = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    }

    return BadgeModel(
      id: achievement.code.toLowerCase(),
      title: achievement.title,
      description: achievement.description,
      icon: icon,
      primaryColor: primaryColor,
      isUnlocked: achievement.isUnlocked,
      dateUnlocked: formattedDate,
      xpBonus: xpBonus,
    );
  }
}
