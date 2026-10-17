import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/guardian_child_dashboard_entity.dart';

class _DailyXpPoint {
  final DateTime date;
  final int totalXp;
  final bool isToday;

  const _DailyXpPoint({
    required this.date,
    required this.totalXp,
    required this.isToday,
  });
}

class XpEvolutionChart extends StatelessWidget {
  final List<XpHistoryItem> xpHistory;
  final DateTime? referenceDate;

  const XpEvolutionChart({
    super.key,
    required this.xpHistory,
    this.referenceDate,
  });

  @override
  Widget build(BuildContext context) {
    final points = _calculate5DaysPoints();

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
              Icon(Icons.insights_rounded, size: 18, color: AppColors.goldDark),
              SizedBox(width: 8),
              Text(
                'Evolución de Experiencia (XP)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBarVisualization(points),
          const SizedBox(height: 12),
          _buildHistorySummary(),
        ],
      ),
    );
  }

  List<_DailyXpPoint> _calculate5DaysPoints() {
    final now = referenceDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final List<_DailyXpPoint> points = [];
    for (int offset = -2; offset <= 2; offset++) {
      final date = DateTime(today.year, today.month, today.day + offset);
      int dailySum = 0;

      for (final item in xpHistory) {
        if (item.createdAt != null) {
          final dt = item.createdAt!;
          if (dt.year == date.year && dt.month == date.month && dt.day == date.day) {
            dailySum += item.amount;
          }
        }
      }

      points.add(_DailyXpPoint(
        date: date,
        totalXp: dailySum,
        isToday: offset == 0,
      ));
    }
    return points;
  }

  Widget _buildBarVisualization(List<_DailyXpPoint> points) {
    final maxAmount = points.map((e) => e.totalXp).fold<int>(1, (prev, elem) => elem > prev ? elem : prev);

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: points.map((point) {
          final barHeight = point.totalXp > 0
              ? ((point.totalXp / maxAmount) * 65.0).clamp(10.0, 65.0)
              : 8.0;

          final dateStr = '${point.date.day.toString().padLeft(2, '0')}/${point.date.month.toString().padLeft(2, '0')}';

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                point.totalXp > 0 ? '+${point.totalXp}' : '0',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: point.totalXp > 0 ? AppColors.goldDark : AppColors.mediumGrey,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 28,
                height: barHeight,
                decoration: BoxDecoration(
                  gradient: point.totalXp > 0
                      ? const LinearGradient(
                          colors: [AppColors.goldLight, AppColors.gold],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : LinearGradient(
                          colors: [
                            point.isToday ? AppColors.goldLight.withOpacity(0.35) : AppColors.lightGrey,
                            point.isToday ? AppColors.gold.withOpacity(0.2) : const Color(0xFFE0E0E0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                  borderRadius: BorderRadius.circular(6),
                  border: point.isToday
                      ? Border.all(color: AppColors.goldDark.withOpacity(0.6), width: 1.2)
                      : null,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 10,
                  color: point.isToday ? AppColors.forestGreenDark : AppColors.darkGrey,
                  fontWeight: point.isToday ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
              if (point.isToday)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Hoy',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: AppColors.forestGreenDark,
                    ),
                  ),
                )
              else
                const SizedBox(height: 14),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistorySummary() {
    if (xpHistory.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 16, color: AppColors.darkGrey),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Aún no hay transacciones de XP registradas.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    final recent = xpHistory.first;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.history_rounded, size: 16, color: AppColors.darkGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Última ganancia: +${recent.amount} XP (${recent.description.isNotEmpty ? recent.description : recent.type})',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.darkText,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
