import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/child_profile_entity.dart';

class ChildSelectorWidget extends StatelessWidget {
  final List<ChildProfileEntity> children;
  final int? selectedChildId;
  final ValueChanged<int> onSelectChild;
  final VoidCallback onAddChild;
  final bool isSwitching;

  const ChildSelectorWidget({
    super.key,
    required this.children,
    required this.selectedChildId,
    required this.onSelectChild,
    required this.onAddChild,
    this.isSwitching = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_alt_rounded, size: 18, color: AppColors.forestGreen),
                    const SizedBox(width: 8),
                    const Text(
                      'Perfiles Infantiles',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkText,
                      ),
                    ),
                    if (isSwitching) ...[
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.forestGreen),
                      ),
                    ],
                  ],
                ),
                TextButton.icon(
                  onPressed: onAddChild,
                  icon: const Icon(Icons.person_add_alt_1_rounded, size: 16, color: AppColors.forestGreen),
                  label: const Text(
                    'Crear perfil',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.forestGreen,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 68,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: children.length + 1,
              itemBuilder: (context, index) {
                if (index == children.length) {
                  return _buildAddChildButton();
                }
                final child = children[index];
                final isSelected = child.id == selectedChildId;
                return _buildChildCard(child, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildCard(ChildProfileEntity child, bool isSelected) {
    return GestureDetector(
      onTap: () => onSelectChild(child.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.forestGreen.withOpacity(0.08) : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.forestGreen : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: isSelected ? AppColors.forestGreen : AppColors.mediumGrey,
              child: Text(
                child.name.isNotEmpty ? child.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  child.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? AppColors.forestGreenDark : AppColors.darkText,
                  ),
                ),
                Text(
                  '${child.totalXp} XP',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddChildButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton.icon(
        onPressed: onAddChild,
        icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.forestGreen),
        label: const Text(
          'Nuevo',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.forestGreen,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.forestGreen, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
