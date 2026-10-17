import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../domain/models/activity_model.dart';

class GenericActivityWidget extends StatelessWidget {
  final ActivityModel activity;
  final dynamic currentAnswer;
  final bool isChecked;
  final bool? isCorrect;
  final ValueChanged<dynamic> onAnswerSelected;

  const GenericActivityWidget({
    super.key,
    required this.activity,
    required this.currentAnswer,
    required this.isChecked,
    required this.isCorrect,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = activity.stringOptions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjeta con Título e Instrucción
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: AppShadows.card,
            border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.pastelGreenBg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: Text(
                  activity.type.displayName,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.forestGreenDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                activity.questionOrInstruction,
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.darkText,
                  fontSize: 18,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.space20),

        if (options.isNotEmpty) ...[
          for (int i = 0; i < options.length; i++) ...[
            Builder(
              builder: (context) {
                final isSelected = currentAnswer == options[i];
                Color itemBg = AppColors.white;
                Color itemBorder = AppColors.lightGrey;
                Color itemAccent = AppColors.darkGrey;
                IconData itemIcon = Icons.radio_button_unchecked_rounded;

                if (isSelected) {
                  if (isChecked && isCorrect != null) {
                    if (isCorrect!) {
                      itemBg = const Color(0xFFE8F5E9);
                      itemBorder = AppColors.emerald;
                      itemAccent = AppColors.emerald;
                      itemIcon = Icons.check_circle_rounded;
                    } else {
                      itemBg = const Color(0xFFFFEBEE);
                      itemBorder = const Color(0xFFE53935);
                      itemAccent = const Color(0xFFE53935);
                      itemIcon = Icons.cancel_rounded;
                    }
                  } else {
                    // Seleccionado sin comprobar: AZUL
                    itemBg = const Color(0xFFE3F2FD);
                    itemBorder = const Color(0xFF1E88E5);
                    itemAccent = const Color(0xFF1E88E5);
                    itemIcon = Icons.radio_button_checked_rounded;
                  }
                }

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                    onTap: isChecked && isCorrect == true ? null : () => onAnswerSelected(options[i]),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: itemBg,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                        border: Border.all(
                          color: itemBorder,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            itemIcon,
                            color: itemAccent,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              options[i],
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                fontSize: 15,
                                color: isSelected && !isChecked
                                    ? const Color(0xFF0D47A1)
                                    : AppColors.darkText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ] else ...[
          // Si no hay opciones, botón táctil de confirmación
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              onTap: () => onAnswerSelected('COMPLETED'),
              child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: currentAnswer != null ? AppColors.pastelGreenBg : AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(
                  color: currentAnswer != null ? AppColors.emerald : AppColors.lightGrey,
                  width: 1.5,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_rounded, color: AppColors.emerald),
                  SizedBox(width: 8),
                  Text(
                    'Entendido y listo para continuar',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
