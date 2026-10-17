import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/guardian_child_dashboard_entity.dart';

class MetricCardsGrid extends StatelessWidget {
  final GuardianChildDashboardEntity dashboard;

  const MetricCardsGrid({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLevelAndXpCard(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Lecciones',
                value: '${dashboard.completedLessonsCount} / ${dashboard.totalLessonsCount}',
                subtitle: 'completadas',
                icon: Icons.menu_book_rounded,
                iconColor: AppColors.forestGreen,
                bgColor: const Color(0xFFEDF7EE),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Actividades',
                value: '${dashboard.totalAttemptsCount}',
                subtitle: 'prácticas realizadas',
                icon: Icons.quiz_rounded,
                iconColor: AppColors.turquoise,
                bgColor: const Color(0xFFE6F7F5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Precisión',
                value: '${dashboard.accuracyPercentage.toStringAsFixed(1)}%',
                subtitle: '${dashboard.correctAttemptsCount} aciertos',
                icon: Icons.track_changes_rounded,
                iconColor: dashboard.accuracyPercentage >= 70 ? AppColors.emerald : AppColors.goldDark,
                bgColor: const Color(0xFFFEF8E8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Racha Diaria',
                value: '${dashboard.currentStreak} días',
                subtitle: 'constancia',
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.coral,
                bgColor: const Color(0xFFFDEEE9),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildMetricCard(
          title: 'Logros e Insignias',
          value: '${dashboard.unlockedAchievementsCount} / ${dashboard.totalAchievementsCount}',
          subtitle: 'desbloqueados en su trayectoria de guardián',
          icon: Icons.military_tech_rounded,
          iconColor: AppColors.gold,
          bgColor: const Color(0xFFFFFBEB),
        ),
      ],
    );
  }

  Widget _buildLevelAndXpCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NIVEL ${dashboard.levelNumber}',
                    style: TextStyle(
                      color: AppColors.gold.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dashboard.levelName,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (dashboard.age != null)
                    Text(
                      'Edad: ${dashboard.age} años',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.75),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.gold, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, size: 18, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text(
                      '${dashboard.totalXp} XP',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dashboard.nextLevelName != null
                    ? 'Hacia: ${dashboard.nextLevelName}'
                    : '¡Nivel Máximo Alcanzado!',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${dashboard.levelProgressPercentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (dashboard.levelProgressPercentage / 100.0).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
