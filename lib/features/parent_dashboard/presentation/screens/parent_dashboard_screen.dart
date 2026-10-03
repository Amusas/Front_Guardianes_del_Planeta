import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../widgets/weekly_activity_chart.dart';
import '../widgets/parent_bottom_nav.dart';
import '../../domain/models/parent_report_model.dart';

class ParentDashboardScreen extends StatefulWidget {
  final VoidCallback onBackToChildExperience;

  const ParentDashboardScreen({super.key, required this.onBackToChildExperience});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _navIndex = 0;
  String _selectedChild = 'Andrés';

  final List<RecentActivityItem> _recentActivities = const [
    RecentActivityItem(
      timestamp: '3:00 PM',
      title: 'Completó actividad',
      subtitle: '"El ciclo del agua"',
      icon: Icons.water_drop_rounded,
      iconColor: AppColors.turquoise,
      badgeText: '+50 XP',
    ),
    RecentActivityItem(
      timestamp: '2:30 PM',
      title: 'Obtuvo nueva insignia',
      subtitle: '"Protector del Agua"',
      icon: Icons.military_tech_rounded,
      iconColor: AppColors.goldDark,
      badgeText: 'Insignia',
    ),
    RecentActivityItem(
      timestamp: 'Ayer',
      title: 'Comenzó exploración',
      subtitle: '"Animales de los Andes"',
      icon: Icons.pets_rounded,
      iconColor: AppColors.forestGreen,
      badgeText: 'En progreso',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkText),
          onPressed: widget.onBackToChildExperience,
          tooltip: 'Volver a la aventura',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Panel Familiar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.face_rounded, size: 14, color: AppColors.forestGreen),
                const SizedBox(width: 4),
                Text(
                  'Perfil: $_selectedChild',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.forestGreenDark,
                  ),
                ),
                const Icon(Icons.arrow_drop_down_rounded, size: 18, color: AppColors.forestGreenDark),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.darkGrey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.darkGrey),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: ParentBottomNav(
        currentIndex: _navIndex,
        onTabSelected: (idx) {
          setState(() {
            _navIndex = idx;
          });
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.space20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Resumen de Aprendizaje
            const Text(
              'Resumen de aprendizaje',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                // Tarjeta 1: Lecciones completadas
                Expanded(
                  child: _buildMetricCard(
                    title: 'Lecciones',
                    value: '12',
                    badge: '+3 esta semana',
                    badgeColor: AppColors.forestGreen,
                    contentWidget: LinearProgressIndicator(
                      value: 0.65,
                      backgroundColor: AppColors.lightGrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.forestGreen),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Tarjeta 2: Tiempo de uso
                Expanded(
                  child: _buildMetricCard(
                    title: 'Tiempo de uso',
                    value: '4h 35m',
                    badge: 'Esta semana',
                    badgeColor: AppColors.bluishGrey,
                    contentWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.schedule_rounded, size: 16, color: AppColors.mediumGrey),
                        Text(
                          '39 min/día',
                          style: TextStyle(fontSize: 11, color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Tarjeta 3: Conceptos aprendidos
                Expanded(
                  child: _buildMetricCard(
                    title: 'Conceptos',
                    value: '18',
                    badge: 'Ecológicos',
                    badgeColor: AppColors.emerald,
                    contentWidget: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          value: 0.75,
                          strokeWidth: 3,
                          backgroundColor: AppColors.lightGrey,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emerald),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 2. Gráfico Semanal de Actividad
            const WeeklyActivityChart(),

            const SizedBox(height: 24),

            // 3. Ecosistemas Explorados
            Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.lightGrey, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ecosistemas explorados',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEcosystemProgressRow(
                    name: 'Bosque Andino',
                    progressText: '70%',
                    progressValue: 0.7,
                    icon: Icons.forest_rounded,
                    color: AppColors.forestGreen,
                  ),
                  const Divider(height: 24),
                  _buildEcosystemProgressRow(
                    name: 'El Páramo',
                    progressText: '30%',
                    progressValue: 0.3,
                    icon: Icons.terrain_rounded,
                    color: AppColors.bluishGrey,
                  ),
                  const Divider(height: 24),
                  _buildEcosystemProgressRow(
                    name: 'Océano',
                    progressText: 'Bloqueado',
                    progressValue: 0.0,
                    icon: Icons.waves_rounded,
                    color: AppColors.mediumGrey,
                    isLocked: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Actividad Reciente (Timeline)
            Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.lightGrey, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Actividad reciente',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final item in _recentActivities) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: item.iconColor.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(item.icon, size: 18, color: item.iconColor),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.darkText,
                                      ),
                                    ),
                                    Text(
                                      item.timestamp,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.mediumGrey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.subtitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item != _recentActivities.last)
                      const Padding(
                        padding: EdgeInsets.only(left: 36),
                        child: Divider(height: 12),
                      ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String badge,
    required Color badgeColor,
    required Widget contentWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.lightGrey, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.mediumGrey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: badgeColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          contentWidget,
        ],
      ),
    );
  }

  Widget _buildEcosystemProgressRow({
    required String name,
    required String progressText,
    required double progressValue,
    required IconData icon,
    required Color color,
    bool isLocked = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                    ),
                  ),
                  Text(
                    progressText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isLocked ? AppColors.mediumGrey : color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 6,
                  backgroundColor: AppColors.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
