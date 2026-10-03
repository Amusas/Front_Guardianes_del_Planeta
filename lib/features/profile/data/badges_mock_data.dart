import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../domain/models/badge_model.dart';

class BadgesMockData {
  static final List<BadgeModel> badges = [
    const BadgeModel(
      id: 'water_protector',
      title: 'Protector del Agua',
      description: 'Completaste todas las actividades relacionadas con el cuidado y preservación de ríos y fuentes hídricas.',
      icon: Icons.shield_moon_rounded, // Combinación gota + escudo
      primaryColor: AppColors.turquoise,
      isUnlocked: true,
      dateUnlocked: '18 Sep 2026',
      xpBonus: 100,
    ),
    const BadgeModel(
      id: 'bear_friend',
      title: 'Amigo del Oso',
      description: 'Descubriste el hábitat natural del oso de anteojos en el Bosque Andino y aprendiste a protegerlo.',
      icon: Icons.cruelty_free_rounded,
      primaryColor: AppColors.forestGreen,
      isUnlocked: true,
      dateUnlocked: '15 Sep 2026',
      xpBonus: 100,
    ),
    const BadgeModel(
      id: 'forest_guardian',
      title: 'Guardián de Bosques',
      description: 'Sembraste árboles nativos virtuales y evitaste la deforestación de palmas de cera.',
      icon: Icons.forest_rounded,
      primaryColor: AppColors.emerald,
      isUnlocked: true,
      dateUnlocked: '10 Sep 2026',
      xpBonus: 100,
    ),
    const BadgeModel(
      id: 'expert_recycler',
      title: 'Reciclador Experto',
      description: 'Clasificaste correctamente 50 residuos orgánicos, plásticos y vidrios en las estaciones ecológicas.',
      icon: Icons.recycling_rounded,
      primaryColor: AppColors.gold,
      isUnlocked: true,
      dateUnlocked: '05 Sep 2026',
      xpBonus: 100,
    ),
    const BadgeModel(
      id: 'condor_legendary',
      title: '???',
      description: 'Insignia secreta. Explora más senderos del Páramo para revelar este misterio.',
      icon: Icons.lock_rounded,
      primaryColor: AppColors.mediumGrey,
      isUnlocked: false,
      xpBonus: 150,
    ),
    const BadgeModel(
      id: 'ocean_master',
      title: '???',
      description: 'Insignia secreta. Desbloquea el Ecosistema Océano para obtenerla.',
      icon: Icons.lock_rounded,
      primaryColor: AppColors.mediumGrey,
      isUnlocked: false,
      xpBonus: 200,
    ),
  ];
}
