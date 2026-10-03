import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

enum MascotExpression { happy, excited, thinking, surprised, celebrating, encouraging }

/// Mascota oficial "El Guardián": Un amigable espíritu de la naturaleza con cuerpo verde redondeado,
/// cresta de hojas vivas, grandes ojos expresivos y microinteracciones según el estado emocional.
class MascotWidget extends StatefulWidget {
  final MascotExpression expression;
  final double size;
  final bool isAnimated;

  const MascotWidget({
    super.key,
    this.expression = MascotExpression.happy,
    this.size = 110.0,
    this.isAnimated = true,
  });

  @override
  State<MascotWidget> createState() => _MascotWidgetState();
}

class _MascotWidgetState extends State<MascotWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOutSine,
      ),
    );

    if (widget.isAnimated) {
      _animController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        final offsetY = widget.isAnimated ? _bounceAnimation.value : 0.0;
        return Transform.translate(
          offset: Offset(0, offsetY),
          child: SizedBox(
            width: widget.size,
            height: widget.size * 1.15,
            child: CustomPaint(
              painter: _MascotPainter(expression: widget.expression),
            ),
          ),
        );
      },
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotExpression expression;

  _MascotPainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Centro del cuerpo
    final Offset center = Offset(w * 0.5, h * 0.62);
    final double bodyRadius = w * 0.38;

    // Sombra en el suelo
    final Paint groundShadow = Paint()
      ..color = const Color(0x221B4332)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.96), width: w * 0.7, height: h * 0.12),
      groundShadow,
    );

    // 1. Cresta de hojas vivas en la cabeza (Sprout)
    final Paint leafPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.emerald, AppColors.forestGreenDark],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(w * 0.3, h * 0.05, w * 0.4, h * 0.3))
      ..style = PaintingStyle.fill;

    // Hoja izquierda
    final Path leafLeft = Path()
      ..moveTo(w * 0.5, h * 0.30)
      ..quadraticBezierTo(w * 0.30, h * 0.16, w * 0.32, h * 0.08)
      ..quadraticBezierTo(w * 0.46, h * 0.10, w * 0.5, h * 0.30)
      ..close();
    canvas.drawPath(leafLeft, leafPaint);

    // Hoja derecha (ligeramente más alta y con brillo)
    final Path leafRight = Path()
      ..moveTo(w * 0.5, h * 0.30)
      ..quadraticBezierTo(w * 0.70, h * 0.14, w * 0.66, h * 0.05)
      ..quadraticBezierTo(w * 0.52, h * 0.10, w * 0.5, h * 0.30)
      ..close();
    canvas.drawPath(leafRight, leafPaint);

    // 2. Cuerpo redondo y simpático (Gradiente Esmeralda a Verde Bosque)
    final Paint bodyPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.35),
        radius: 0.9,
        colors: [Color(0xFF74C69D), AppColors.emerald, AppColors.forestGreen],
      ).createShader(Rect.fromCircle(center: center, radius: bodyRadius));

    canvas.drawCircle(center, bodyRadius, bodyPaint);

    // Brillo sutil superior del cuerpo
    final Paint highlightPaint = Paint()
      ..color = AppColors.white.withOpacity(0.32)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bodyRadius * 0.28, center.dy - bodyRadius * 0.4),
        width: bodyRadius * 0.65,
        height: bodyRadius * 0.38,
      ),
      highlightPaint,
    );

    // 3. Pequeños coloretes rosados amigables en las mejillas
    final Paint blushPaint = Paint()
      ..color = const Color(0x55FF758F)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - bodyRadius * 0.58, center.dy + bodyRadius * 0.12),
        width: bodyRadius * 0.32,
        height: bodyRadius * 0.2,
      ),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + bodyRadius * 0.58, center.dy + bodyRadius * 0.12),
        width: bodyRadius * 0.32,
        height: bodyRadius * 0.2,
      ),
      blushPaint,
    );

    // 4. Ojos grandes según la expresión
    final double eyeSpacing = bodyRadius * 0.42;
    final double eyeY = center.dy - bodyRadius * 0.08;

    if (expression == MascotExpression.celebrating || expression == MascotExpression.happy) {
      // Ojos en arco sonriente feliz ^ ^
      final Paint smileEyePaint = Paint()
        ..color = AppColors.darkText
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      final Path leftEyeArc = Path()
        ..moveTo(center.dx - eyeSpacing - 10, eyeY + 2)
        ..quadraticBezierTo(center.dx - eyeSpacing, eyeY - 12, center.dx - eyeSpacing + 10, eyeY + 2);
      final Path rightEyeArc = Path()
        ..moveTo(center.dx + eyeSpacing - 10, eyeY + 2)
        ..quadraticBezierTo(center.dx + eyeSpacing, eyeY - 12, center.dx + eyeSpacing + 10, eyeY + 2);

      canvas.drawPath(leftEyeArc, smileEyePaint);
      canvas.drawPath(rightEyeArc, smileEyePaint);
    } else {
      // Ojos grandes con brillo blanco
      final Paint eyeSclera = Paint()..color = AppColors.darkText;
      final Paint eyeGleam = Paint()..color = AppColors.white;

      final double eyeR = (expression == MascotExpression.surprised) ? 10.0 : 8.5;

      // Ojo izquierdo
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), eyeR, eyeSclera);
      canvas.drawCircle(Offset(center.dx - eyeSpacing - 2.5, eyeY - 2.5), eyeR * 0.42, eyeGleam);
      canvas.drawCircle(Offset(center.dx - eyeSpacing + 2.5, eyeY + 2.5), eyeR * 0.2, eyeGleam);

      // Ojo derecho
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), eyeR, eyeSclera);
      canvas.drawCircle(Offset(center.dx + eyeSpacing - 2.5, eyeY - 2.5), eyeR * 0.42, eyeGleam);
      canvas.drawCircle(Offset(center.dx + eyeSpacing + 2.5, eyeY + 2.5), eyeR * 0.2, eyeGleam);
    }

    // 5. Boca según la expresión
    final Paint mouthPaint = Paint()
      ..color = AppColors.darkText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    if (expression == MascotExpression.celebrating || expression == MascotExpression.excited) {
      // Gran boca abierta alegre con lengua rosada
      final Paint openMouthPaint = Paint()..color = const Color(0xFFC9184A);
      final Path openMouth = Path()
        ..moveTo(center.dx - 12, center.dy + bodyRadius * 0.22)
        ..quadraticBezierTo(center.dx, center.dy + bodyRadius * 0.55, center.dx + 12, center.dy + bodyRadius * 0.22)
        ..close();
      canvas.drawPath(openMouth, openMouthPaint);
      canvas.drawPath(openMouth, mouthPaint);
    } else if (expression == MascotExpression.thinking) {
      // Pequeña boca pensativa a un lado
      canvas.drawLine(
        Offset(center.dx - 4, center.dy + bodyRadius * 0.26),
        Offset(center.dx + 10, center.dy + bodyRadius * 0.24),
        mouthPaint,
      );
    } else {
      // Sonrisa dulce
      final Path smile = Path()
        ..moveTo(center.dx - 9, center.dy + bodyRadius * 0.22)
        ..quadraticBezierTo(center.dx, center.dy + bodyRadius * 0.38, center.dx + 9, center.dy + bodyRadius * 0.22);
      canvas.drawPath(smile, mouthPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.expression != expression;
}
