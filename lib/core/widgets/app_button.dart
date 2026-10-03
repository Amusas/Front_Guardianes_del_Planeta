import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import '../constants/app_dimensions.dart';

enum AppButtonVariant { primary, secondary, gold, outline }

/// Botón interactivo con microinteracción de escala al pulsar (0.96) y sombra suave.
/// Cumple con accesibilidad infantil (touch target >= 48px).
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool isLoading;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height = AppDimensions.buttonHeight,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (widget.onPressed == null) return AppColors.locked;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.forestGreen;
      case AppButtonVariant.secondary:
        return AppColors.emerald;
      case AppButtonVariant.gold:
        return AppColors.gold;
      case AppButtonVariant.outline:
        return AppColors.white;
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null) return AppColors.darkGrey.withOpacity(0.6);
    switch (widget.variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
        return AppColors.white;
      case AppButtonVariant.gold:
        return AppColors.darkText;
      case AppButtonVariant.outline:
        return AppColors.forestGreen;
    }
  }

  List<BoxShadow> _getShadow() {
    if (widget.onPressed == null) return [];
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppShadows.button;
      case AppButtonVariant.secondary:
        return AppShadows.small;
      case AppButtonVariant.gold:
        return AppShadows.goldGlow;
      case AppButtonVariant.outline:
        return AppShadows.small;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: widget.onPressed != null ? (_) => _controller.forward() : null,
        onTapUp: widget.onPressed != null
            ? (_) {
                _controller.reverse();
                widget.onPressed!();
              }
            : null,
        onTapCancel: widget.onPressed != null ? () => _controller.reverse() : null,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: widget.variant == AppButtonVariant.outline
                ? Border.all(color: AppColors.forestGreen, width: 2.5)
                : null,
            boxShadow: _getShadow(),
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: textColor, size: 24),
                        const SizedBox(width: AppDimensions.space8),
                      ],
                      Text(
                        widget.label,
                        style: AppTypography.buttonText.copyWith(color: textColor),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
