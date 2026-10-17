import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/badge_model.dart';
import '../../data/badges_mock_data.dart';
import '../controllers/child_profile_controller.dart';
import '../../../exploration/presentation/controllers/lesson_controller.dart';
import '../widgets/badge_card.dart';
import '../widgets/badge_detail_modal.dart';
import '../../domain/models/avatar_config.dart';
import '../widgets/child_avatar_widget.dart';
import '../widgets/avatar_customizer_modal.dart';

class ProfileRewardsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ProfileRewardsScreen({super.key, required this.onBack});

  @override
  State<ProfileRewardsScreen> createState() => _ProfileRewardsScreenState();
}

class _ProfileRewardsScreenState extends State<ProfileRewardsScreen> {
  final List<BadgeModel> _badges = BadgesMockData.badges;
  BadgeModel? _selectedBadge;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          context.read<ChildProfileController>().loadProfile();
        } catch (_) {}
        try {
          context.read<LessonController>().loadUserProgress();
        } catch (_) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ChildProfileController? childProfile;
    try {
      childProfile = context.watch<ChildProfileController>();
    } catch (_) {
      childProfile = null;
    }

    LessonController? lessonController;
    try {
      lessonController = context.watch<LessonController>();
    } catch (_) {
      lessonController = null;
    }

    final totalXp = childProfile?.totalXp ?? 0;
    final levelNumber = childProfile?.levelNumber ?? 1;
    final levelName = childProfile?.levelName ?? 'Semilla Guardiana';
    final nextLevelXp = childProfile?.nextLevelRequiredXp ?? 500;
    final progressRatio = childProfile?.levelProgressRatio ?? 0.0;
    final percentageText = '${(progressRatio * 100).toInt()}%';
    final completedLessonsCount = lessonController?.completedLessonIds.length ?? 0;

    final List<BadgeModel> displayBadges = (childProfile?.badges != null && childProfile!.badges.isNotEmpty)
        ? childProfile.badges
        : _badges;
    final int actualUnlockedCount = childProfile?.unlockedAchievementsCount ?? displayBadges.where((b) => b.isUnlocked).length;
    final int totalAchievementsCount = childProfile?.totalAchievementsCount ?? displayBadges.length;

    return Scaffold(
      backgroundColor: AppColors.pastelGreenBg,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppDimensions.space12),

                  // Header con botón volver y título
                  Row(
                    children: [
                      InkWell(
                        onTap: widget.onBack,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.small,
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: AppColors.forestGreen),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Mi Perfil de Guardián',
                          style: AppTypography.headingMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 40), // Balance visual con el botón atrás
                    ],
                  ),

                  const SizedBox(height: AppDimensions.space20),

                  // 1. Avatar Grande con XP Progress Ring Real
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Anillo de progreso de XP (Ring)
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: CircularProgressIndicator(
                          value: progressRatio,
                          strokeWidth: 8.0,
                          backgroundColor: AppColors.lightGrey,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                          strokeCap: StrokeCap.round,
                        ),
                      ),

                      // Avatar personalizado del niño (interactivo)
                      GestureDetector(
                        onTap: () => _openAvatarCustomizer(context, childProfile),
                        child: ChildAvatarWidget(
                          config: childProfile?.avatarConfig ?? AvatarConfig.defaultConfig(),
                          size: 104,
                          borderWidth: 4,
                        ),
                      ),

                      // Badge de porcentaje real
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                            border: Border.all(color: AppColors.white, width: 2),
                            boxShadow: AppShadows.small,
                          ),
                          child: Text(
                            percentageText,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.darkText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.space16),

                  // Nivel y Título de aventurero real
                  Text(
                    'Nivel $levelNumber',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.forestGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    levelName,
                    style: AppTypography.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    levelNumber >= 6
                        ? '$totalXp XP (Nivel Máximo)'
                        : '$totalXp / $nextLevelXp XP para Nivel ${levelNumber + 1}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space12),

                  // Botón Personalizar avatar
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.forestGreen,
                      side: const BorderSide(color: AppColors.forestGreen, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    ),
                    icon: const Icon(Icons.palette_rounded, size: 18),
                    label: const Text(
                      'Personalizar avatar',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onPressed: () => _openAvatarCustomizer(context, childProfile),
                  ),

                  const SizedBox(height: AppDimensions.space24),

                  // 2. Tres Tarjetas Pequeñas de Estadísticas Reales
                  Row(
                    children: [
                      _buildStatCard(
                        title: 'XP Total',
                        value: '$totalXp',
                        icon: Icons.star_rounded,
                        accentColor: AppColors.goldDark,
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      _buildStatCard(
                        title: 'Lecciones',
                        value: '$completedLessonsCount',
                        icon: Icons.menu_book_rounded,
                        accentColor: AppColors.forestGreen,
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      _buildStatCard(
                        title: 'Insignias',
                        value: '$actualUnlockedCount',
                        icon: Icons.military_tech_rounded,
                        accentColor: AppColors.emerald,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.space32),

                  // 3. Grid de Insignias (2 Columnas)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mis Insignias',
                        style: AppTypography.headingLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        ),
                        child: Text(
                          '$actualUnlockedCount / ${displayBadges.length} Obtenidas',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.forestGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.space16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: displayBadges.length,
                    itemBuilder: (context, index) {
                      final badge = displayBadges[index];
                      return BadgeCard(
                        badge: badge,
                        onTap: () {
                          setState(() {
                            _selectedBadge = badge;
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: AppDimensions.space40),
                ],
              ),
            ),
          ),

          // Modal de Detalle de Insignia
          if (_selectedBadge != null)
            Positioned.fill(
              child: BadgeDetailModal(
                badge: _selectedBadge!,
                onClose: () {
                  setState(() {
                    _selectedBadge = null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: accentColor),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: AppTypography.caption.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openAvatarCustomizer(BuildContext context, ChildProfileController? controller) {
    if (controller == null) return;
    AvatarCustomizerModal.show(
      context: context,
      initialConfig: controller.avatarConfig,
      childLevel: controller.levelNumber,
      childName: controller.childName,
      onSave: (newConfig) {
        controller.updateAvatar(newConfig);
      },
    );
  }
}
