import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Overlay de confeti y partículas celebratorias (doradas, verdes esmeralda y turquesa)
/// para respuestas correctas y recompensas de XP.
class ConfettiOverlay extends StatefulWidget {
  final VoidCallback? onComplete;

  const ConfettiOverlay({super.key, this.onComplete});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Generar 35 partículas con trayectorias naturales
    for (int i = 0; i < 35; i++) {
      _particles.add(
        _Particle(
          angle: _random.nextDouble() * 2 * math.pi,
          speed: 80 + _random.nextDouble() * 180,
          color: [
            AppColors.gold,
            AppColors.emerald,
            AppColors.turquoise,
            AppColors.coral,
            AppColors.goldLight,
            AppColors.forestGreen,
          ][_random.nextInt(6)],
          radius: 4 + _random.nextDouble() * 6,
          isStar: i % 3 == 0,
        ),
      );
    }

    _controller.forward().then((_) {
      if (widget.onComplete != null) widget.onComplete!();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final Color color;
  final double radius;
  final bool isStar;

  _Particle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.radius,
    required this.isStar,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.5, size.height * 0.4);
    final double opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (final p in particles) {
      final double distance = p.speed * progress;
      final double gravity = 120 * progress * progress;
      final double x = center.dx + math.cos(p.angle) * distance;
      final double y = center.dy + math.sin(p.angle) * distance + gravity;

      final Paint paint = Paint()
        ..color = p.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      if (p.isStar) {
        // Dibujar pequeñas estrellas o diamantes
        final Path star = Path()
          ..moveTo(x, y - p.radius * 1.3)
          ..lineTo(x + p.radius * 0.6, y - p.radius * 0.3)
          ..lineTo(x + p.radius * 1.3, y)
          ..lineTo(x + p.radius * 0.6, y + p.radius * 0.3)
          ..lineTo(x, y + p.radius * 1.3)
          ..lineTo(x - p.radius * 0.6, y + p.radius * 0.3)
          ..lineTo(x - p.radius * 1.3, y)
          ..lineTo(x - p.radius * 0.6, y - p.radius * 0.3)
          ..close();
        canvas.drawPath(star, paint);
      } else {
        canvas.drawCircle(Offset(x, y), p.radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
