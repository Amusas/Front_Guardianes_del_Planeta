import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/guardian_child_dashboard_entity.dart';

class RecentActivityTimeline extends StatelessWidget {
  final List<RecentActivity> activities;

  const RecentActivityTimeline({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.timeline_rounded, size: 18, color: AppColors.forestGreen),
              SizedBox(width: 8),
              Text(
                'Actividad Reciente',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (activities.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: const Text(
                'No se registran actividades recientes aún para este niño.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.mediumGrey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (_, __) => const Divider(height: 16, color: AppColors.lightGrey),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(activity);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(RecentActivity activity) {
    final bool isAchievement = activity.type == 'ACHIEVEMENT';
    final IconData icon = isAchievement
        ? Icons.military_tech_rounded
        : (activity.isSuccess ? Icons.check_circle_rounded : Icons.replay_rounded);

    final Color iconColor = isAchievement
        ? AppColors.gold
        : (activity.isSuccess ? AppColors.emerald : AppColors.darkGrey);

    final dateStr = activity.timestamp != null
        ? '${activity.timestamp!.day.toString().padLeft(2, '0')}/${activity.timestamp!.month.toString().padLeft(2, '0')} ${activity.timestamp!.hour.toString().padLeft(2, '0')}:${activity.timestamp!.minute.toString().padLeft(2, '0')}'
        : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                activity.description,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (activity.xpAwarded > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${activity.xpAwarded} XP',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.goldDark,
                  ),
                ),
              ),
            if (dateStr.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.mediumGrey,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
