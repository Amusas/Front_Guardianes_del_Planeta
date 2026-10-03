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
  late Animation<double> _pulseScale;
  late Animation<double> _pulseAlpha;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
    _pulseAlpha = Tween<double>(begin: 0.6, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
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

    final double nodeSize = isActive ? 84.0 : 72.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isLocked ? null : widget.onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Anillos de energía pulsante para el nodo ACTIVO
              if (isActive)
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseScale.value,
                      child: Container(
                        width: nodeSize + 20,
                        height: nodeSize + 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.emerald.withOpacity(_pulseAlpha.value),
                            width: 4,
                          ),
                        ),
                      ),
                    );
                  },
                ),

              // Sombra / Glow exterior
              Container(
                width: nodeSize,
                height: nodeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.emerald.withOpacity(0.5),
                            blurRadius: 22,
                            spreadRadius: 4,
                          ),
                        ]
                      : isCompleted
                          ? AppShadows.goldGlow
                          : [],
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
                    size: isActive ? 40 : 34,
                    color: isCompleted
                        ? AppColors.white
                        : isActive
                            ? AppColors.white
                            : AppColors.darkGrey,
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
                  bottom: -4,
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

        const SizedBox(height: 8),

        // Nombre de la lección
        Container(
          constraints: const BoxConstraints(maxWidth: 160),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: AppShadows.small,
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
