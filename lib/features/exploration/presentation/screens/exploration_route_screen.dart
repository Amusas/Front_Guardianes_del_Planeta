import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/lesson_node_model.dart';
import '../../data/exploration_mock_data.dart';
import '../widgets/lesson_node_widget.dart';
import '../widgets/winding_path_painter.dart';

class ExplorationRouteScreen extends StatefulWidget {
  final VoidCallback onBackToEcosystems;
  final Function(LessonNodeModel) onStartActivity;

  const ExplorationRouteScreen({
    super.key,
    required this.onBackToEcosystems,
    required this.onStartActivity,
  });

  @override
  State<ExplorationRouteScreen> createState() => _ExplorationRouteScreenState();
}

class _ExplorationRouteScreenState extends State<ExplorationRouteScreen> {
  final List<LessonNodeModel> _nodes = ExplorationMockData.bosqueAndinoNodes;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double nodeVerticalSpacing = 140.0;
    final double totalHeight = _nodes.length * nodeVerticalSpacing + 220;

    // Calcular las posiciones de los nodos para trazar el sendero continuo
    final List<Offset> nodePositions = [];
    for (int i = 0; i < _nodes.length; i++) {
      final node = _nodes[i];
      final double x = screenWidth * 0.5 + (node.xOffsetFraction * screenWidth * 0.7);
      final double y = 140.0 + (i * nodeVerticalSpacing);
      nodePositions.add(Offset(x, y));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD8F3DC),
      body: Stack(
        children: [
          // Fondo del bosque con gradiente y textura natural
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8F5E9),
                  Color(0xFFD8F3DC),
                  Color(0xFFB7E4C7),
                ],
              ),
            ),
          ),

          // Scroll vertical con mapa ilustrado
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: totalHeight,
              width: screenWidth,
              child: Stack(
                children: [
                  // 1. Elementos ambientales decorativos a los lados del camino
                  _buildEnvironmentalDecorations(screenWidth, totalHeight),

                  // 2. Trazo del camino serpenteante
                  CustomPaint(
                    size: Size(screenWidth, totalHeight),
                    painter: WindingPathPainter(nodePositions: nodePositions),
                  ),

                  // 3. Nodos de lecciones colocados en el camino
                  for (int i = 0; i < _nodes.length; i++)
                    Positioned(
                      left: nodePositions[i].dx - 80,
                      top: nodePositions[i].dy - 45,
                      width: 160,
                      child: LessonNodeWidget(
                        node: _nodes[i],
                        onTap: () => widget.onStartActivity(_nodes[i]),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 4. Header Flotante Parcialmente Transparente
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(AppDimensions.space16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                  boxShadow: AppShadows.card,
                  border: Border.all(color: AppColors.pastelGreen, width: 1.5),
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
                          color: AppColors.forestGreen.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: AppColors.forestGreen),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Nombre y progreso del ecosistema
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.forest_rounded, size: 18, color: AppColors.forestGreen),
                              const SizedBox(width: 6),
                              Text(
                                'Bosque Andino',
                                style: AppTypography.headingMedium.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '4 / 12 actividades completadas',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.forestGreenDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // XP Total
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        border: Border.all(color: AppColors.gold, width: 1.5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star_rounded, size: 18, color: AppColors.goldDark),
                          SizedBox(width: 4),
                          Text(
                            '1,250 XP',
                            style: TextStyle(
                              fontSize: 13,
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
            ),
          ),

          // 5. FAB en la esquina inferior izquierda para volver al selector
          Positioned(
            bottom: 24,
            left: 24,
            child: FloatingActionButton(
              backgroundColor: AppColors.forestGreen,
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

  Widget _buildEnvironmentalDecorations(double width, double height) {
    return Stack(
      children: [
        // Árboles y vegetación estilizada
        Positioned(top: 100, left: 20, child: _treeIcon(Icons.park_rounded, 42, const Color(0xFF2D6A4F))),
        Positioned(top: 260, right: 30, child: _treeIcon(Icons.forest_rounded, 48, const Color(0xFF40916C))),
        Positioned(top: 420, left: 35, child: _treeIcon(Icons.park_rounded, 38, const Color(0xFF1B4332))),
        Positioned(top: 590, right: 25, child: _treeIcon(Icons.nature_rounded, 46, const Color(0xFF52B788))),
        Positioned(top: 750, left: 28, child: _treeIcon(Icons.forest_rounded, 44, const Color(0xFF2D6A4F))),
        Positioned(top: 920, right: 40, child: _treeIcon(Icons.park_rounded, 40, const Color(0xFF40916C))),

        // Flores y mariposas
        Positioned(top: 200, right: 80, child: const Icon(Icons.local_florist_rounded, color: AppColors.coral, size: 22)),
        Positioned(top: 360, left: 90, child: const Icon(Icons.spa_rounded, color: AppColors.emerald, size: 20)),
        Positioned(top: 520, right: 90, child: const Icon(Icons.local_florist_rounded, color: AppColors.gold, size: 22)),
        Positioned(top: 680, left: 70, child: const Icon(Icons.spa_rounded, color: AppColors.emerald, size: 20)),

        // Piedras del camino
        Positioned(top: 300, left: 140, child: _rockWidget()),
        Positioned(top: 630, right: 130, child: _rockWidget()),
      ],
    );
  }

  Widget _treeIcon(IconData icon, double size, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Icon(icon, size: size, color: color),
    );
  }

  Widget _rockWidget() {
    return Container(
      width: 18,
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xFF9E9E9E),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
