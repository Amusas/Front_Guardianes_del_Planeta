import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/guardian_child_dashboard_entity.dart';

class EcosystemProgressChart extends StatelessWidget {
  final List<EcosystemProgress> ecosystems;

  const EcosystemProgressChart({super.key, required this.ecosystems});

  @override
  Widget build(BuildContext context) {
    if (ecosystems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.public_rounded, size: 18, color: AppColors.forestGreen),
              SizedBox(width: 8),
              Text(
                'Progreso por Ecosistema',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...ecosystems.map(_buildEcosystemRow),
        ],
      ),
    );
  }

  Widget _buildEcosystemRow(EcosystemProgress eco) {
    final Color ecoColor = _getColorForEcosystem(eco.code);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                eco.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
              Text(
                '${eco.completedLessons}/${eco.totalLessons} lecciones (${eco.progressPercentage.toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ecoColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (eco.progressPercentage / 100.0).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: AppColors.lightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(ecoColor),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForEcosystem(String code) {
    switch (code.toUpperCase()) {
      case 'PARAMO':
        return AppColors.paramoMoss;
      case 'OCEANO':
      case 'OCEAN':
        return AppColors.turquoise;
      case 'BOSQUE_ANDINO':
      default:
        return AppColors.forestGreen;
    }
  }
}
