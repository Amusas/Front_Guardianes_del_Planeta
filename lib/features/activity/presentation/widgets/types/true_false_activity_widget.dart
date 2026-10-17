import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../domain/models/activity_model.dart';

class TrueFalseActivityWidget extends StatelessWidget {
  final ActivityModel activity;
  final dynamic currentAnswer;
  final bool isChecked;
  final bool? isCorrect;
  final ValueChanged<dynamic> onAnswerSelected;

  const TrueFalseActivityWidget({
    super.key,
    required this.activity,
    required this.currentAnswer,
    required this.isChecked,
    required this.isCorrect,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Respuesta seleccionada (0: Verdadero, 1: Falso, o String)
    final bool? selectedValue = (currentAnswer is int)
        ? (currentAnswer == 0 ? true : false)
        : (currentAnswer is String
            ? (currentAnswer.toString().toLowerCase().startsWith('v') ? true : false)
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjeta con el Enunciado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: AppShadows.card,
            border: Border.all(color: AppColors.turquoiseLight, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.rule_rounded, size: 14, color: AppColors.turquoise),
                    const SizedBox(width: 4),
                    Text(
                      '¿Es Verdadero o Falso?',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.turquoise,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                activity.questionOrInstruction,
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.darkText,
                  fontSize: 18,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.space24),

        // Dos tarjetas grandes e intuitivas para niños
        Row(
          children: [
            // Opción: VERDADERO
            Expanded(
              child: _buildChoiceCard(
                label: 'VERDADERO',
                isTrueCard: true,
                isSelected: selectedValue == true,
                icon: Icons.check_circle_outline_rounded,
                selectedIcon: Icons.check_circle_rounded,
                baseColor: AppColors.emerald,
                onTap: isChecked && isCorrect == true
                    ? null
                    : () => onAnswerSelected(0),
              ),
            ),
            const SizedBox(width: 14),

            // Opción: FALSO
            Expanded(
              child: _buildChoiceCard(
                label: 'FALSO',
                isTrueCard: false,
                isSelected: selectedValue == false,
                icon: Icons.highlight_off_rounded,
                selectedIcon: Icons.cancel_rounded,
                baseColor: const Color(0xFFE53935),
                onTap: isChecked && isCorrect == true
                    ? null
                    : () => onAnswerSelected(1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceCard({
    required String label,
    required bool isTrueCard,
    required bool isSelected,
    required IconData icon,
    required IconData selectedIcon,
    required Color baseColor,
    required VoidCallback? onTap,
  }) {
    Color cardBg = AppColors.white;
    Color border = AppColors.lightGrey;
    Color accentColor = AppColors.darkGrey;

    if (isSelected) {
      if (isChecked && isCorrect != null) {
        if (isCorrect!) {
          cardBg = const Color(0xFFE8F5E9);
          border = AppColors.emerald;
          accentColor = AppColors.emerald;
        } else {
          cardBg = const Color(0xFFFFEBEE);
          border = const Color(0xFFE53935);
          accentColor = const Color(0xFFE53935);
        }
      } else {
        // Seleccionado sin comprobar: AZUL
        cardBg = const Color(0xFFE3F2FD);
        border = const Color(0xFF1E88E5);
        accentColor = const Color(0xFF1E88E5);
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: isSelected ? AppShadows.card : AppShadows.small,
            border: Border.all(color: border, width: isSelected ? 2.5 : 1.4),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor.withValues(alpha: 0.15) : AppColors.offWhite,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? accentColor : AppColors.darkGrey,
                  size: 38,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? accentColor : AppColors.darkText,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
