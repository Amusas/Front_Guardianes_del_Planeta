import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// CustomPainter que traza el camino serpenteante orgánico en color beige/tierra clara,
/// uniendo todos los nodos de actividades con curvas suaves de Bézier y bordes de piedra.
class WindingPathPainter extends CustomPainter {
  final List<Offset> nodePositions;
  final Color? pathColor;
  final Color? borderColor;

  WindingPathPainter({
    required this.nodePositions,
    this.pathColor,
    this.borderColor,
  });

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

    final Color effectiveBorder = borderColor ?? AppColors.pathBorder;
    final Color effectivePath = pathColor ?? AppColors.pathSand;

    // 1. Sombra / Borde exterior del sendero
    final Paint borderPaint = Paint()
      ..color = effectiveBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 36.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(mainPath, borderPaint);

    // 2. Capa principal de tierra / arena clara
    final Paint paintPath = Paint()
      ..color = effectivePath
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(mainPath, paintPath);

    for (final pos in nodePositions) {
      canvas.drawCircle(pos, 38, Paint()..color = effectivePath);
      canvas.drawCircle(
        pos,
        40,
        Paint()
          ..color = effectiveBorder
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WindingPathPainter oldDelegate) => true;
}
