import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/models/badge_model.dart';

/// Modal interactivo de detalle de insignia mostrando la insignia en gran formato,
/// fecha de obtención, descripción de logros y recompensa de XP.
class BadgeDetailModal extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback onClose;

  const BadgeDetailModal({
    super.key,
    required this.badge,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.all(AppDimensions.space24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: AppShadows.card,
            border: Border.all(
              color: badge.isUnlocked ? badge.primaryColor : AppColors.lightGrey,
              width: 2.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón cerrar en la esquina superior derecha
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.lightGrey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, size: 20, color: AppColors.darkGrey),
                  ),
                ),
              ),

              // Gran insignia
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: badge.primaryColor.withOpacity(0.4),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [badge.primaryColor.withOpacity(0.8), badge.primaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppColors.white, width: 4.5),
                    ),
                    child: Icon(badge.icon, size: 48, color: AppColors.white),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.space16),

              // Nombre de la insignia
              Text(
                badge.title,
                style: AppTypography.headingLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              // Píldora de XP
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  border: Border.all(color: AppColors.gold, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: AppColors.goldDark, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '+${badge.xpBonus} XP',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.goldDark,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.space16),

              // Descripción
              Text(
                badge.description,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),

              if (badge.dateUnlocked != null) ...[
                const SizedBox(height: AppDimensions.space12),
                Text(
                  'Obtenida el ${badge.dateUnlocked}',
                  style: AppTypography.caption.copyWith(color: AppColors.mediumGrey),
                ),
              ],

              const SizedBox(height: AppDimensions.space24),

              AppButton(
                label: '¡INCREÍBLE!',
                variant: AppButtonVariant.primary,
                height: 48,
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
