import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../ecosystems/domain/models/ecosystem_model.dart';
import '../../domain/models/lesson_node_model.dart';
import '../../data/exploration_mock_data.dart';
import '../controllers/lesson_controller.dart';
import '../widgets/lesson_node_widget.dart';
import '../widgets/winding_path_painter.dart';
import '../widgets/ecosystem_route_scenery_painter.dart';

class ExplorationRouteScreen extends StatefulWidget {
  final VoidCallback onBackToEcosystems;
  final Function(LessonNodeModel) onStartActivity;
  final EcosystemModel? ecosystem;
  final int? ecosystemId;

  const ExplorationRouteScreen({
    super.key,
    required this.onBackToEcosystems,
    required this.onStartActivity,
    this.ecosystem,
    this.ecosystemId,
  });

  @override
  State<ExplorationRouteScreen> createState() => _ExplorationRouteScreenState();
}

class _ExplorationRouteScreenState extends State<ExplorationRouteScreen> {
  int get _resolvedEcosystemId => widget.ecosystem?.numericId ?? widget.ecosystemId ?? 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LessonController>().loadLessons(_resolvedEcosystemId);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ExplorationRouteScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldId = oldWidget.ecosystem?.numericId ?? oldWidget.ecosystemId;
    final newId = widget.ecosystem?.numericId ?? widget.ecosystemId;
    if (newId != null && newId != oldId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<LessonController>().loadLessons(newId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonController = context.watch<LessonController>();
    final state = lessonController.state;
    final double screenWidth = MediaQuery.of(context).size.width;

    final String ecoCode = (widget.ecosystem?.id ?? 'BOSQUE_ANDINO').toUpperCase();
    final _RouteVisualTheme theme = _RouteVisualTheme.forCode(ecoCode);
    final Color primaryColor = widget.ecosystem?.primaryColor ?? theme.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFD8F3DC),
      body: Stack(
        children: [
          // Fondo con gradiente y atmósfera inmersiva según el ecosistema
          Container(
            decoration: BoxDecoration(
              gradient: theme.backgroundGradient,
            ),
          ),

          // Contenido principal de la ruta
          _buildBodyContent(context, state, screenWidth, primaryColor, theme, ecoCode),

          // Header Flotante con identidad temática del ecosistema
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(state, primaryColor, theme),
          ),

          // FAB para volver al selector de ecosistemas
          Positioned(
            bottom: 24,
            left: 24,
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              foregroundColor: AppColors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              onPressed: widget.onBackToEcosystems,
              child: const Icon(Icons.explore_rounded, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    dynamic state,
    double screenWidth,
    Color primaryColor,
    _RouteVisualTheme theme,
    String ecoCode,
  ) {
    if (state.isLoading || state.isInitial) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              strokeWidth: 4,
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              'Cargando ruta de lecciones...',
              style: AppTypography.subheading.copyWith(color: AppColors.forestGreenDark),
            ),
          ],
        ),
      );
    }

    if (state.isError) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
          padding: const EdgeInsets.all(AppDimensions.space24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 60, color: AppColors.coral),
              const SizedBox(height: AppDimensions.space16),
              const Text(
                '¡Ups! No pudimos conectar con la ruta',
                style: AppTypography.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                state.errorMessage ?? 'Ocurrió un error al obtener las lecciones.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space20),
              AppButton(
                label: 'REINTENTAR',
                icon: Icons.refresh_rounded,
                onPressed: () => context
                    .read<LessonController>()
                    .loadLessons(_resolvedEcosystemId, forceRefresh: true),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
          padding: const EdgeInsets.all(AppDimensions.space24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_rounded, size: 60, color: AppColors.mediumGrey),
              const SizedBox(height: AppDimensions.space16),
              const Text(
                'No hay lecciones registradas aún',
                style: AppTypography.headingMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'Pronto se añadirán actividades para este ecosistema.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space20),
              AppButton(
                label: 'VOLVER',
                icon: Icons.arrow_back_rounded,
                onPressed: widget.onBackToEcosystems,
              ),
            ],
          ),
        ),
      );
    }

    // Nodos recibidos desde el backend o fallback
    final List<LessonNodeModel> nodes = state.nodes.isNotEmpty
        ? state.nodes
        : ExplorationMockData.bosqueAndinoNodes;

    const double startY = 220.0;
    const double nodeVerticalSpacing = 140.0;
    final double totalHeight = nodes.length * nodeVerticalSpacing + startY + 80.0;

    // Calcular las posiciones exactas de los nodos
    final List<Offset> nodePositions = [];
    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final double x = screenWidth * 0.5 + (node.xOffsetFraction * screenWidth * 0.7);
      final double y = startY + (i * nodeVerticalSpacing);
      nodePositions.add(Offset(x, y));
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: totalHeight,
        width: screenWidth,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. PAISAJE AMBIENTAL INMERSIVO (Árboles reales, Cordillera, Animales según ecosistema)
            CustomPaint(
              size: Size(screenWidth, totalHeight),
              painter: EcosystemRouteSceneryPainter(
                ecoCode: ecoCode,
                totalHeight: totalHeight,
              ),
            ),

            // 2. Trazo del camino serpenteante temático
            CustomPaint(
              size: Size(screenWidth, totalHeight),
              painter: WindingPathPainter(
                nodePositions: nodePositions,
                pathColor: theme.pathColor,
                borderColor: theme.borderColor,
              ),
            ),

            // 3. Nodos de lecciones centrados matemáticamente en la plataforma de la ruta
            for (int i = 0; i < nodes.length; i++)
              Positioned(
                left: nodePositions[i].dx - 100,
                top: nodePositions[i].dy - LessonNodeWidget.getNodeRadius(nodes[i].state == LessonNodeState.active),
                width: 200,
                child: LessonNodeWidget(
                  node: nodes[i],
                  onTap: () => widget.onStartActivity(nodes[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic state, Color primaryColor, _RouteVisualTheme theme) {
    final ecoName = widget.ecosystem?.name ?? 'Bosque Andino';
    final ecoIcon = widget.ecosystem?.mainIcon ?? Icons.forest_rounded;
    final totalNodes = state.nodes.isNotEmpty ? state.nodes.length : 12;
    final completedNodes = state.nodes.isNotEmpty
        ? state.nodes.where((n) => n.state == LessonNodeState.completed).length
        : 4;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppDimensions.space16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.card,
          border: Border.all(color: primaryColor.withValues(alpha: 0.35), width: 1.5),
        ),
        child: Row(
          children: [
            // Botón volver
            InkWell(
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              onTap: widget.onBackToEcosystems,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_rounded, color: primaryColor),
              ),
            ),
            const SizedBox(width: 12),

            // Nombre y subtítulo del ecosistema
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(ecoIcon, size: 18, color: primaryColor),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          ecoName,
                          style: AppTypography.headingMedium.copyWith(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    theme.routeSubtitle,
                    style: AppTypography.caption.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Badge de progreso / XP
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                border: Border.all(color: AppColors.gold, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: AppColors.goldDark),
                  const SizedBox(width: 4),
                  Text(
                    '$completedNodes/$totalNodes',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.goldDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteVisualTheme {
  final LinearGradient backgroundGradient;
  final Color pathColor;
  final Color borderColor;
  final String routeSubtitle;
  final Color primaryColor;

  const _RouteVisualTheme({
    required this.backgroundGradient,
    required this.pathColor,
    required this.borderColor,
    required this.routeSubtitle,
    required this.primaryColor,
  });

  static _RouteVisualTheme forCode(String rawCode) {
    final code = rawCode.toUpperCase();
    if (code.contains('PARAMO')) {
      return const _RouteVisualTheme(
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFECEFF1), Color(0xFFCFD8DC), Color(0xFFB0BEC5), Color(0xFF90A4AE)],
        ),
        pathColor: Color(0xFFCFD8DC),
        borderColor: Color(0xFF546E7A),
        routeSubtitle: 'Ruta de la Alta Montaña y Frailejones',
        primaryColor: Color(0xFF5D6D5F),
      );
    } else if (code.contains('OCEANO')) {
      return const _RouteVisualTheme(
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0F7FA), Color(0xFF80DEEA), Color(0xFF4DD0E1), Color(0xFF00838F)],
        ),
        pathColor: Color(0xFFFFF3E0),
        borderColor: Color(0xFF0097A7),
        routeSubtitle: 'Ruta de los Arrecifes y Aguas Profundas',
        primaryColor: Color(0xFF00838F),
      );
    } else if (code.contains('SELVA') || code.contains('AMAZON')) {
      return const _RouteVisualTheme(
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFF81C784), Color(0xFF1B5E20)],
        ),
        pathColor: Color(0xFFD7CCC8),
        borderColor: Color(0xFF3E2723),
        routeSubtitle: 'Ruta del Dosel y el Gran Río Amazonas',
        primaryColor: Color(0xFF1B5E20),
      );
    } else if (code.contains('MANGLAR')) {
      return const _RouteVisualTheme(
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB), Color(0xFF80CBC4), Color(0xFF00796B)],
        ),
        pathColor: Color(0xFFEFEBE9),
        borderColor: Color(0xFF4E342E),
        routeSubtitle: 'Ruta de las Raíces y Playas Costeras',
        primaryColor: Color(0xFF00796B),
      );
    } else if (code.contains('SECO') || code.contains('TROPICAL')) {
      return const _RouteVisualTheme(
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF3E0), Color(0xFFFFCC80), Color(0xFFFFB74D), Color(0xFFD84315)],
        ),
        pathColor: Color(0xFFFFF8E1),
        borderColor: Color(0xFFA1887F),
        routeSubtitle: 'Ruta del Sol, Cárcavas y Cardones de la Tatacoa',
        primaryColor: Color(0xFFD84315),
      );
    } else if (code.contains('LLANOS') || code.contains('SABANA')) {
      return const _RouteVisualTheme(
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF3E0), Color(0xFFFFCC80), Color(0xFFFFAB91), Color(0xFFD84315)],
        ),
        pathColor: Color(0xFFFFE0B2),
        borderColor: Color(0xFFBF360C),
        routeSubtitle: 'Ruta de la Sabana, Morichales y Gran Caño Llanero',
        primaryColor: Color(0xFFD84315),
      );
    } else {
      // Default: BOSQUE_ANDINO
      return const _RouteVisualTheme(
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8F5E9), Color(0xFFD8F3DC), Color(0xFFB7E4C7), Color(0xFF95D5B2)],
        ),
        pathColor: Color(0xFFE7D8C9),
        borderColor: Color(0xFF9C6644),
        routeSubtitle: 'Ruta de la Cordillera de los Andes',
        primaryColor: AppColors.forestGreen,
      );
    }
  }
}
