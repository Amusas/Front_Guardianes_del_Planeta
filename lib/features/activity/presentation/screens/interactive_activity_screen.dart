import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/mascot_widget.dart';
import '../../../../core/widgets/confetti_overlay.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../exploration/domain/models/lesson_node_model.dart';
import '../../../ecosystems/domain/models/ecosystem_model.dart';
import '../../../ecosystems/presentation/registry/ecosystem_visual_registry.dart';
import '../../domain/models/activity_model.dart';
import '../controllers/activity_controller.dart';
import '../widgets/types/activity_widget_factory.dart';
import '../../../profile/presentation/controllers/child_profile_controller.dart';
import '../../../profile/presentation/screens/level_up_celebration_screen.dart';
import '../../../profile/domain/models/avatar_config.dart';

class InteractiveActivityScreen extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback onActivityComplete;
  final int? lessonId;
  final LessonNodeModel? lesson;
  final EcosystemModel? ecosystem;

  const InteractiveActivityScreen({
    super.key,
    required this.onClose,
    required this.onActivityComplete,
    this.lessonId,
    this.lesson,
    this.ecosystem,
  });

  @override
  State<InteractiveActivityScreen> createState() => _InteractiveActivityScreenState();
}

class _InteractiveActivityScreenState extends State<InteractiveActivityScreen> {
  bool _showConfetti = false;
  Timer? _confettiTimer;

  int get _resolvedLessonId => widget.lesson?.id ?? widget.lessonId ?? 1;

  EcosystemVisualData get _ecosystemVisualData {
    final code = widget.ecosystem?.id ?? 'BOSQUE_ANDINO';
    return EcosystemVisualRegistry.getVisualData(code);
  }

  LinearGradient get _ecosystemGradient {
    return widget.ecosystem?.backgroundGradient ?? _ecosystemVisualData.backgroundGradient;
  }

