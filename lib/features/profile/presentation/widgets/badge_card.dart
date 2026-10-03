import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/badge_model.dart';

/// Tarjeta de insignia en cuadrícula de 2 columnas con soporte para
/// insignias desbloqueadas (coloridas, brillantes, estrellas) y bloqueadas (gris, candado, ???).
class BadgeCard extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onTap;

  const BadgeCard({
    super.key,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: badge.isUnlocked ? AppShadows.card : AppShadows.small,
          border: Border.all(
            color: badge.isUnlocked
                ? badge.primaryColor.withOpacity(0.3)
                : AppColors.lightGrey,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Insignia circular destacada
            Stack(
              alignment: Alignment.center,
              children: [
                // Glow exterior para insignias obtenidas
                if (badge.isUnlocked)
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: badge.primaryColor.withOpacity(0.35),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),

                // Círculo principal del blasón
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: badge.isUnlocked
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              badge.primaryColor.withOpacity(0.85),
                              badge.primaryColor,
                            ],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
                          ),
                    border: Border.all(
                      color: badge.isUnlocked ? AppColors.white : const Color(0xFF94A3B8),
                      width: 3.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      badge.icon,
                      size: 34,
                      color: badge.isUnlocked ? AppColors.white : AppColors.darkGrey.withOpacity(0.5),
                    ),
                  ),
                ),

                // Pequeña estrella de distinción si está desbloqueada
                if (badge.isUnlocked)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.star_rounded, size: 14, color: AppColors.white),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppDimensions.space12),

            // Título de la insignia
            Text(
              badge.title,
              style: AppTypography.subheading.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: badge.isUnlocked ? AppColors.darkText : AppColors.mediumGrey,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Recompensa XP
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? AppColors.gold.withOpacity(0.18)
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
              child: Text(
                badge.isUnlocked ? '+${badge.xpBonus} XP' : 'Bloqueado',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: badge.isUnlocked ? AppColors.goldDark : AppColors.mediumGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
