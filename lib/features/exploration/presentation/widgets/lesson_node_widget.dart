import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/lesson_node_model.dart';

/// Nodo de actividad circular interactivo con estados:
/// - Completado (Dorado con check y corona de estrellas)
/// - Activo (Verde brillante con animación de pulso y anillos de energía)
/// - Bloqueado (Grisáceo con candado)
class LessonNodeWidget extends StatefulWidget {
  final LessonNodeModel node;
  final VoidCallback onTap;

  static double getNodeRadius(bool isActive) => isActive ? 40.0 : 36.0;
  static double getNodeSize(bool isActive) => getNodeRadius(isActive) * 2;

  const LessonNodeWidget({
    super.key,
    required this.node,
    required this.onTap,
  });

  @override
  State<LessonNodeWidget> createState() => _LessonNodeWidgetState();
}

class _LessonNodeWidgetState extends State<LessonNodeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    if (widget.node.state == LessonNodeState.active) {
      _pulseController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final bool isActive = node.state == LessonNodeState.active;
    final bool isCompleted = node.state == LessonNodeState.completed;
    final bool isLocked = node.state == LessonNodeState.locked;

    final double nodeSize = LessonNodeWidget.getNodeSize(isActive);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: isLocked ? null : widget.onTap,
          child: SizedBox(
            width: nodeSize,
            height: nodeSize,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Ondas de radar expansivas concéntricas continuas (sin cortes de clipping)
                if (isActive)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final double progress1 = _pulseController.value;
                      final double progress2 = (_pulseController.value + 0.5) % 1.0;

                      final double scale1 = 1.0 + (progress1 * 0.55);
                      final double opacity1 = ((1.0 - progress1) * 0.55).clamp(0.0, 1.0);

                      final double scale2 = 1.0 + (progress2 * 0.55);
                      final double opacity2 = ((1.0 - progress2) * 0.55).clamp(0.0, 1.0);

                      return Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Onda radar 1
                          Transform.scale(
                            scale: scale1,
                            child: Container(
                              width: nodeSize,
                              height: nodeSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.emerald.withValues(alpha: opacity1),
                                  width: 2.8,
                                ),
                              ),
                            ),
                          ),
                          // Onda radar 2 (desfasada suavemente)
                          Transform.scale(
                            scale: scale2,
                            child: Container(
                              width: nodeSize,
                              height: nodeSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.emerald.withValues(alpha: opacity2),
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                // Sombra / Glow exterior del nodo
                Container(
                  width: nodeSize,
                  height: nodeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.emerald.withValues(alpha: 0.45),
                              blurRadius: 18,
                              spreadRadius: 3,
                            ),
                          ]
                        : isCompleted
                            ? AppShadows.goldGlow
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                  ),
                ),

                // Cuerpo principal del nodo
                Container(
                  width: nodeSize,
                  height: nodeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isCompleted
                        ? AppColors.goldRewardGradient
                        : isActive
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF52B788), Color(0xFF2D6A4F)],
                              )
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFCBD5E1), Color(0xFF94A3B8)],
                              ),
                    border: Border.all(
                      color: AppColors.white,
                      width: isActive ? 4.5 : 3.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isLocked
                          ? Icons.lock_rounded
                          : isCompleted
                              ? Icons.check_circle_rounded
                              : node.icon,
                      size: isActive ? 38 : 32,
                      color: isCompleted
                          ? AppColors.white
                          : isActive
                              ? AppColors.white
                              : const Color(0xFF475569),
                    ),
                  ),
                ),

                // Pequeño indicador de completado (corona vegetal / estrellas)
                if (isCompleted)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.emerald,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.white,
                      ),
                    ),
                  ),

                // Indicador "¡Jugar!" en nodo activo
                if (isActive)
                  Positioned(
                    bottom: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        border: Border.all(color: AppColors.white, width: 2),
                        boxShadow: AppShadows.small,
                      ),
                      child: const Text(
                        '¡JUGAR!',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.darkText,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Nombre de la lección
        Container(
          constraints: const BoxConstraints(maxWidth: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: AppShadows.small,
            border: Border.all(
              color: isLocked ? AppColors.lightGrey : AppColors.pastelGreen,
              width: 1.0,
            ),
          ),
          child: Text(
            node.title,
            style: AppTypography.caption.copyWith(
              color: isLocked ? AppColors.mediumGrey : AppColors.darkText,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
