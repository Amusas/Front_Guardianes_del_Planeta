import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// CustomPainter que traza el camino serpenteante orgánico en color beige/tierra clara,
/// uniendo todos los nodos de actividades con curvas suaves de Bézier y bordes de piedra.
class WindingPathPainter extends CustomPainter {
  final List<Offset> nodePositions;

  WindingPathPainter({required this.nodePositions});

  @override
  void paint(Canvas canvas, Size size) {
    if (nodePositions.length < 2) return;

    final Path mainPath = Path();
    mainPath.moveTo(nodePositions.first.dx, nodePositions.first.dy);

    for (int i = 0; i < nodePositions.length - 1; i++) {
      final p0 = nodePositions[i];
      final p1 = nodePositions[i + 1];

      // Punto de control intermedio para curvatura natural
      final controlPoint1 = Offset(p0.dx, p0.dy + (p1.dy - p0.dy) * 0.5);
      final controlPoint2 = Offset(p1.dx, p0.dy + (p1.dy - p0.dy) * 0.5);

      mainPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    // 1. Sombra / Borde exterior del sendero
    final Paint borderPaint = Paint()
      ..color = AppColors.pathBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 36.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(mainPath, borderPaint);

    // 2. Capa principal de tierra / arena clara
    final Paint pathPaint = Paint()
      ..color = AppColors.pathSand
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(mainPath, pathPaint);

    // 3. Huellas o piedras centrales intermitentes para textura
    final Paint stonesPaint = Paint()
      ..color = AppColors.pathEarth
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (final pos in nodePositions) {
      canvas.drawCircle(Offset(pos.dx, pos.dy), 32, Paint()..color = AppColors.pathSand);
      canvas.drawCircle(Offset(pos.dx, pos.dy), 34, Paint()
        ..color = AppColors.pathBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3);
    }
  }

  @override
  bool shouldRepaint(covariant WindingPathPainter oldDelegate) => true;
}
