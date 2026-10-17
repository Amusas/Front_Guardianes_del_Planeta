import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../domain/models/activity_model.dart';

class OrderingActivityWidget extends StatefulWidget {
  final ActivityModel activity;
  final dynamic currentAnswer;
  final bool isChecked;
  final bool? isCorrect;
  final ValueChanged<dynamic> onAnswerSelected;

  const OrderingActivityWidget({
    super.key,
    required this.activity,
    required this.currentAnswer,
    required this.isChecked,
    required this.isCorrect,
    required this.onAnswerSelected,
  });

  @override
  State<OrderingActivityWidget> createState() => _OrderingActivityWidgetState();
}

class _OrderingActivityWidgetState extends State<OrderingActivityWidget> {
  late List<int> _order;

  @override
  void initState() {
    super.initState();
    _initOrder();
  }

  @override
  void didUpdateWidget(covariant OrderingActivityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) {
      _initOrder();
    } else if (widget.currentAnswer is List<int>) {
      final currentList = widget.currentAnswer as List<int>;
      if (currentList.length == _order.length && currentList.toString() != _order.toString()) {
        _order = List<int>.from(currentList);
      }
    }
  }

  void _initOrder() {
    final steps = widget.activity.orderingSteps;
    if (widget.currentAnswer is List<int>) {
      _order = List<int>.from(widget.currentAnswer as List<int>);
    } else {
      // Orden inicial invertido o mezclado para que el niño lo ordene
      _order = List.generate(steps.length, (i) => i);
      if (_order.length > 1) {
        _order = _order.reversed.toList();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onAnswerSelected(List<int>.from(_order));
        }
      });
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (widget.isChecked && widget.isCorrect == true) return;
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _order.removeAt(oldIndex);
      _order.insert(newIndex, item);
    });
    widget.onAnswerSelected(List<int>.from(_order));
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.activity.orderingSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instrucciones
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: AppShadows.card,
            border: Border.all(color: const Color(0xFF0288D1).withValues(alpha: 0.35), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE1F5FE),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swap_vert_rounded, size: 15, color: Color(0xFF0288D1)),
                    SizedBox(width: 5),
                    Text(
                      'Arrastra para ordenar los pasos',
                      style: TextStyle(
                        color: Color(0xFF0288D1),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.activity.questionOrInstruction,
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.darkText,
                  fontSize: 17,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Toma el icono de la derecha o presiona la tarjeta para arrastrarla a su lugar.',
                style: AppTypography.caption.copyWith(
                  color: AppColors.mediumGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.space20),

        // Lista de pasos reordenables por arrastre
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          proxyDecorator: (Widget child, int index, Animation<double> animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Material(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  color: Colors.transparent,
                  child: child,
                );
              },
              child: child,
            );
          },
          onReorder: _onReorder,
          itemCount: _order.length,
          itemBuilder: (context, index) {
            final stepIndex = _order[index];
            final stepText = stepIndex < steps.length ? steps[stepIndex] : '';

            return Padding(
              key: ValueKey('step_$stepIndex'),
              padding: const EdgeInsets.only(bottom: AppDimensions.space12),
              child: _buildStepCard(
                index: index,
                position: index + 1,
                stepIndex: stepIndex,
                stepText: stepText,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStepCard({
    required int index,
    required int position,
    required int stepIndex,
    required String stepText,
  }) {
    Color badgeColor = const Color(0xFF0288D1);
    Color borderColor = AppColors.lightGrey;
    Widget? statusIcon;

    if (widget.isChecked && widget.isCorrect != null) {
      final expectedSequence = widget.activity.orderingCorrectSequence;
      final bool isStepInCorrectPosition = index < expectedSequence.length &&
          stepIndex == expectedSequence[index];

      if (widget.isCorrect! || isStepInCorrectPosition) {
        badgeColor = AppColors.emerald;
        borderColor = AppColors.emerald;
        statusIcon = const Icon(
          Icons.check_circle_rounded,
          size: 22,
          color: AppColors.forestGreen,
        );
      } else {
        badgeColor = const Color(0xFFE53935);
        borderColor = const Color(0xFFE53935);
        statusIcon = const Icon(
          Icons.cancel_rounded,
          size: 22,
          color: Color(0xFFE53935),
        );
      }
    }

    final cardContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: AppShadows.small,
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: Row(
        children: [
          // Número de paso dinámico (1, 2, 3...)
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$position',
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Texto del paso
          Expanded(
            child: Text(
              stepText,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkText,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Control de arrastre o icono de comprobación
          if (widget.isChecked && statusIcon != null)
            statusIcon
          else
            ReorderableDragStartListener(
              index: index,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: const Icon(
                  Icons.drag_indicator_rounded,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
        ],
      ),
    );

    // Si ya está comprobado y es correcto, deshabilitar arrastre
    if (widget.isChecked && widget.isCorrect == true) {
      return cardContent;
    }

    return ReorderableDelayedDragStartListener(
      index: index,
      child: cardContent,
    );
  }
}
