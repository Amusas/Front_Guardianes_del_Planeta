import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../domain/models/activity_model.dart';

class MultipleChoiceActivityWidget extends StatelessWidget {
  final ActivityModel activity;
  final dynamic currentAnswer;
  final bool isChecked;
  final bool? isCorrect;
  final ValueChanged<dynamic> onAnswerSelected;

  const MultipleChoiceActivityWidget({
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
    final selectedIdx = (currentAnswer is int)
        ? currentAnswer as int
        : (currentAnswer is String ? options.indexOf(currentAnswer as String) : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjeta con la Pregunta
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: AppShadows.card,
            border: Border.all(color: AppColors.pastelGreen, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.pastelGreenBg,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.help_outline_rounded, size: 14, color: AppColors.forestGreen),
                        const SizedBox(width: 4),
                        Text(
                          'Pregunta',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.forestGreenDark,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

        // Opciones interactivas
        for (int i = 0; i < options.length; i++) ...[
          _buildOptionCard(
            index: i,
            text: options[i],
            isSelected: selectedIdx == i,
            letter: String.fromCharCode(65 + i),
          ),
          const SizedBox(height: AppDimensions.space12),
        ],
      ],
    );
  }

  Widget _buildOptionCard({
    required int index,
    required String text,
    required bool isSelected,
    required String letter,
  }) {
    Color bgColor = AppColors.white;
    Color borderColor = AppColors.lightGrey;
    Color badgeColor = AppColors.offWhite;
    Color textColor = AppColors.darkText;
    Widget? trailingIcon;

    if (isSelected) {
      if (isChecked && isCorrect != null) {
        if (isCorrect!) {
          bgColor = const Color(0xFFE8F5E9);
          borderColor = AppColors.emerald;
          badgeColor = AppColors.emerald;
          trailingIcon = const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 24);
        } else {
          bgColor = const Color(0xFFFFEBEE);
          borderColor = const Color(0xFFE53935);
          badgeColor = const Color(0xFFE53935);
          trailingIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFE53935), size: 24);
        }
      } else {
        // Seleccionado sin comprobar: AZUL
        bgColor = const Color(0xFFE3F2FD);
        borderColor = const Color(0xFF1E88E5);
        badgeColor = const Color(0xFF1E88E5);
        trailingIcon = const Icon(Icons.radio_button_checked_rounded, color: Color(0xFF1E88E5), size: 24);
      }
    } else {
      trailingIcon = const Icon(Icons.radio_button_off_rounded, color: AppColors.darkGrey, size: 24);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        onTap: isChecked && isCorrect == true ? null : () => onAnswerSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: isSelected ? AppShadows.card : AppShadows.small,
            border: Border.all(color: borderColor, width: isSelected ? 2.2 : 1.2),
          ),
          child: Row(
            children: [
              // Insignia con la letra (A, B, C...)
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.darkText,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Texto de la opción
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.bodyLarge.copyWith(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(width: 8),
              trailingIcon,
            ],
          ),
        ),
      ),
    );
  }
}
