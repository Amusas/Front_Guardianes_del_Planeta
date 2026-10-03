import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ParentBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const ParentBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, -3)),
        ],
        border: Border(top: BorderSide(color: AppColors.lightGrey, width: 1.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, 'Resumen', Icons.dashboard_rounded),
              _buildNavItem(1, 'Cuenta', Icons.manage_accounts_rounded),
              _buildNavItem(2, 'Soporte', Icons.support_agent_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final bool isSelected = currentIndex == index;
    final Color color = isSelected ? AppColors.forestGreenDark : AppColors.mediumGrey;

    return InkWell(
      onTap: () => onTabSelected(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
