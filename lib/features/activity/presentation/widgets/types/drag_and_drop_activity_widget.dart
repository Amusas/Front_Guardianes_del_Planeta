import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../domain/models/activity_model.dart';

class DragAndDropActivityWidget extends StatelessWidget {
  final ActivityModel activity;
  final dynamic currentAnswer;
  final bool isChecked;
  final bool? isCorrect;
  final ValueChanged<dynamic> onAnswerSelected;

  const DragAndDropActivityWidget({
    super.key,
    required this.activity,
    required this.currentAnswer,
    required this.isChecked,
    required this.isCorrect,
    required this.onAnswerSelected,
  });

  Map<String, String> get _currentMap {
    if (currentAnswer is Map) {
      return Map<String, String>.from(
        (currentAnswer as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
      );
    }
    return {};
  }

  void _assignElementToZone(String elementId, String targetZone) {
    if (isChecked && isCorrect == true) return;
    final updated = Map<String, String>.from(_currentMap);
    updated[elementId] = targetZone;
    onAnswerSelected(updated);
  }

  @override
  Widget build(BuildContext context) {
    final targets = activity.dragTargets;
    final elements = activity.dragElements;
    final map = _currentMap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instrucción
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: AppShadows.card,
            border: Border.all(color: AppColors.turquoise.withValues(alpha: 0.4), width: 1.5),
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
                    const Icon(Icons.touch_app_rounded, size: 14, color: AppColors.turquoise),
                    const SizedBox(width: 4),
                    Text(
                      'Ubica en el Hábitat',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.turquoise,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
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

        // Elementos y sus zonas de asignación
        for (final elem in elements) ...[
          _buildElementCard(
            element: elem,
            targets: targets,
            selectedZone: map[elem['id']],
          ),
          const SizedBox(height: AppDimensions.space12),
        ],
      ],
    );
  }

  Widget _buildElementCard({
    required Map<String, String> element,
    required List<Map<String, String>> targets,
    required String? selectedZone,
  }) {
    final elemId = element['id'] ?? '';
    final elemName = element['name'] ?? '';

    Color cardBorder = AppColors.lightGrey;
    Color activeChipColor = AppColors.turquoise;
    Color activeChipBorder = const Color(0xFF004D40);
    IconData activeIcon = Icons.place_rounded;

    if (selectedZone != null) {
      if (isChecked && isCorrect != null) {
        if (isCorrect!) {
          cardBorder = AppColors.emerald;
          activeChipColor = AppColors.emerald;
          activeChipBorder = AppColors.forestGreenDark;
          activeIcon = Icons.check_circle_rounded;
        } else {
          cardBorder = const Color(0xFFE53935);
          activeChipColor = const Color(0xFFE53935);
          activeChipBorder = const Color(0xFFB71C1C);
          activeIcon = Icons.cancel_rounded;
        }
      } else {
        // Seleccionado sin comprobar: AZUL
        cardBorder = const Color(0xFF1E88E5);
        activeChipColor = const Color(0xFF1E88E5);
        activeChipBorder = const Color(0xFF1565C0);
        activeIcon = Icons.place_rounded;
      }
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: AppShadows.small,
        border: Border.all(
          color: selectedZone != null ? cardBorder : AppColors.lightGrey,
          width: selectedZone != null ? 1.8 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: selectedZone != null
                      ? cardBorder.withValues(alpha: 0.12)
                      : const Color(0xFFE0F2F1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.eco_rounded,
                  size: 16,
                  color: selectedZone != null ? cardBorder : AppColors.turquoise,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  elemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppColors.darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Selector de zonas de destino
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: targets.map((target) {
              final zone = target['zone'] ?? '';
              final zoneName = target['name'] ?? '';
              final isSelected = selectedZone == zone;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  onTap: () => _assignElementToZone(elemId, zone),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? activeChipColor : AppColors.offWhite,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                      border: Border.all(
                        color: isSelected ? activeChipBorder : AppColors.lightGrey,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? activeIcon : Icons.radio_button_unchecked_rounded,
                          size: 15,
                          color: isSelected ? AppColors.white : AppColors.darkGrey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          zoneName,
                          style: TextStyle(
                            color: isSelected ? AppColors.white : AppColors.darkText,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
