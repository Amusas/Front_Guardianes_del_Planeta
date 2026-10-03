import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/activity_question_model.dart';

enum OptionState { normal, selected, correct, incorrect }

/// Tarjeta de opción grande e interactiva con soporte para estados:
/// normal, pressed (escala 0.96), selected, correct (verde + check) e incorrect (rojo + X).
class InteractiveOptionCard extends StatefulWidget {
  final ActivityOptionModel option;
  final String letter;
  final OptionState state;
  final VoidCallback onTap;

  const InteractiveOptionCard({
    super.key,
    required this.option,
    required this.letter,
    required this.state,
    required this.onTap,
  });

  @override
  State<InteractiveOptionCard> createState() => _InteractiveOptionCardState();
}

class _InteractiveOptionCardState extends State<InteractiveOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.state) {
      case OptionState.normal:
        return AppColors.white;
      case OptionState.selected:
        return AppColors.pastelGreenBg;
      case OptionState.correct:
        return AppColors.pastelGreen;
      case OptionState.incorrect:
        return const Color(0xFFFFE5E8);
    }
  }

  Color _getBorderColor() {
    switch (widget.state) {
      case OptionState.normal:
        return AppColors.lightGrey;
      case OptionState.selected:
        return AppColors.emerald;
      case OptionState.correct:
        return AppColors.emerald;
      case OptionState.incorrect:
        return AppColors.errorSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _animController.forward(),
        onTapUp: (_) {
          _animController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _animController.reverse(),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.space12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(
              color: _getBorderColor(),
              width: widget.state == OptionState.normal ? 1.5 : 3.0,
            ),
            boxShadow: widget.state == OptionState.correct
                ? [
                    BoxShadow(
                      color: AppColors.emerald.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : AppShadows.card,
          ),
          child: Row(
            children: [
              // Círculo de la letra (A, B, C)
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.state == OptionState.correct
                      ? AppColors.emerald
                      : widget.state == OptionState.incorrect
                          ? AppColors.errorSoft
                          : AppColors.forestGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: widget.state == OptionState.correct
                      ? const Icon(Icons.check_rounded, color: AppColors.white, size: 24)
                      : widget.state == OptionState.incorrect
                          ? const Icon(Icons.close_rounded, color: AppColors.white, size: 24)
                          : Text(
                              widget.letter,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: AppColors.forestGreen,
                              ),
                            ),
                ),
              ),

              const SizedBox(width: AppDimensions.space16),

              // Icono temático de la opción
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  boxShadow: AppShadows.small,
                ),
                child: Icon(
                  widget.option.icon,
                  size: 26,
                  color: widget.state == OptionState.correct
                      ? AppColors.emerald
                      : AppColors.forestGreenDark,
                ),
              ),

              const SizedBox(width: AppDimensions.space12),

              // Texto de la opción
              Expanded(
                child: Text(
                  widget.option.text,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: widget.state == OptionState.normal
                        ? FontWeight.w600
                        : FontWeight.w800,
                    color: AppColors.darkText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
