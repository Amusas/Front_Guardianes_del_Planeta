import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import '../constants/app_dimensions.dart';
import '../../features/profile/domain/models/avatar_config.dart';
import '../../features/profile/presentation/widgets/child_avatar_widget.dart';

/// Barra de XP gruesa, redondeada y visualmente atractiva con icono de estrella y progreso animado.
class XpBarWidget extends StatelessWidget {
  final int currentXp;
  final int targetXp;
  final bool showProgressText;
  final double height;

  const XpBarWidget({
    super.key,
    required this.currentXp,
    required this.targetXp,
    this.showProgressText = false,
    this.height = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final double ratio = (currentXp / targetXp).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
            boxShadow: AppShadows.small,
          ),
          padding: const EdgeInsets.all(3.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              return Stack(
                children: [
                  // Barra de progreso
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    width: maxWidth * ratio,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.goldLight, AppColors.gold, AppColors.goldDark],
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  // Brillo blanco sutil en la mitad superior de la barra
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: height * 0.35,
                        width: maxWidth * ratio,
                        color: AppColors.white.withOpacity(0.35),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        if (showProgressText) ...[
          const SizedBox(height: 4),
          Text(
            '$currentXp / $targetXp XP',
            style: AppTypography.caption.copyWith(
              color: AppColors.forestGreenDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

/// Header flotante reutilizable para la experiencia infantil:
/// Avatar + Nivel + Barra de XP + Contador de XP (con icono de estrella).
class FloatingGameHeader extends StatelessWidget {
  final String childName;
  final int level;
  final int currentXp;
  final int targetXp;
  final VoidCallback? onProfileTap;
  final AvatarConfig? avatarConfig;

  const FloatingGameHeader({
    super.key,
    this.childName = 'Andrés',
    this.level = 5,
    this.currentXp = 1250,
    this.targetXp = 2000,
    this.onProfileTap,
    this.avatarConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.pastelGreen, width: 1.5),
      ),
      child: Row(
        children: [
          // Avatar interactivo
          GestureDetector(
            onTap: onProfileTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ChildAvatarWidget(
                  config: avatarConfig ?? AvatarConfig.defaultConfig(),
                  size: 46,
                  borderWidth: 2,
                ),
                // Badge de nivel superpuesto
                Positioned(
                  bottom: -2,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                      border: Border.all(color: AppColors.white, width: 1.5),
                    ),
                    child: Text(
                      'Nv.$level',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.space12),

          // Barra central de progreso
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nivel $level',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.forestGreenDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$currentXp / $targetXp XP',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                XpBarWidget(currentXp: currentXp, targetXp: targetXp, height: 12),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.space12),

          // Píldora de XP destacada
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.18),
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              border: Border.all(color: AppColors.gold, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.goldDark,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '$currentXp',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.goldDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
