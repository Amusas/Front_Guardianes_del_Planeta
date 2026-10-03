import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/ecosystem_model.dart';

/// Tarjeta de Ecosistema con Isla Flotante Isométrica y bucle de animación suave (3.5s).
class EcosystemCarouselCard extends StatefulWidget {
  final EcosystemModel ecosystem;
  final bool isSelected;
  final VoidCallback onTap;

  const EcosystemCarouselCard({
    super.key,
    required this.ecosystem,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<EcosystemCarouselCard> createState() => _EcosystemCarouselCardState();
}

class _EcosystemCarouselCardState extends State<EcosystemCarouselCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eco = widget.ecosystem;
    final scale = widget.isSelected ? 1.0 : 0.88;

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            final floatOffset = widget.isSelected ? _floatAnimation.value : 0.0;
            return Transform.translate(
              offset: Offset(0, floatOffset),
              child: child,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            padding: const EdgeInsets.all(AppDimensions.space20),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(widget.isSelected ? 0.95 : 0.82),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              boxShadow: widget.isSelected ? AppShadows.floatingIsland : AppShadows.card,
              border: Border.all(
                color: widget.isSelected ? eco.primaryColor : Colors.white.withOpacity(0.5),
                width: widget.isSelected ? 3.0 : 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Encabezado de la tarjeta
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: eco.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                      ),
                      child: Row(
                        children: [
                          Icon(eco.mainIcon, size: 18, color: eco.primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            eco.isLocked ? 'Bloqueado' : '${(eco.progress * 100).toInt()}% explorado',
                            style: AppTypography.caption.copyWith(
                              color: eco.primaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (eco.isLocked)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.locked,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock_rounded, size: 16, color: AppColors.white),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star_rounded, size: 18, color: AppColors.goldDark),
                      ),
                  ],
                ),

                // Representación de Isla Flotante Isométrica
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 260,
                      height: 240,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(260, 240),
                            painter: _IsometricIslandPainter(ecosystem: eco),
                          ),
                          if (eco.isLocked)
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                color: AppColors.darkText.withOpacity(0.65),
                                shape: BoxShape.circle,
                                boxShadow: AppShadows.card,
                              ),
                              child: const Icon(Icons.lock_rounded, color: AppColors.white, size: 36),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Textos descriptivos
                Column(
                  children: [
                    Text(
                      eco.name,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.darkText,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      eco.subtitle,
                      style: AppTypography.caption.copyWith(
                        color: eco.primaryColor,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      eco.description,
                      style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// CustomPainter que dibuja la isla flotante isométrica con sus capas de tierra, río, montañas y naturaleza.
class _IsometricIslandPainter extends CustomPainter {
  final EcosystemModel ecosystem;

  _IsometricIslandPainter({required this.ecosystem});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Sombra flotante debajo de la isla
    final Paint shadowPaint = Paint()
      ..color = AppColors.darkText.withOpacity(0.14)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.90), width: w * 0.75, height: 26),
      shadowPaint,
    );

    // Vértices del rombo isométrico de la superficie
    final Offset top = Offset(w * 0.5, h * 0.32);
    final Offset right = Offset(w * 0.92, h * 0.52);
    final Offset bottom = Offset(w * 0.5, h * 0.72);
    final Offset left = Offset(w * 0.08, h * 0.52);

    // 1. Capa geológica inferior de tierra / roca
    final Path rockLeft = Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(bottom.dx, bottom.dy + 42)
      ..lineTo(left.dx, left.dy + 35)
      ..close();
    final Paint rockLeftPaint = Paint()
      ..color = ecosystem.id == 'oceano'
          ? const Color(0xFF0077B6)
          : ecosystem.id == 'paramo'
              ? const Color(0xFF455A64)
              : const Color(0xFF6C584C);
    canvas.drawPath(rockLeft, rockLeftPaint);

    final Path rockRight = Path()
      ..moveTo(bottom.dx, bottom.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(right.dx, right.dy + 35)
      ..lineTo(bottom.dx, bottom.dy + 42)
      ..close();
    final Paint rockRightPaint = Paint()
      ..color = ecosystem.id == 'oceano'
          ? const Color(0xFF023E8A)
          : ecosystem.id == 'paramo'
              ? const Color(0xFF37474F)
              : const Color(0xFF533E2D);
    canvas.drawPath(rockRight, rockRightPaint);

    // Estrato inferior puntiagudo
    final Path rockTip = Path()
      ..moveTo(bottom.dx - 40, bottom.dy + 40)
      ..lineTo(bottom.dx, bottom.dy + 65)
      ..lineTo(bottom.dx + 40, bottom.dy + 40)
      ..close();
    final Paint tipPaint = Paint()
      ..color = ecosystem.id == 'oceano'
          ? const Color(0xFF03045E)
          : const Color(0xFF3E2723);
    canvas.drawPath(rockTip, tipPaint);

    // 2. Superficie vegetal / acuática de la isla
    final Path surface = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();

    final Paint surfacePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: ecosystem.id == 'oceano'
            ? [const Color(0xFF48CAE4), const Color(0xFF0096C7)]
            : ecosystem.id == 'paramo'
                ? [const Color(0xFF90A4AE), const Color(0xFF607D8B)]
                : [const Color(0xFF74C69D), const Color(0xFF40916C)],
      ).createShader(Rect.fromLTWH(0, top.dy, w, bottom.dy - top.dy));

    canvas.drawPath(surface, surfacePaint);

    // 3. Detalles según ecosistema
    if (ecosystem.id == 'bosque_andino') {
      // Río cristalino que cruza la isla
      final Path river = Path()
        ..moveTo(w * 0.48, top.dy + 15)
        ..quadraticBezierTo(w * 0.40, h * 0.52, w * 0.54, h * 0.58)
        ..quadraticBezierTo(w * 0.60, h * 0.64, bottom.dx + 8, bottom.dy)
        ..lineTo(bottom.dx - 8, bottom.dy)
        ..quadraticBezierTo(w * 0.48, h * 0.64, w * 0.35, h * 0.52)
        ..quadraticBezierTo(w * 0.44, top.dy + 15, w * 0.48, top.dy + 15)
        ..close();
      final Paint riverPaint = Paint()..color = const Color(0xFF48CAE4);
      canvas.drawPath(river, riverPaint);

      // Cascada que cae del borde
      final Path waterfall = Path()
        ..moveTo(bottom.dx - 8, bottom.dy)
        ..lineTo(bottom.dx + 8, bottom.dy)
        ..lineTo(bottom.dx + 6, bottom.dy + 38)
        ..lineTo(bottom.dx - 6, bottom.dy + 38)
        ..close();
      final Paint waterfallPaint = Paint()..color = const Color(0xCCADE8F4);
      canvas.drawPath(waterfall, waterfallPaint);

      // Montañas verdes de fondo
      final Paint mountainPaint = Paint()..color = const Color(0xFF2D6A4F);
      final Path mtn = Path()
        ..moveTo(w * 0.28, h * 0.45)
        ..lineTo(w * 0.40, h * 0.24)
        ..lineTo(w * 0.52, h * 0.45)
        ..close();
      canvas.drawPath(mtn, mountainPaint);

      // Palmas de cera (tronco blanco fino y penacho verde)
      _drawPalm(canvas, Offset(w * 0.72, h * 0.48), 38);
      _drawPalm(canvas, Offset(w * 0.62, h * 0.44), 48);
      _drawPalm(canvas, Offset(w * 0.22, h * 0.52), 32);

      // Nube flotante
      _drawCloud(canvas, Offset(w * 0.32, h * 0.20), 22);

      // Mariposa dorada
      final Paint butterfly = Paint()..color = AppColors.gold;
      canvas.drawCircle(Offset(w * 0.68, h * 0.38), 3, butterfly);
      canvas.drawCircle(Offset(w * 0.72, h * 0.36), 3, butterfly);
    } else if (ecosystem.id == 'paramo') {
      // Frailejones (rosetas circulares con hojas doradas/plateadas)
      _drawFrailejon(canvas, Offset(w * 0.38, h * 0.50), 16);
      _drawFrailejon(canvas, Offset(w * 0.65, h * 0.52), 18);
      _drawFrailejon(canvas, Offset(w * 0.50, h * 0.58), 20);

      // Laguna glaciar
      final Paint lagoon = Paint()..color = const Color(0xFF81D4FA);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.35, h * 0.56), width: 35, height: 16),
        lagoon,
      );

      // Montañas nevadas frías
      final Paint peak = Paint()..color = const Color(0xFFECEFF1);
      final Path peakPath = Path()
        ..moveTo(w * 0.42, h * 0.40)
        ..lineTo(w * 0.54, h * 0.20)
        ..lineTo(w * 0.66, h * 0.40)
        ..close();
      canvas.drawPath(peakPath, peak);

      // Neblina suave
      _drawCloud(canvas, Offset(w * 0.50, h * 0.32), 32);
    } else {
      // Océano: Corales y tortuga
      final Paint coralPaint = Paint()..color = AppColors.coral;
      canvas.drawCircle(Offset(w * 0.35, h * 0.52), 8, coralPaint);
      canvas.drawCircle(Offset(w * 0.68, h * 0.54), 10, coralPaint);

      // Burbujas
      final Paint bubble = Paint()..color = AppColors.white.withOpacity(0.65);
      canvas.drawCircle(Offset(w * 0.45, h * 0.42), 4, bubble);
      canvas.drawCircle(Offset(w * 0.52, h * 0.36), 3, bubble);
      canvas.drawCircle(Offset(w * 0.58, h * 0.46), 5, bubble);
    }
  }

  void _drawPalm(Canvas canvas, Offset base, double height) {
    // Tronco alto y blanco característico de la Palma de Cera del Quindío
    final Paint trunkPaint = Paint()
      ..color = const Color(0xFFEDEDE9)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(base, Offset(base.dx, base.dy - height), trunkPaint);

    // Corona de hojas
    final Paint crownPaint = Paint()..color = const Color(0xFF1B4332);
    final Offset top = Offset(base.dx, base.dy - height);
    canvas.drawCircle(top, 7, crownPaint);
    canvas.drawCircle(Offset(top.dx - 5, top.dy + 2), 5, crownPaint);
    canvas.drawCircle(Offset(top.dx + 5, top.dy + 2), 5, crownPaint);
  }

  void _drawFrailejon(Canvas canvas, Offset base, double radius) {
    final Paint trunk = Paint()
      ..color = const Color(0xFF4E342E)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(base, Offset(base.dx, base.dy - 12), trunk);

    final Paint rosette = Paint()..color = const Color(0xFFFFF176);
    canvas.drawCircle(Offset(base.dx, base.dy - 14), radius * 0.5, rosette);
  }

  void _drawCloud(Canvas canvas, Offset pos, double size) {
    final Paint cloud = Paint()..color = AppColors.white.withOpacity(0.7);
    canvas.drawCircle(pos, size * 0.4, cloud);
    canvas.drawCircle(Offset(pos.dx + size * 0.3, pos.dy), size * 0.3, cloud);
    canvas.drawCircle(Offset(pos.dx - size * 0.3, pos.dy + 2), size * 0.28, cloud);
  }

  @override
  bool shouldRepaint(covariant _IsometricIslandPainter oldDelegate) =>
      oldDelegate.ecosystem != ecosystem;
}
