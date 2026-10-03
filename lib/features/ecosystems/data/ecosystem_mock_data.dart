import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../domain/models/ecosystem_model.dart';

class EcosystemMockData {
  static final List<EcosystemModel> ecosystems = [
    const EcosystemModel(
      id: 'paramo',
      name: 'El Páramo',
      subtitle: 'Tierra de niebla y frailejones',
      description: 'Descubre los gigantes guardianes del agua y lagunas sagradas en las altas cumbres.',
      backgroundGradient: AppColors.paramoGradient,
      primaryColor: AppColors.bluishGrey,
      secondaryColor: AppColors.iceBlue,
      isLocked: false,
      progress: 0.30,
      totalActivities: 10,
      completedActivities: 3,
      mainIcon: Icons.cloud_queue_rounded,
    ),
    const EcosystemModel(
      id: 'bosque_andino',
      name: 'Bosque Andino',
      subtitle: 'El hogar del oso de anteojos',
      description: 'Explora senderos mágicos, palmas de cera gigantes y ríos cristalinos llenos de vida.',
      backgroundGradient: AppColors.forestGradient,
      primaryColor: AppColors.forestGreen,
      secondaryColor: AppColors.emerald,
      isLocked: false,
      progress: 0.70,
      totalActivities: 12,
      completedActivities: 4,
      mainIcon: Icons.forest_rounded,
    ),
    const EcosystemModel(
      id: 'oceano',
      name: 'Océano Pacífico',
      subtitle: 'Arrecifes y gigantes marinos',
      description: 'Nada junto a tortugas marinas y protege los arrecifes de coral de los residuos.',
      backgroundGradient: AppColors.oceanGradient,
      primaryColor: AppColors.turquoiseDark,
      secondaryColor: AppColors.turquoise,
      isLocked: true,
      progress: 0.0,
      totalActivities: 15,
      completedActivities: 0,
      mainIcon: Icons.waves_rounded,
    ),
  ];
}
