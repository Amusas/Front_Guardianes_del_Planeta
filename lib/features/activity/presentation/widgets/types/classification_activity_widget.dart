import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../domain/models/activity_model.dart';

class ClassificationActivityWidget extends StatelessWidget {
  final ActivityModel activity;
  final dynamic currentAnswer;
  final bool isChecked;
  final bool? isCorrect;
  final ValueChanged<dynamic> onAnswerSelected;

  const ClassificationActivityWidget({
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

  void _setItemCategory(String itemId, String categoryId) {
    if (isChecked && isCorrect == true) return;
    final updated = Map<String, String>.from(_currentMap);
    updated[itemId] = categoryId;
    onAnswerSelected(updated);
  }

  void _removeItemCategory(String itemId) {
    if (isChecked && isCorrect == true) return;
    final updated = Map<String, String>.from(_currentMap);
    updated.remove(itemId);
    onAnswerSelected(updated);
  }

  void _showCategorySelectionDialog(
    BuildContext context,
    Map<String, String> item,
    List<Map<String, String>> categories,
  ) {
    if (isChecked && isCorrect == true) return;
    final itemId = item['id'] ?? '';
    final itemName = item['name'] ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.space20),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '¿A qué categoría pertenece "$itemName"?',
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.darkText,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < categories.length; i++) ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: i == 0 ? AppColors.forestGreen : const Color(0xFF0288D1),
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _setItemCategory(itemId, categories[i]['id'] ?? '');
                  },
                  child: Text(
                    categories[i]['name'] ?? 'Categoría',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = activity.classificationCategories;
    final items = activity.classificationItems;
    final map = _currentMap;

    // Elementos no clasificados aún
    final unassignedItems = items.where((item) => !map.containsKey(item['id'])).toList();

    // Las 2 categorías
    final cat1 = categories.isNotEmpty ? categories[0] : {'id': 'cat1', 'name': 'Categoría 1'};
    final cat2 = categories.length > 1 ? categories[1] : {'id': 'cat2', 'name': 'Categoría 2'};

    final cat1Items = items.where((item) => map[item['id']] == cat1['id']).toList();
    final cat2Items = items.where((item) => map[item['id']] == cat2['id']).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tarjeta de Instrucción
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: AppShadows.card,
            border: Border.all(color: AppColors.emerald.withValues(alpha: 0.4), width: 1.5),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.swap_horiz_rounded, size: 14, color: AppColors.forestGreen),
                    const SizedBox(width: 4),
                    Text(
                      'Arrastra y clasifica',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.forestGreenDark,
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
                  fontSize: 17,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Arrastra cada cuadro a su categoría correspondiente.',
                style: AppTypography.caption.copyWith(
                  color: AppColors.mediumGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.space16),

        // Dos Zonas de Categoría (Drop Targets)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categoría 1 (Verde naturaleza)
            Expanded(
              child: _buildCategoryDropZone(
                category: cat1,
                assignedItems: cat1Items,
                primaryColor: const Color(0xFF2D6A4F),
                headerBg: const Color(0xFFD8F3DC),
                bodyBg: const Color(0xFFF7FCF8),
                hoverBg: const Color(0xFFB7E4C7),
                icon: Icons.eco_rounded,
              ),
            ),
            const SizedBox(width: 12),
            // Categoría 2 (Azul elementos)
            Expanded(
              child: _buildCategoryDropZone(
                category: cat2,
                assignedItems: cat2Items,
                primaryColor: const Color(0xFF0288D1),
                headerBg: const Color(0xFFE1F5FE),
                bodyBg: const Color(0xFFF9FBFC),
                hoverBg: const Color(0xFFB3E5FC),
                icon: Icons.category_rounded,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.space20),

        // Cuadros pequeños con solo texto (Opciones para arrastrar)
        _buildAvailableItemsPool(
          context: context,
          unassignedItems: unassignedItems,
          categories: categories,
        ),
      ],
    );
  }

  Widget _buildCategoryDropZone({
    required Map<String, String> category,
    required List<Map<String, String>> assignedItems,
    required Color primaryColor,
    required Color headerBg,
    required Color bodyBg,
    required Color hoverBg,
    required IconData icon,
  }) {
    final catId = category['id'] ?? '';
    final catName = category['name'] ?? '';

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        if (isChecked && isCorrect == true) return false;
        return true;
      },
      onAcceptWithDetails: (details) {
        _setItemCategory(details.data, catId);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isHovered ? hoverBg : bodyBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(
              color: isHovered ? primaryColor : primaryColor.withValues(alpha: 0.45),
              width: isHovered ? 2.5 : 1.5,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ]
                : AppShadows.small,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Encabezado de la categoría
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                decoration: BoxDecoration(
                  color: headerBg,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusLarge - 1.5),
                    topRight: Radius.circular(AppDimensions.radiusLarge - 1.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: primaryColor),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        catName,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: primaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${assignedItems.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Área de elementos colocados
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 130),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: assignedItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_download_outlined,
                                size: 24,
                                color: isHovered ? primaryColor : primaryColor.withValues(alpha: 0.35),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isHovered ? '¡Suéltalo aquí!' : 'Arrastra aquí',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: isHovered ? primaryColor : AppColors.mediumGrey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: assignedItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: _buildAssignedItemChip(
                                item: item,
                                categoryColor: primaryColor,
                                currentCategoryId: catId,
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAssignedItemChip({
    required Map<String, String> item,
    required Color categoryColor,
    required String currentCategoryId,
  }) {
    final itemId = item['id'] ?? '';
    final itemName = item['name'] ?? '';

    // Si ya se comprobó, verificar si este ítem está en la categoría correcta
    final expectedCategory = activity.classificationCorrectAnswers[itemId];
    final bool? isItemCorrect = isChecked && expectedCategory != null
        ? (expectedCategory.toLowerCase() == currentCategoryId.toLowerCase())
        : null;

    Color chipBg = AppColors.white;
    Color chipBorder = categoryColor;
    Widget? trailingIcon;

    if (isChecked) {
      if (isItemCorrect == true) {
        chipBg = const Color(0xFFE8F5E9);
        chipBorder = AppColors.forestGreen;
        trailingIcon = const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.forestGreen);
      } else if (isItemCorrect == false) {
        chipBg = const Color(0xFFFFEBEE);
        chipBorder = const Color(0xFFE53935);
        trailingIcon = const Icon(Icons.cancel_rounded, size: 16, color: Color(0xFFE53935));
      }
    } else {
      trailingIcon = GestureDetector(
        onTap: () => _removeItemCategory(itemId),
        child: const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Icon(Icons.close_rounded, size: 16, color: AppColors.darkGrey),
        ),
      );
    }

    final chipWidget = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: chipBorder, width: 1.3),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              itemName,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
                height: 1.25,
              ),
              softWrap: true,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 4),
            trailingIcon,
          ],
        ],
      ),
    );

    // Permite también re-arrastrar desde una categoría a otra si no está bloqueado
    if (isChecked && isCorrect == true) {
      return chipWidget;
    }

    return Draggable<String>(
      data: itemId,
      feedback: _buildDragFeedback(itemName),
      childWhenDragging: Opacity(opacity: 0.3, child: chipWidget),
      child: chipWidget,
    );
  }

  Widget _buildAvailableItemsPool({
    required BuildContext context,
    required List<Map<String, String>> unassignedItems,
    required List<Map<String, String>> categories,
  }) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        // Al arrastrar de vuelta a la piscina de opciones, desasignamos
        _removeItemCategory(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            boxShadow: AppShadows.card,
            border: Border.all(
              color: candidateData.isNotEmpty ? AppColors.forestGreen : AppColors.lightGrey,
              width: candidateData.isNotEmpty ? 2.0 : 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.touch_app_rounded, size: 16, color: AppColors.forestGreen),
                  const SizedBox(width: 6),
                  const Text(
                    'Opciones disponibles:',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppColors.darkText,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.pastelGreenBg,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                    ),
                    child: Text(
                      '${unassignedItems.length} restantes',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.forestGreenDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (unassignedItems.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                    border: Border.all(color: AppColors.emerald.withValues(alpha: 0.5)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, color: AppColors.forestGreen, size: 18),
                      SizedBox(width: 8),
                      Text(
                        '¡Todos los elementos están clasificados!',
                        style: TextStyle(
                          color: AppColors.forestGreenDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: unassignedItems.map((item) {
                    return _buildDraggableOptionBox(
                      context: context,
                      item: item,
                      categories: categories,
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableOptionBox({
    required BuildContext context,
    required Map<String, String> item,
    required List<Map<String, String>> categories,
  }) {
    final itemId = item['id'] ?? '';
    final itemName = item['name'] ?? '';

    final boxContent = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showCategorySelectionDialog(context, item, categories),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF64748B), width: 1.5),
            boxShadow: AppShadows.small,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.drag_indicator_rounded, size: 16, color: Color(0xFF94A3B8)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                      height: 1.25,
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (isChecked && isCorrect == true) {
      return boxContent;
    }

    return Draggable<String>(
      data: itemId,
      feedback: _buildDragFeedback(itemName),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              itemName,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              softWrap: true,
            ),
          ),
        ),
      ),
      child: boxContent,
    );
  }

  Widget _buildDragFeedback(String itemName) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 240),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.forestGreen, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pan_tool_alt_rounded, size: 16, color: AppColors.forestGreen),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: AppColors.forestGreenDark,
                    decoration: TextDecoration.none,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
