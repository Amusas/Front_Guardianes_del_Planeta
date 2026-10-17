import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/guardian_dashboard_controller.dart';
import '../state/guardian_dashboard_state.dart';
import '../widgets/child_selector_widget.dart';
import '../widgets/create_child_modal.dart';
import '../widgets/dashboard_error_widget.dart';
import '../widgets/ecosystem_progress_chart.dart';
import '../widgets/empty_children_widget.dart';
import '../widgets/metric_cards_grid.dart';
import '../widgets/recent_activity_timeline.dart';
import '../widgets/xp_evolution_chart.dart';

class GuardianDashboardScreen extends StatefulWidget {
  final VoidCallback? onBackToChildExperience;

  const GuardianDashboardScreen({
    super.key,
    this.onBackToChildExperience,
  });

  @override
  State<GuardianDashboardScreen> createState() => _GuardianDashboardScreenState();
}

class _GuardianDashboardScreenState extends State<GuardianDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = context.read<GuardianDashboardController>();
        controller.loadDashboard();
      }
    });
  }

  void _openCreateChildModal(BuildContext context) {
    final controller = context.read<GuardianDashboardController>();
    CreateChildModal.show(context, controller);
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Cerrar sesión?'),
        content: const Text('¿Estás seguro de que deseas salir del panel de acudiente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.darkGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                context.read<GuardianDashboardController>().reset();
                await context.read<AuthController>().logout();
              } catch (_) {}
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardianDashboardController>(
      builder: (context, controller, child) {
        final state = controller.state;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: widget.onBackToChildExperience != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.darkText),
                    onPressed: widget.onBackToChildExperience,
                    tooltip: 'Volver al juego',
                  )
                : null,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard del Acudiente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  state.selectedChild != null
                      ? 'Supervisando a: ${state.selectedChild!.name}'
                      : 'Supervisión de aprendizaje ambiental',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.forestGreen,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.darkGrey),
                onPressed: state.status == GuardianDashboardStatus.loading
                    ? null
                    : () => controller.loadDashboard(),
                tooltip: 'Actualizar métricas',
              ),
              IconButton(
                icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.forestGreen),
                onPressed: () => _openCreateChildModal(context),
                tooltip: 'Crear perfil infantil',
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: AppColors.coral),
                onPressed: () => _confirmLogout(context),
                tooltip: 'Cerrar sesión',
              ),
            ],
          ),
          body: _buildBody(context, controller, state),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    GuardianDashboardController controller,
    GuardianDashboardState state,
  ) {
    switch (state.status) {
      case GuardianDashboardStatus.initial:
      case GuardianDashboardStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.forestGreen),
        );

      case GuardianDashboardStatus.empty:
        return EmptyChildrenWidget(
          onCreateChild: () => _openCreateChildModal(context),
        );

      case GuardianDashboardStatus.error:
        return DashboardErrorWidget(
          message: state.errorMessage ?? 'Ocurrió un error al obtener la información.',
          isUnauthorized: state.isUnauthorized,
          onRetry: () => controller.loadDashboard(),
        );

      case GuardianDashboardStatus.loaded:
        final dashboard = state.dashboard;

        return RefreshIndicator(
          color: AppColors.forestGreen,
          onRefresh: () => controller.loadDashboard(preferredChildId: state.selectedChildId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ChildSelectorWidget(
                  children: state.children,
                  selectedChildId: state.selectedChildId,
                  isSwitching: state.isSwitchingChild,
                  onSelectChild: (id) => controller.selectChild(id),
                  onAddChild: () => _openCreateChildModal(context),
                ),
                const SizedBox(height: 14),
                if (state.isSwitchingChild)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.forestGreen),
                    ),
                  )
                else if (dashboard != null) ...[
                  MetricCardsGrid(dashboard: dashboard),
                  const SizedBox(height: 14),
                  if (dashboard.ecosystemProgress.isNotEmpty) ...[
                    EcosystemProgressChart(ecosystems: dashboard.ecosystemProgress),
                    const SizedBox(height: 14),
                  ],
                  XpEvolutionChart(xpHistory: dashboard.xpHistory),
                  const SizedBox(height: 14),
                  RecentActivityTimeline(activities: dashboard.recentActivities),
                  const SizedBox(height: 24),
                ] else
                  const Center(
                    child: Text(
                      'No hay información de métricas para este perfil.',
                      style: TextStyle(color: AppColors.darkGrey),
                    ),
                  ),
              ],
            ),
          ),
        );
    }
  }
}