  Color get _ecosystemPrimaryColor {
    return widget.ecosystem?.primaryColor ?? _ecosystemVisualData.primaryColor;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ActivityController>().loadActivities(_resolvedLessonId);
      }
    });
  }

  @override
  void didUpdateWidget(covariant InteractiveActivityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldId = oldWidget.lesson?.id ?? oldWidget.lessonId;
    final newId = widget.lesson?.id ?? widget.lessonId;
    if (newId != null && newId != oldId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ActivityController>().loadActivities(newId);
        }
      });
    }
  }

  @override
  void dispose() {
    _confettiTimer?.cancel();
    super.dispose();
  }

  Future<void> _onCheck(ActivityController controller) async {
    final isCorrect = await controller.checkAnswer();
    if (isCorrect && mounted) {
      setState(() {
        _showConfetti = true;
      });
      _confettiTimer?.cancel();
      _confettiTimer = Timer(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() {
            _showConfetti = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ActivityController>();
    final status = controller.status;

    return Container(
      decoration: BoxDecoration(
        gradient: _ecosystemGradient,
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Contenedor principal centrado estilo app móvil
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  children: [
                    // 1. Encabezado con Progreso (fijo arriba)
                    _buildHeader(controller),

                    // 2. Contenido Central desplazable (ocupa el espacio disponible)
                    Expanded(
                      child: _buildBody(controller, status),
                    ),

                    // 3. Barra de acciones inferior (fija abajo, siempre visible)
                    if (status == ActivityStatus.loaded && controller.currentActivity != null)
                      _buildBottomBar(controller),
                  ],
                ),
              ),
            ),

            // Confeti al acertar
            if (_showConfetti)
              const Positioned.fill(
                child: IgnorePointer(
                  child: ConfettiOverlay(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ActivityController controller) {
    final int currentNum = controller.currentIndex + 1;
    final int total = controller.totalActivities > 0 ? controller.totalActivities : 1;
    final double progress = controller.progressRatio;
    final xp = controller.currentActivity?.xpReward ?? 10;
    final primaryColor = _ecosystemPrimaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      child: Row(
        children: [
          // Botón cerrar
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              onTap: widget.onClose,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.small,
                ),
                child: const Icon(Icons.close_rounded, color: AppColors.darkGrey, size: 22),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space12),

          // Barra de progreso y contador
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Actividad $currentNum de $total',
                      style: AppTypography.caption.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.energy_savings_leaf_rounded, color: primaryColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '+$xp XP',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.05, 1.0),
                    minHeight: 10,
                    backgroundColor: AppColors.white.withOpacity(0.65),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ActivityController controller, ActivityStatus status) {
    if (status == ActivityStatus.loading || status == ActivityStatus.initial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MascotWidget(
              size: 90,
              expression: MascotExpression.happy,
              ecosystemCode: widget.ecosystem?.id ?? 'bosque_andino',
            ),
            const SizedBox(height: 16),
            CircularProgressIndicator(color: _ecosystemPrimaryColor),
            const SizedBox(height: 14),
            Text(
              'Preparando actividades de la lección...',
              style: AppTypography.bodyMedium.copyWith(color: _ecosystemPrimaryColor),
            ),
          ],
        ),
      );
    }

    if (status == ActivityStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MascotWidget(
                size: 85,
                expression: MascotExpression.worried,
                ecosystemCode: widget.ecosystem?.id ?? 'bosque_andino',
              ),
              const SizedBox(height: 16),
              Text(
                '¡Ups! Ocurrió un inconveniente',
                style: AppTypography.headingMedium.copyWith(color: AppColors.darkText),
              ),
              const SizedBox(height: 8),
              Text(
                controller.errorMessage ?? 'No fue posible cargar las actividades.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'REINTENTAR',
                icon: Icons.refresh_rounded,
                onPressed: () => controller.loadActivities(_resolvedLessonId),
              ),
            ],
          ),
        ),
      );
    }

    if (status == ActivityStatus.completed) {
      return _buildCompletionScreen(controller);
    }

    final currentActivity = controller.currentActivity;
    if (currentActivity == null) {
      return const Center(child: Text('No hay actividad disponible'));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(AppDimensions.space20, 10, AppDimensions.space20, AppDimensions.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner temático de misión ambiental
          _buildMissionBanner(currentActivity, controller.isAnswerCorrect == true),
          const SizedBox(height: AppDimensions.space16),

          // Renderizador dinámico y desacoplado según el tipo de actividad
          ActivityWidgetFactory(
            activity: currentActivity,
            currentAnswer: controller.currentAnswer,
            isChecked: controller.isAnswerChecked,
            isCorrect: controller.isAnswerCorrect,
            onAnswerSelected: (answer) => controller.setAnswer(answer),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionBanner(ActivityModel activity, bool isResolved) {
    final primaryColor = _ecosystemPrimaryColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: AppShadows.small,
        border: Border.all(
          color: isResolved ? AppColors.emerald : primaryColor.withOpacity(0.35),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isResolved ? const Color(0xFFE8F5E9) : primaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isResolved ? Icons.check_circle_rounded : _getActivityIcon(activity.type),
              color: isResolved ? AppColors.emerald : primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isResolved ? AppColors.emerald : primaryColor,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                      ),
                      child: Text(
                        activity.type.displayName,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isResolved ? '¡Misión Cumplida!' : 'Misión de Exploración',
                        style: TextStyle(
                          color: isResolved ? AppColors.emerald : primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity.title.isNotEmpty ? activity.title : 'Protege la biodiversidad de Colombia',
                  style: const TextStyle(
                    color: AppColors.darkText,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              border: Border.all(color: AppColors.gold, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.energy_savings_leaf_rounded, size: 14, color: AppColors.emerald),
                const SizedBox(width: 3),
                Text(
                  '+${activity.xpReward} XP',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    color: AppColors.forestGreenDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.multipleChoice:
        return Icons.quiz_rounded;
      case ActivityType.trueFalse:
        return Icons.rule_rounded;
      case ActivityType.classification:
        return Icons.category_rounded;
      case ActivityType.ordering:
        return Icons.sort_rounded;
      case ActivityType.dragAndDrop:
        return Icons.touch_app_rounded;
      case ActivityType.unknown:
        return Icons.eco_rounded;
    }
  }

  Widget _buildBottomBar(ActivityController controller) {
    final isChecked = controller.isAnswerChecked;
    final isCorrect = controller.isAnswerCorrect;
    final primaryColor = _ecosystemPrimaryColor;

    MascotExpression mascotExpression = MascotExpression.smiling;
    String feedbackText = '¡Selecciona o completa la actividad para proteger el planeta!';

    if (isChecked) {
      if (isCorrect == true) {
        mascotExpression = MascotExpression.happy;
        feedbackText = '¡Excelente trabajo, Guardián! (+${controller.currentActivity?.xpReward ?? 10} XP)';
      } else {
        mascotExpression = MascotExpression.worried;
        feedbackText = '¡Casi! Revisa tu respuesta e inténtalo de nuevo.';
      }
    } else if (controller.canCheck) {
      mascotExpression = MascotExpression.smiling;
      feedbackText = '¡Listo! Pulsa COMPROBAR cuando quieras verificar.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isCorrect == true ? const Color(0xFFE8F5E9) : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusLarge),
          topRight: Radius.circular(AppDimensions.radiusLarge),
        ),
        boxShadow: AppShadows.card,
        border: Border.all(
          color: isCorrect == true
              ? AppColors.emerald
              : isChecked
                  ? const Color(0xFFEF5350)
                  : primaryColor.withOpacity(0.35),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Mascota de apoyo interactiva
              MascotWidget(
                size: 52,
                expression: mascotExpression,
                isAnimated: false,
                ecosystemCode: widget.ecosystem?.id ?? 'bosque_andino',
              ),
              const SizedBox(width: AppDimensions.space12),

              // Globo de diálogo y retroalimentación
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isChecked
                        ? (isCorrect == true ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE))
                        : primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    border: Border.all(
                      color: isChecked
                          ? (isCorrect == true ? AppColors.emerald : const Color(0xFFEF5350))
                          : primaryColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    feedbackText,
                    style: AppTypography.caption.copyWith(
                      color: isChecked
                          ? (isCorrect == true ? AppColors.forestGreenDark : const Color(0xFFC62828))
                          : primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Botón Principal de Acción a ancho completo
          SizedBox(
            width: double.infinity,
            child: isChecked && isCorrect == true
                ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(double.infinity, 48),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    label: Text(
                      controller.isLastActivity ? 'FINALIZAR' : 'CONTINUAR',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                    onPressed: () => controller.nextActivity(),
                  )
                : isChecked && isCorrect == false
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF5350),
                          foregroundColor: AppColors.white,
                          minimumSize: const Size(double.infinity, 48),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 20),
                        label: const Text(
                          'REINTENTAR',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                        onPressed: () => controller.retryCurrentActivity(),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.canCheck && !controller.isSubmitting
                              ? primaryColor
                              : primaryColor.withOpacity(0.35),
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: primaryColor.withOpacity(0.35),
                          disabledForegroundColor: AppColors.white.withOpacity(0.85),
                          minimumSize: const Size(double.infinity, 48),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: controller.canCheck && !controller.isSubmitting ? 3 : 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                          ),
                        ),
                        onPressed: (controller.canCheck && !controller.isSubmitting)
                            ? () => _onCheck(controller)
                            : null,
                        child: controller.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'COMPROBAR',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                              ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen(ActivityController controller) {
    final primaryColor = _ecosystemPrimaryColor;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MascotWidget(
              size: 110,
              expression: MascotExpression.happy,
              ecosystemCode: widget.ecosystem?.id ?? 'bosque_andino',
            ),
            const SizedBox(height: 20),
            Text(
              '¡Felicidades, completaste la lección!',
              style: AppTypography.headingLarge.copyWith(color: primaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '¡Sigue explorando!',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Resumen de Recompensa XP
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                boxShadow: AppShadows.card,
                border: Border.all(color: primaryColor, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.energy_savings_leaf_rounded, color: primaryColor, size: 36),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Puntos Ganados',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.darkGrey),
                      ),
                      Text(
                        '+${controller.totalXpEarned} XP',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            AppButton(
              label: '¡SIGUE EXPLORANDO!',
              icon: Icons.explore_rounded,
              customColor: primaryColor,
              onPressed: () {
                final isLevelUp = controller.lastAttemptResult?.levelUp == true;
                if (isLevelUp && mounted) {
                  ChildProfileController? profileCtrl;
                  try {
                    profileCtrl = context.read<ChildProfileController>();
                  } catch (_) {}
                  final newLvl = controller.lastAttemptResult?.currentLevel ?? (profileCtrl?.levelNumber ?? 2);
                  final prevLvl = controller.lastAttemptResult?.previousLevel ?? (newLvl > 1 ? newLvl - 1 : 1);
                  LevelUpCelebrationScreen.show(
                    context: context,
                    newLevel: newLvl,
                    previousLevel: prevLvl,
                    childName: profileCtrl?.childName ?? 'Guardián',
                    avatarConfig: profileCtrl?.avatarConfig ?? AvatarConfig.defaultConfig(),
                    onContinue: widget.onActivityComplete,
                  );
                } else {
                  widget.onActivityComplete();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
