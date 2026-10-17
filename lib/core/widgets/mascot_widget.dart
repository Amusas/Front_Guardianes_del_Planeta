import 'dart:math' as math;
import 'package:flutter/material.dart';

enum MascotExpression {
  smiling,     // Sonriente la mayor parte del tiempo (al querer responder, seleccionando, reposo)
  happy,       // Feliz / Celebrando (completar ecosistema/lección, respuesta correcta, cargando actividades)
  worried,     // Preocupado / ojos llorones (respuesta incorrecta)

  // Compatibilidad con código previo:
  excited,
  thinking,
  surprised,
  celebrating,
  encouraging,
}

/// Mascota oficial gamificada para los ecosistemas de "Guardianes del Planeta".
/// Para el Bosque Andino: Vector dinámico del Oso de Anteojos (*Tremarctos ornatus*).
/// Para otros ecosistemas: Espíritu Guardián de la Naturaleza con cresta de hojas.
class MascotWidget extends StatefulWidget {
  final MascotExpression expression;
  final double size;
  final bool isAnimated;
  final String? ecosystemCode;

  const MascotWidget({
    super.key,
    this.expression = MascotExpression.smiling,
    this.size = 110.0,
    this.isAnimated = true,
    this.ecosystemCode,
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
  void didUpdateWidget(covariant MascotWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isAnimated != widget.isAnimated) {
      if (widget.isAnimated) {
        _animController.repeat(reverse: true);
      } else {
        _animController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  CustomPainter _resolvePainter(String? rawCode) {
    final String code = (rawCode ?? 'BOSQUE_ANDINO').toUpperCase();

    if (code.contains('PARAMO') || code.contains('FRAILEJON') || code == '2') {
      return _FrailejonGuanePainter(expression: widget.expression);
    } else if (code.contains('OCEANO') || code.contains('TORTUGA') || code == '3') {
      return _TortugaMarinaPainter(expression: widget.expression);
    } else if (code.contains('SELVA') || code.contains('AMAZON') || code.contains('ANACONDA') || code == '4') {
      return _AnacondaVerdePainter(expression: widget.expression);
    } else if (code.contains('MANGLAR') || code.contains('CANGREJO') || code == '5') {
      return _CangrejoManglarPainter(expression: widget.expression);
    } else if (code.contains('SECO') || code.contains('TROPICAL') || code.contains('IGUANA') || code == '6') {
      return _IguanaVerdePainter(expression: widget.expression);
    } else if (code.contains('LLANOS') || code.contains('SABANA') || code.contains('CHIGUIRO') || code == '7') {
      return _ChiguiroPainter(expression: widget.expression);
    } else {
      // 1: BOSQUE_ANDINO / OSO_ANDINO (o por defecto)
      return _OsoDeAnteojosPainter(expression: widget.expression);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CustomPainter painter = _resolvePainter(widget.ecosystemCode);

    return IgnorePointer(
      child: SizedBox(
        width: widget.size,
        height: widget.size * 1.15,
        child: widget.isAnimated
            ? AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) {
                  final offsetY = _bounceAnimation.value;
                  return Transform.translate(
                    offset: Offset(0, offsetY),
                    child: CustomPaint(
                      size: Size(widget.size, widget.size * 1.15),
                      painter: painter,
                    ),
                  );
                },
              )
            : CustomPaint(
                size: Size(widget.size, widget.size * 1.15),
                painter: painter,
              ),
      ),
    );
  }
}

/// Vector del Oso de Anteojos (*Tremarctos ornatus*) del Bosque Andino.
/// Cuenta con las 3 expresiones: sonriente, feliz y preocupado/ojos llorones.
class _OsoDeAnteojosPainter extends CustomPainter {
  final MascotExpression expression;

  _OsoDeAnteojosPainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final bool isWorried = expression == MascotExpression.worried;
    final bool isHappy = expression == MascotExpression.happy ||
        expression == MascotExpression.celebrating ||
        expression == MascotExpression.excited ||
        expression == MascotExpression.surprised;

    // Sombra suave en el suelo
    final Paint groundShadow = Paint()
      ..color = const Color(0x221B4332)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.95), width: w * 0.70, height: h * 0.10),
      groundShadow,
    );

    // Centro y proporciones maestras de la cabeza del oso
    final Offset center = Offset(w * 0.5, h * 0.50);
    final double R = w * 0.36; // Radio base proporcional

    // Paleta de color del Oso de Anteojos
    const Color furDark = Color(0xFF261D17);
    const Color furBrown = Color(0xFF382C24);
    const Color furHighlight = Color(0xFF4A3B31);
    const Color creamPatch = Color(0xFFF7ECD5); // Anteojos y hocico
    const Color creamPatchBorder = Color(0xFFEADBBE);
    const Color innerEarColor = Color(0xFFE8DCC4);
    const Color darkFeatureColor = Color(0xFF14100D);

    // 1. OREJAS REDONDAS Y TIERNAS
    final double earRadius = R * 0.30;
    final Offset leftEarCenter = Offset(center.dx - R * 0.68, center.dy - R * 0.70);
    final Offset rightEarCenter = Offset(center.dx + R * 0.68, center.dy - R * 0.70);

    final Paint earPaint = Paint()
      ..shader = const RadialGradient(
        colors: [furHighlight, furDark],
      ).createShader(Rect.fromCircle(center: leftEarCenter, radius: earRadius));

    canvas.drawCircle(leftEarCenter, earRadius, earPaint);
    canvas.drawCircle(rightEarCenter, earRadius, earPaint);

    final Paint innerEarPaint = Paint()..color = innerEarColor;
    canvas.drawCircle(leftEarCenter, earRadius * 0.52, innerEarPaint);
    canvas.drawCircle(rightEarCenter, earRadius * 0.52, innerEarPaint);

    // 2. CABEZA PRINCIPAL
    final Paint headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        radius: 0.95,
        colors: [furHighlight, furBrown, furDark],
      ).createShader(Rect.fromCircle(center: center, radius: R));

    canvas.drawOval(
      Rect.fromCenter(center: center, width: R * 2.0, height: R * 1.90),
      headPaint,
    );

    // Mechón simpático de pelito arriba
    final Path tuft = Path()
      ..moveTo(center.dx - R * 0.12, center.dy - R * 0.93)
      ..quadraticBezierTo(center.dx, center.dy - R * 1.10, center.dx + R * 0.12, center.dy - R * 0.93)
      ..close();
    canvas.drawPath(tuft, Paint()..color = furDark);

    // 3. ANTEOJOS EMBLEMÁTICOS (Manchas crema alrededor de los ojos)
    final double eyeSpacing = R * 0.35;
    final double eyeY = center.dy - R * 0.05;

    final Paint patchPaint = Paint()
      ..color = creamPatch
      ..style = PaintingStyle.fill;
    final Paint patchStroke = Paint()
      ..color = creamPatchBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.035).clamp(1.0, 2.0);

    // Anteojo izquierdo
    final Rect leftPatchRect = Rect.fromCenter(
      center: Offset(center.dx - eyeSpacing, eyeY),
      width: R * 0.52,
      height: R * 0.52,
    );
    canvas.drawOval(leftPatchRect, patchPaint);
    canvas.drawOval(leftPatchRect, patchStroke);

    // Anteojo derecho
    final Rect rightPatchRect = Rect.fromCenter(
      center: Offset(center.dx + eyeSpacing, eyeY),
      width: R * 0.52,
      height: R * 0.52,
    );
    canvas.drawOval(rightPatchRect, patchPaint);
    canvas.drawOval(rightPatchRect, patchStroke);

    // Puente crema que conecta suavemente los anteojos hacia el hocico
    final Path patchBridge = Path()
      ..moveTo(center.dx - eyeSpacing * 0.65, eyeY + R * 0.10)
      ..quadraticBezierTo(center.dx, eyeY, center.dx + eyeSpacing * 0.65, eyeY + R * 0.10)
      ..lineTo(center.dx + eyeSpacing * 0.70, center.dy + R * 0.22)
      ..lineTo(center.dx - eyeSpacing * 0.70, center.dy + R * 0.22)
      ..close();
    canvas.drawPath(patchBridge, patchPaint);

    // 4. HOCICO CREMA Y NARICITA
    final Rect muzzleRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + R * 0.22),
      width: R * 0.78,
      height: R * 0.52,
    );
    canvas.drawOval(muzzleRect, patchPaint);
    canvas.drawOval(muzzleRect, patchStroke);

    // Naricita negra redondeada
    final double noseY = center.dy + R * 0.10;
    final Paint nosePaint = Paint()..color = darkFeatureColor;
    final double noseHalfW = R * 0.11;
    final double noseH = R * 0.13;
    final Path nosePath = Path()
      ..moveTo(center.dx - noseHalfW, noseY)
      ..quadraticBezierTo(center.dx, noseY - R * 0.03, center.dx + noseHalfW, noseY)
      ..quadraticBezierTo(center.dx + noseHalfW * 0.8, noseY + noseH * 0.8, center.dx, noseY + noseH)
      ..quadraticBezierTo(center.dx - noseHalfW * 0.8, noseY + noseH * 0.8, center.dx - noseHalfW, noseY)
      ..close();
    canvas.drawPath(nosePath, nosePaint);

    // Brillo sutil en la naricita
    canvas.drawCircle(
      Offset(center.dx - noseHalfW * 0.35, noseY + noseH * 0.25),
      (R * 0.025).clamp(0.8, 1.8),
      Paint()..color = Colors.white.withValues(alpha: 0.65),
    );

    // Línea que baja de la nariz a la boca (philtrum)
    final double mouthStartY = noseY + noseH;
    final double mouthY = mouthStartY + R * 0.06;
    final Paint linePaint = Paint()
      ..color = darkFeatureColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.045).clamp(1.2, 2.5)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(center.dx, mouthStartY), Offset(center.dx, mouthY), linePaint);

    // 5. EXPRESIONES: OJOS Y BOCA PROPORCIONADOS Y TIERNOS
    final double eyeR = R * 0.105; // Tamaño equilibrado de ojo tipo botón

    if (isHappy) {
      // --- EXPRESIÓN 1: FELIZ (Celebrando logro, respuesta correcta, cargando) ---
      final Paint happyEyePaint = Paint()
        ..color = darkFeatureColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.055).clamp(1.4, 2.8)
        ..strokeCap = StrokeCap.round;

      final double arcW = R * 0.085;
      final double arcH = R * 0.065;

      // Ojo izquierdo alegre en arco ^
      final Path leftHappyEye = Path()
        ..moveTo(center.dx - eyeSpacing - arcW, eyeY + arcH * 0.3)
        ..quadraticBezierTo(center.dx - eyeSpacing, eyeY - arcH, center.dx - eyeSpacing + arcW, eyeY + arcH * 0.3);
      // Ojo derecho alegre en arco ^
      final Path rightHappyEye = Path()
        ..moveTo(center.dx + eyeSpacing - arcW, eyeY + arcH * 0.3)
        ..quadraticBezierTo(center.dx + eyeSpacing, eyeY - arcH, center.dx + eyeSpacing + arcW, eyeY + arcH * 0.3);

      canvas.drawPath(leftHappyEye, happyEyePaint);
      canvas.drawPath(rightHappyEye, happyEyePaint);

      // Boquita sonriente abierta contenida dentro del hocico
      final double mouthHalfW = R * 0.12;
      final double mouthDepth = R * 0.11;
      final Path openMouth = Path()
        ..moveTo(center.dx - mouthHalfW, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + mouthDepth, center.dx + mouthHalfW, mouthY)
        ..close();

      canvas.drawPath(openMouth, Paint()..color = const Color(0xFF880E4F));
      canvas.drawPath(openMouth, linePaint);

      // Lengüita rosada dentro de la boca
      final Path tongue = Path()
        ..moveTo(center.dx - mouthHalfW * 0.6, mouthY + mouthDepth * 0.5)
        ..quadraticBezierTo(center.dx, mouthY + mouthDepth * 0.95, center.dx + mouthHalfW * 0.6, mouthY + mouthDepth * 0.5)
        ..close();
      canvas.drawPath(tongue, Paint()..color = const Color(0xFFFF80AB));

      // Mejillas sonrosadas suaves
      final Paint blush = Paint()..color = const Color(0x35FF5252);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx - R * 0.44, mouthY), width: R * 0.22, height: R * 0.13),
        blush,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx + R * 0.44, mouthY), width: R * 0.22, height: R * 0.13),
        blush,
      );

    } else if (isWorried) {
      // --- EXPRESIÓN 2: PREOCUPADO / OJOS LLOROSOS (Respuesta incorrecta) ---
      // Cejitas preocupadas inclinadas suavemente
      final Paint eyebrowPaint = Paint()
        ..color = darkFeatureColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.045).clamp(1.2, 2.2)
        ..strokeCap = StrokeCap.round;

      final double browW = R * 0.08;
      canvas.drawLine(
        Offset(center.dx - eyeSpacing - browW, eyeY - R * 0.11),
        Offset(center.dx - eyeSpacing + browW, eyeY - R * 0.16),
        eyebrowPaint,
      );
      canvas.drawLine(
        Offset(center.dx + eyeSpacing - browW, eyeY - R * 0.16),
        Offset(center.dx + eyeSpacing + browW, eyeY - R * 0.11),
        eyebrowPaint,
      );

      // Ojos con brillo acuoso cristalino
      final double worriedEyeR = eyeR * 1.10;
      final Paint eyeSclera = Paint()..color = darkFeatureColor;
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), worriedEyeR, eyeSclera);
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), worriedEyeR, eyeSclera);

      final Paint tearGleam = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(center.dx - eyeSpacing - worriedEyeR * 0.3, eyeY - worriedEyeR * 0.3), worriedEyeR * 0.45, tearGleam);
      canvas.drawCircle(Offset(center.dx + eyeSpacing - worriedEyeR * 0.3, eyeY - worriedEyeR * 0.3), worriedEyeR * 0.45, tearGleam);
      canvas.drawCircle(Offset(center.dx - eyeSpacing + worriedEyeR * 0.35, eyeY + worriedEyeR * 0.35), worriedEyeR * 0.22, tearGleam);
      canvas.drawCircle(Offset(center.dx + eyeSpacing + worriedEyeR * 0.35, eyeY + worriedEyeR * 0.35), worriedEyeR * 0.22, tearGleam);

      // Pequeña lagrimita cayendo por la mejilla
      final double tearX = center.dx - eyeSpacing - R * 0.07;
      final double tearY = eyeY + R * 0.10;
      final double tearW = R * 0.07;
      final double tearH = R * 0.10;
      final Path tearDrop = Path()
        ..moveTo(tearX, tearY)
        ..quadraticBezierTo(tearX - tearW * 0.5, tearY + tearH * 0.7, tearX, tearY + tearH)
        ..quadraticBezierTo(tearX + tearW * 0.5, tearY + tearH * 0.7, tearX, tearY)
        ..close();
      canvas.drawPath(tearDrop, Paint()..color = const Color(0xFF64B5F6));

      // Boquita triste / curvada hacia abajo proporcionada
      final double sadHalfW = R * 0.10;
      final Path sadMouth = Path()
        ..moveTo(center.dx - sadHalfW, mouthY + R * 0.04)
        ..quadraticBezierTo(center.dx, mouthY, center.dx + sadHalfW, mouthY + R * 0.04);
      canvas.drawPath(sadMouth, linePaint);

    } else {
      // --- EXPRESIÓN 3: SONRIENTE (La mayor parte del tiempo, seleccionando, reposo) ---
      final Paint eyeSclera = Paint()..color = darkFeatureColor;
      final Paint eyeGleam = Paint()..color = Colors.white;

      // Ojo izquierdo tierno
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), eyeR, eyeSclera);
      canvas.drawCircle(Offset(center.dx - eyeSpacing - eyeR * 0.32, eyeY - eyeR * 0.32), eyeR * 0.42, eyeGleam);
      canvas.drawCircle(Offset(center.dx - eyeSpacing + eyeR * 0.35, eyeY + eyeR * 0.35), eyeR * 0.20, eyeGleam);

      // Ojo derecho tierno
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), eyeR, eyeSclera);
      canvas.drawCircle(Offset(center.dx + eyeSpacing - eyeR * 0.32, eyeY - eyeR * 0.32), eyeR * 0.42, eyeGleam);
      canvas.drawCircle(Offset(center.dx + eyeSpacing + eyeR * 0.35, eyeY + eyeR * 0.35), eyeR * 0.20, eyeGleam);

      // Boquita: Sonrisa tierna en W
      final double wSmileHalf = R * 0.11;
      final Path leftSmile = Path()
        ..moveTo(center.dx - wSmileHalf, mouthY)
        ..quadraticBezierTo(center.dx - wSmileHalf * 0.5, mouthY + R * 0.045, center.dx, mouthY);
      final Path rightSmile = Path()
        ..moveTo(center.dx, mouthY)
        ..quadraticBezierTo(center.dx + wSmileHalf * 0.5, mouthY + R * 0.045, center.dx + wSmileHalf, mouthY);

      canvas.drawPath(leftSmile, linePaint);
      canvas.drawPath(rightSmile, linePaint);

      // Coloretes suaves
      final Paint blush = Paint()..color = const Color(0x28FF5252);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx - R * 0.44, mouthY), width: R * 0.20, height: R * 0.11),
        blush,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx + R * 0.44, mouthY), width: R * 0.20, height: R * 0.11),
        blush,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OsoDeAnteojosPainter oldDelegate) =>
      oldDelegate.expression != expression;
}



/// 2. Vector del Frailejón Guane de El Páramo (*Espeletia*).
/// Símbolo vegetal de alta montaña con roseta de hojas afelpadas, flor dorada andina y falda de hojas secas.
class _FrailejonGuanePainter extends CustomPainter {
  final MascotExpression expression;

  _FrailejonGuanePainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final bool isWorried = expression == MascotExpression.worried;
    final bool isHappy = expression == MascotExpression.happy ||
        expression == MascotExpression.celebrating ||
        expression == MascotExpression.excited ||
        expression == MascotExpression.surprised;

    // Sombra suave en el suelo
    final Paint groundShadow = Paint()
      ..color = const Color(0x221B4332)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.95), width: w * 0.70, height: h * 0.10),
      groundShadow,
    );

    final Offset center = Offset(w * 0.5, h * 0.48);
    final double R = w * 0.35;

    // 1. TALLO / FALDA DE HOJAS SECAS (Aislamiento térmico tradicional del frailejón)
    final Path trunkSkirt = Path()
      ..moveTo(center.dx - R * 0.42, center.dy + R * 0.25)
      ..lineTo(center.dx - R * 0.55, center.dy + R * 0.85)
      ..quadraticBezierTo(center.dx - R * 0.25, center.dy + R * 0.92, center.dx, center.dy + R * 0.88)
      ..quadraticBezierTo(center.dx + R * 0.25, center.dy + R * 0.92, center.dx + R * 0.55, center.dy + R * 0.85)
      ..lineTo(center.dx + R * 0.42, center.dy + R * 0.25)
      ..close();

    final Paint skirtPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8D6E63), Color(0xFF6D4C41), Color(0xFF4E342E)],
      ).createShader(Rect.fromLTWH(center.dx - R * 0.55, center.dy + R * 0.25, R * 1.1, R * 0.65));
    canvas.drawPath(trunkSkirt, skirtPaint);

    final Paint dryLeafLines = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.03).clamp(1.0, 1.8);
    for (int i = 1; i <= 3; i++) {
      final double y = center.dy + R * (0.35 + i * 0.13);
      final Path scallop = Path()
        ..moveTo(center.dx - R * 0.45 + i * R * 0.03, y)
        ..quadraticBezierTo(center.dx, y + R * 0.06, center.dx + R * 0.45 - i * R * 0.03, y);
      canvas.drawPath(scallop, dryLeafLines);
    }

    // 2. CORONA DE HOJAS AFELPADAS (Roseta aterciopelada de frailejón)
    const int leafCount = 8;
    for (int i = 0; i < leafCount; i++) {
      final double angle = (i * 2 * math.pi / leafCount) - math.pi / 2;
      final double leafDist = R * 0.88;
      final double tipX = center.dx + math.cos(angle) * leafDist;
      final double tipY = center.dy + math.sin(angle) * leafDist * 0.95;
      final double normalAngle = angle + math.pi / 2;
      final double halfW = R * 0.26;

      final double bx1 = center.dx + math.cos(angle) * R * 0.4 + math.cos(normalAngle) * halfW;
      final double by1 = center.dy + math.sin(angle) * R * 0.4 + math.sin(normalAngle) * halfW;
      final double bx2 = center.dx + math.cos(angle) * R * 0.4 - math.cos(normalAngle) * halfW;
      final double by2 = center.dy + math.sin(angle) * R * 0.4 - math.sin(normalAngle) * halfW;

      final Path leafPath = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(bx1, by1)
        ..quadraticBezierTo(
          center.dx + math.cos(angle) * R * 0.8 + math.cos(normalAngle) * halfW * 0.6,
          center.dy + math.sin(angle) * R * 0.8 + math.sin(normalAngle) * halfW * 0.6,
          tipX,
          tipY,
        )
        ..quadraticBezierTo(
          center.dx + math.cos(angle) * R * 0.8 - math.cos(normalAngle) * halfW * 0.6,
          center.dy + math.sin(angle) * R * 0.8 - math.sin(normalAngle) * halfW * 0.6,
          bx2,
          by2,
        )
        ..close();

      final Paint leafPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.center,
          end: Alignment(math.cos(angle), math.sin(angle)),
          colors: const [Color(0xFFB7C7B0), Color(0xFF7A9A7B), Color(0xFF4A6741)],
        ).createShader(Rect.fromCircle(center: center, radius: leafDist));

      canvas.drawPath(leafPath, leafPaint);

      final Paint ribPaint = Paint()
        ..color = const Color(0x66FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.035).clamp(1.0, 1.8);
      canvas.drawLine(Offset(center.dx, center.dy), Offset(tipX * 0.9 + center.dx * 0.1, tipY * 0.9 + center.dy * 0.1), ribPaint);
    }

    // 3. CABEZA / CUERPO PRINCIPAL REDONDO Y AFELPADO
    final Paint headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        radius: 0.9,
        colors: [Color(0xFFE2ECE0), Color(0xFF9DB89A), Color(0xFF6B8E68)],
      ).createShader(Rect.fromCircle(center: center, radius: R * 0.72));

    canvas.drawCircle(center, R * 0.70, headPaint);

    // 4. FLOR DE FRAILEJÓN EN LA CORONA (Girasolito dorado andino)
    final Offset flowerCenter = Offset(center.dx + R * 0.46, center.dy - R * 0.62);
    final double flowerR = R * 0.22;
    for (int p = 0; p < 7; p++) {
      final double pAngle = p * 2 * math.pi / 7;
      final double px = flowerCenter.dx + math.cos(pAngle) * flowerR * 0.85;
      final double py = flowerCenter.dy + math.sin(pAngle) * flowerR * 0.85;
      canvas.drawCircle(Offset(px, py), flowerR * 0.42, Paint()..color = const Color(0xFFFFD166));
    }
    canvas.drawCircle(flowerCenter, flowerR * 0.45, Paint()..color = const Color(0xFFFB8500));
    canvas.drawCircle(flowerCenter, flowerR * 0.25, Paint()..color = const Color(0xFFD35400));

    // Gotitas de rocío cristalinas en las hojas
    canvas.drawCircle(Offset(center.dx - R * 0.48, center.dy - R * 0.38), R * 0.055, Paint()..color = const Color(0x99E0F7FA));
    canvas.drawCircle(Offset(center.dx - R * 0.50, center.dy - R * 0.40), R * 0.02, Paint()..color = Colors.white);

    // 5. EXPRESIONES FACIALES
    final double eyeSpacing = R * 0.28;
    final double eyeY = center.dy - R * 0.04;
    final Paint darkFeature = Paint()..color = const Color(0xFF1B4332);

    if (isHappy) {
      final Paint happyEyes = Paint()
        ..color = const Color(0xFF1B4332)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.055).clamp(1.4, 2.8)
        ..strokeCap = StrokeCap.round;

      final double arcW = R * 0.08;
      final double arcH = R * 0.06;
      final Path lEye = Path()
        ..moveTo(center.dx - eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(center.dx - eyeSpacing, eyeY - arcH, center.dx - eyeSpacing + arcW, eyeY + arcH * 0.2);
      final Path rEye = Path()
        ..moveTo(center.dx + eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(center.dx + eyeSpacing, eyeY - arcH, center.dx + eyeSpacing + arcW, eyeY + arcH * 0.2);
      canvas.drawPath(lEye, happyEyes);
      canvas.drawPath(rEye, happyEyes);

      final double mouthY = center.dy + R * 0.18;
      final Path mouth = Path()
        ..moveTo(center.dx - R * 0.12, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.14, center.dx + R * 0.12, mouthY)
        ..close();
      canvas.drawPath(mouth, Paint()..color = const Color(0xFF880E4F));
      canvas.drawPath(mouth, happyEyes);

      final Path tongue = Path()
        ..moveTo(center.dx - R * 0.07, mouthY + R * 0.08)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.13, center.dx + R * 0.07, mouthY + R * 0.08)
        ..close();
      canvas.drawPath(tongue, Paint()..color = const Color(0xFFFF80AB));

      canvas.drawCircle(Offset(center.dx - R * 0.38, mouthY), R * 0.10, Paint()..color = const Color(0x35E91E63));
      canvas.drawCircle(Offset(center.dx + R * 0.38, mouthY), R * 0.10, Paint()..color = const Color(0x35E91E63));
    } else if (isWorried) {
      final Paint browPaint = Paint()
        ..color = const Color(0xFF1B4332)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.04).clamp(1.2, 2.2)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(center.dx - eyeSpacing - R * 0.08, eyeY - R * 0.10), Offset(center.dx - eyeSpacing + R * 0.08, eyeY - R * 0.15), browPaint);
      canvas.drawLine(Offset(center.dx + eyeSpacing - R * 0.08, eyeY - R * 0.15), Offset(center.dx + eyeSpacing + R * 0.08, eyeY - R * 0.10), browPaint);

      final double eyeR = R * 0.10;
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(center.dx - eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);

      final Path tear = Path()
        ..moveTo(center.dx - eyeSpacing - R * 0.05, eyeY + R * 0.10)
        ..quadraticBezierTo(center.dx - eyeSpacing - R * 0.10, eyeY + R * 0.20, center.dx - eyeSpacing - R * 0.05, eyeY + R * 0.20)
        ..quadraticBezierTo(center.dx - eyeSpacing, eyeY + R * 0.20, center.dx - eyeSpacing - R * 0.05, eyeY + R * 0.10)
        ..close();
      canvas.drawPath(tear, Paint()..color = const Color(0xFF64B5F6));

      final double mouthY = center.dy + R * 0.22;
      final Path sadMouth = Path()
        ..moveTo(center.dx - R * 0.10, mouthY + R * 0.03)
        ..quadraticBezierTo(center.dx, mouthY - R * 0.02, center.dx + R * 0.10, mouthY + R * 0.03);
      canvas.drawPath(sadMouth, browPaint);
    } else {
      final double eyeR = R * 0.095;
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(center.dx - eyeSpacing - eyeR * 0.32, eyeY - eyeR * 0.32), eyeR * 0.42, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + eyeSpacing - eyeR * 0.32, eyeY - eyeR * 0.32), eyeR * 0.42, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx - eyeSpacing + eyeR * 0.35, eyeY + eyeR * 0.35), eyeR * 0.20, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + eyeSpacing + eyeR * 0.35, eyeY + eyeR * 0.35), eyeR * 0.20, Paint()..color = Colors.white);

      final double mouthY = center.dy + R * 0.18;
      final Paint mouthStroke = Paint()
        ..color = const Color(0xFF1B4332)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.045).clamp(1.2, 2.5)
        ..strokeCap = StrokeCap.round;

      final Path smile = Path()
        ..moveTo(center.dx - R * 0.11, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.07, center.dx + R * 0.11, mouthY);
      canvas.drawPath(smile, mouthStroke);

      canvas.drawCircle(Offset(center.dx - R * 0.36, mouthY), R * 0.08, Paint()..color = const Color(0x28E91E63));
      canvas.drawCircle(Offset(center.dx + R * 0.36, mouthY), R * 0.08, Paint()..color = const Color(0x28E91E63));
    }
  }

  @override
  bool shouldRepaint(covariant _FrailejonGuanePainter oldDelegate) =>
      oldDelegate.expression != expression;
}

/// 3. Vector de la Tortuga Marina del Océano (*Chelonia mydas*).
/// Símbolo de conservación marina con aletas natatorias curvadas, caparazón con escudos y rostro dulce.
class _TortugaMarinaPainter extends CustomPainter {
  final MascotExpression expression;

  _TortugaMarinaPainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final bool isWorried = expression == MascotExpression.worried;
    final bool isHappy = expression == MascotExpression.happy ||
        expression == MascotExpression.celebrating ||
        expression == MascotExpression.excited ||
        expression == MascotExpression.surprised;

    final Paint groundShadow = Paint()
      ..color = const Color(0x220077B6)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.95), width: w * 0.72, height: h * 0.10),
      groundShadow,
    );

    final Offset center = Offset(w * 0.5, h * 0.53);
    final double R = w * 0.35;

    // Burbujas marinas decorativas
    final Paint bubblePaint = Paint()
      ..color = const Color(0x8090E0EF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(center.dx - R * 0.9, center.dy - R * 0.6), R * 0.09, bubblePaint);
    canvas.drawCircle(Offset(center.dx - R * 0.98, center.dy - R * 0.82), R * 0.05, bubblePaint);
    canvas.drawCircle(Offset(center.dx + R * 0.95, center.dy - R * 0.7), R * 0.07, bubblePaint);

    // 1. ALETAS TRASERAS
    final Paint flipperPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF52B788), Color(0xFF2A9D8F), Color(0xFF1B4332)],
      ).createShader(Rect.fromCircle(center: center, radius: R * 1.1));

    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx - R * 0.52, center.dy + R * 0.52), width: R * 0.40, height: R * 0.28),
      flipperPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx + R * 0.52, center.dy + R * 0.52), width: R * 0.40, height: R * 0.28),
      flipperPaint,
    );

    // 2. ALETAS DELANTERAS (Nado elegante)
    final double flipperElevation = isHappy ? -R * 0.15 : 0.0;

    final Path leftFlipper = Path()
      ..moveTo(center.dx - R * 0.55, center.dy + R * 0.05)
      ..quadraticBezierTo(center.dx - R * 1.15, center.dy - R * 0.25 + flipperElevation, center.dx - R * 1.30, center.dy + R * 0.10 + flipperElevation)
      ..quadraticBezierTo(center.dx - R * 0.95, center.dy + R * 0.38, center.dx - R * 0.50, center.dy + R * 0.28)
      ..close();
    canvas.drawPath(leftFlipper, flipperPaint);

    final Path rightFlipper = Path()
      ..moveTo(center.dx + R * 0.55, center.dy + R * 0.05)
      ..quadraticBezierTo(center.dx + R * 1.15, center.dy - R * 0.25 + flipperElevation, center.dx + R * 1.30, center.dy + R * 0.10 + flipperElevation)
      ..quadraticBezierTo(center.dx + R * 0.95, center.dy + R * 0.38, center.dx + R * 0.50, center.dy + R * 0.28)
      ..close();
    canvas.drawPath(rightFlipper, flipperPaint);

    // 3. CAPARAZÓN (CARAPACE)
    final Rect shellRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + R * 0.12),
      width: R * 1.55,
      height: R * 1.45,
    );
    final Paint shellPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        radius: 0.9,
        colors: [Color(0xFF0096C7), Color(0xFF0077B6), Color(0xFF023E8A)],
      ).createShader(shellRect);
    canvas.drawOval(shellRect, shellPaint);

    final Paint shellBorder = Paint()
      ..color = const Color(0xFF90E0EF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.045).clamp(1.4, 2.5);
    canvas.drawOval(shellRect, shellBorder);

    // Escudos dorsales poligonales
    final Paint scuteLine = Paint()
      ..color = const Color(0x99CAF0F8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.035).clamp(1.0, 2.0);

    final Path centerScute = Path()
      ..moveTo(center.dx, center.dy - R * 0.32)
      ..lineTo(center.dx + R * 0.24, center.dy - R * 0.14)
      ..lineTo(center.dx + R * 0.24, center.dy + R * 0.18)
      ..lineTo(center.dx, center.dy + R * 0.36)
      ..lineTo(center.dx - R * 0.24, center.dy + R * 0.18)
      ..lineTo(center.dx - R * 0.24, center.dy - R * 0.14)
      ..close();
    canvas.drawPath(centerScute, Paint()..color = const Color(0x3300B4D8));
    canvas.drawPath(centerScute, scuteLine);

    canvas.drawLine(Offset(center.dx - R * 0.24, center.dy - R * 0.14), Offset(center.dx - R * 0.65, center.dy - R * 0.18), scuteLine);
    canvas.drawLine(Offset(center.dx + R * 0.24, center.dy - R * 0.14), Offset(center.dx + R * 0.65, center.dy - R * 0.18), scuteLine);
    canvas.drawLine(Offset(center.dx - R * 0.24, center.dy + R * 0.18), Offset(center.dx - R * 0.68, center.dy + R * 0.26), scuteLine);
    canvas.drawLine(Offset(center.dx + R * 0.24, center.dy + R * 0.18), Offset(center.dx + R * 0.68, center.dy + R * 0.26), scuteLine);

    // 4. CABEZA Y CUELLO
    final Offset headCenter = Offset(center.dx, center.dy - R * 0.44);
    final Paint headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        radius: 0.95,
        colors: [Color(0xFF74C69D), Color(0xFF40916C), Color(0xFF2D6A4F)],
      ).createShader(Rect.fromCircle(center: headCenter, radius: R * 0.45));

    canvas.drawOval(
      Rect.fromCenter(center: headCenter, width: R * 0.84, height: R * 0.74),
      headPaint,
    );

    final Paint darkFeature = Paint()..color = const Color(0xFF0F2B1D);
    canvas.drawCircle(Offset(headCenter.dx - R * 0.05, headCenter.dy + R * 0.12), R * 0.025, darkFeature);
    canvas.drawCircle(Offset(headCenter.dx + R * 0.05, headCenter.dy + R * 0.12), R * 0.025, darkFeature);

    // 5. EXPRESIONES FACIALES
    final double eyeSpacing = R * 0.26;
    final double eyeY = headCenter.dy - R * 0.04;

    if (isHappy) {
      final Paint happyEyes = Paint()
        ..color = const Color(0xFF0F2B1D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.055).clamp(1.4, 2.8)
        ..strokeCap = StrokeCap.round;

      final double arcW = R * 0.075;
      final double arcH = R * 0.055;
      final Path lEye = Path()
        ..moveTo(headCenter.dx - eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(headCenter.dx - eyeSpacing, eyeY - arcH, headCenter.dx - eyeSpacing + arcW, eyeY + arcH * 0.2);
      final Path rEye = Path()
        ..moveTo(headCenter.dx + eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(headCenter.dx + eyeSpacing, eyeY - arcH, headCenter.dx + eyeSpacing + arcW, eyeY + arcH * 0.2);
      canvas.drawPath(lEye, happyEyes);
      canvas.drawPath(rEye, happyEyes);

      final double mouthY = headCenter.dy + R * 0.16;
      final Path mouth = Path()
        ..moveTo(headCenter.dx - R * 0.11, mouthY)
        ..quadraticBezierTo(headCenter.dx, mouthY + R * 0.11, headCenter.dx + R * 0.11, mouthY)
        ..close();
      canvas.drawPath(mouth, Paint()..color = const Color(0xFF880E4F));
      canvas.drawPath(mouth, happyEyes);

      final Path tongue = Path()
        ..moveTo(headCenter.dx - R * 0.06, mouthY + R * 0.06)
        ..quadraticBezierTo(headCenter.dx, mouthY + R * 0.10, headCenter.dx + R * 0.06, mouthY + R * 0.06)
        ..close();
      canvas.drawPath(tongue, Paint()..color = const Color(0xFFFF80AB));

      canvas.drawCircle(Offset(headCenter.dx - R * 0.32, mouthY), R * 0.08, Paint()..color = const Color(0x35E76F51));
      canvas.drawCircle(Offset(headCenter.dx + R * 0.32, mouthY), R * 0.08, Paint()..color = const Color(0x35E76F51));

    } else if (isWorried) {
      final Paint browPaint = Paint()
        ..color = const Color(0xFF0F2B1D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.04).clamp(1.2, 2.2)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(headCenter.dx - eyeSpacing - R * 0.07, eyeY - R * 0.08), Offset(headCenter.dx - eyeSpacing + R * 0.07, eyeY - R * 0.13), browPaint);
      canvas.drawLine(Offset(headCenter.dx + eyeSpacing - R * 0.07, eyeY - R * 0.13), Offset(headCenter.dx + eyeSpacing + R * 0.07, eyeY - R * 0.08), browPaint);

      final double eyeR = R * 0.095;
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);

      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing - R * 0.07, eyeY + R * 0.13), R * 0.05, Paint()..color = const Color(0xB348CAE4));
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing - R * 0.08, eyeY + R * 0.12), R * 0.02, Paint()..color = Colors.white);

      final double mouthY = headCenter.dy + R * 0.20;
      final Path sadMouth = Path()
        ..moveTo(headCenter.dx - R * 0.09, mouthY + R * 0.02)
        ..quadraticBezierTo(headCenter.dx, mouthY - R * 0.02, headCenter.dx + R * 0.09, mouthY + R * 0.02);
      canvas.drawPath(sadMouth, browPaint);

    } else {
      final double eyeR = R * 0.09;
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing - eyeR * 0.32, eyeY - eyeR * 0.32), eyeR * 0.42, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing - eyeR * 0.32, eyeY - eyeR * 0.32), eyeR * 0.42, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing + eyeR * 0.35, eyeY + eyeR * 0.35), eyeR * 0.20, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing + eyeR * 0.35, eyeY + eyeR * 0.35), eyeR * 0.20, Paint()..color = Colors.white);

      final double mouthY = headCenter.dy + R * 0.17;
      final Paint mouthStroke = Paint()
        ..color = const Color(0xFF0F2B1D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.045).clamp(1.2, 2.5)
        ..strokeCap = StrokeCap.round;

      final Path smile = Path()
        ..moveTo(headCenter.dx - R * 0.10, mouthY)
        ..quadraticBezierTo(headCenter.dx, mouthY + R * 0.06, headCenter.dx + R * 0.10, mouthY);
      canvas.drawPath(smile, mouthStroke);

      canvas.drawCircle(Offset(headCenter.dx - R * 0.30, mouthY), R * 0.07, Paint()..color = const Color(0x25E76F51));
      canvas.drawCircle(Offset(headCenter.dx + R * 0.30, mouthY), R * 0.07, Paint()..color = const Color(0x25E76F51));
    }
  }

  @override
  bool shouldRepaint(covariant _TortugaMarinaPainter oldDelegate) =>
      oldDelegate.expression != expression;
}

/// 4. Vector de la Anaconda Verde de la Selva Amazónica (*Eunectes murinus*).
/// Símbolo de los ríos y bosques amazónicos: simpática serpiente enrollada en espiral con manchas protectoras y lengua bífida.
class _AnacondaVerdePainter extends CustomPainter {
  final MascotExpression expression;

  _AnacondaVerdePainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final bool isWorried = expression == MascotExpression.worried;
    final bool isHappy = expression == MascotExpression.happy ||
        expression == MascotExpression.celebrating ||
        expression == MascotExpression.excited ||
        expression == MascotExpression.surprised;

    final Paint groundShadow = Paint()
      ..color = const Color(0x221B4332)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.95), width: w * 0.72, height: h * 0.10),
      groundShadow,
    );

    final Offset center = Offset(w * 0.5, h * 0.50);
    final double R = w * 0.35;

    // 1. CUERPO ENROLLADO (Coils amistosos de anaconda)
    final Rect baseCoilRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + R * 0.42),
      width: R * 1.80,
      height: R * 0.88,
    );

    final Paint coilPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        radius: 0.95,
        colors: [Color(0xFF52B788), Color(0xFF2D6A4F), Color(0xFF1B4332)],
      ).createShader(baseCoilRect);
    canvas.drawOval(baseCoilRect, coilPaint);

    // Vientre crema/amarillo pastel
    final Path belly = Path()
      ..moveTo(center.dx - R * 0.65, center.dy + R * 0.58)
      ..quadraticBezierTo(center.dx, center.dy + R * 0.86, center.dx + R * 0.65, center.dy + R * 0.58)
      ..quadraticBezierTo(center.dx, center.dy + R * 0.68, center.dx - R * 0.65, center.dy + R * 0.58)
      ..close();
    canvas.drawPath(belly, Paint()..color = const Color(0xFFD8F3DC));

    // Manchas oscuras emblemáticas de anaconda con centro suave
    final Paint spotPaint = Paint()..color = const Color(0xCC0D2818);
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx - R * 0.55, center.dy + R * 0.38), width: R * 0.22, height: R * 0.16), spotPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx + R * 0.55, center.dy + R * 0.38), width: R * 0.22, height: R * 0.16), spotPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(center.dx, center.dy + R * 0.44), width: R * 0.24, height: R * 0.14), spotPaint);

    // Colita que asoma coqueta a la derecha
    final Path tail = Path()
      ..moveTo(center.dx + R * 0.75, center.dy + R * 0.35)
      ..quadraticBezierTo(center.dx + R * 0.98, center.dy + R * 0.20, center.dx + R * 0.92, center.dy + R * 0.05)
      ..quadraticBezierTo(center.dx + R * 0.82, center.dy + R * 0.15, center.dx + R * 0.72, center.dy + R * 0.28)
      ..close();
    canvas.drawPath(tail, coilPaint);

    // 2. CABEZA DE ANACONDA
    final Offset headCenter = Offset(center.dx, center.dy - R * 0.18);
    final Rect headRect = Rect.fromCenter(center: headCenter, width: R * 1.25, height: R * 1.05);

    final Paint headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.95,
        colors: [Color(0xFF74C69D), Color(0xFF40916C), Color(0xFF1B4332)],
      ).createShader(headRect);
    canvas.drawOval(headRect, headPaint);

    // Franjas oculares oscuras laterales (características de Eunectes murinus)
    final Paint stripePaint = Paint()
      ..color = const Color(0xFF132A13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.05).clamp(1.5, 2.8)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(headCenter.dx - R * 0.36, headCenter.dy - R * 0.05), Offset(headCenter.dx - R * 0.58, headCenter.dy + R * 0.08), stripePaint);
    canvas.drawLine(Offset(headCenter.dx + R * 0.36, headCenter.dy - R * 0.05), Offset(headCenter.dx + R * 0.58, headCenter.dy + R * 0.08), stripePaint);

    // Fosas nasales en la parte superior (adaptación acuática)
    final Paint darkFeature = Paint()..color = const Color(0xFF0D2818);
    canvas.drawCircle(Offset(headCenter.dx - R * 0.10, headCenter.dy + R * 0.18), R * 0.03, darkFeature);
    canvas.drawCircle(Offset(headCenter.dx + R * 0.10, headCenter.dy + R * 0.18), R * 0.03, darkFeature);

    // 3. EXPRESIONES: OJOS, BOCA Y LENGUA BÍFIDA
    final double eyeSpacing = R * 0.30;
    final double eyeY = headCenter.dy - R * 0.10;

    if (isHappy) {
      final Paint happyEyes = Paint()
        ..color = const Color(0xFF0D2818)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.055).clamp(1.4, 2.8)
        ..strokeCap = StrokeCap.round;

      final double arcW = R * 0.08;
      final double arcH = R * 0.06;
      final Path lEye = Path()
        ..moveTo(headCenter.dx - eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(headCenter.dx - eyeSpacing, eyeY - arcH, headCenter.dx - eyeSpacing + arcW, eyeY + arcH * 0.2);
      final Path rEye = Path()
        ..moveTo(headCenter.dx + eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(headCenter.dx + eyeSpacing, eyeY - arcH, headCenter.dx + eyeSpacing + arcW, eyeY + arcH * 0.2);
      canvas.drawPath(lEye, happyEyes);
      canvas.drawPath(rEye, happyEyes);

      // Boquita abierta alegre
      final double mouthY = headCenter.dy + R * 0.25;
      final Path mouth = Path()
        ..moveTo(headCenter.dx - R * 0.14, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.16, headCenter.dx + R * 0.14, mouthY)
        ..close();
      canvas.drawPath(mouth, Paint()..color = const Color(0xFF880E4F));
      canvas.drawPath(mouth, happyEyes);

      // Lengua bífida feliz que sale
      final Path forkedTongue = Path()
        ..moveTo(headCenter.dx - R * 0.04, mouthY + R * 0.10)
        ..lineTo(headCenter.dx - R * 0.08, mouthY + R * 0.28)
        ..lineTo(headCenter.dx, mouthY + R * 0.22)
        ..lineTo(headCenter.dx + R * 0.08, mouthY + R * 0.28)
        ..lineTo(headCenter.dx + R * 0.04, mouthY + R * 0.10)
        ..close();
      canvas.drawPath(forkedTongue, Paint()..color = const Color(0xFFE63946));

      canvas.drawCircle(Offset(headCenter.dx - R * 0.40, mouthY), R * 0.09, Paint()..color = const Color(0x35E91E63));
      canvas.drawCircle(Offset(headCenter.dx + R * 0.40, mouthY), R * 0.09, Paint()..color = const Color(0x35E91E63));

    } else if (isWorried) {
      final Paint browPaint = Paint()
        ..color = const Color(0xFF0D2818)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.04).clamp(1.2, 2.2)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(headCenter.dx - eyeSpacing - R * 0.08, eyeY - R * 0.09), Offset(headCenter.dx - eyeSpacing + R * 0.08, eyeY - R * 0.14), browPaint);
      canvas.drawLine(Offset(headCenter.dx + eyeSpacing - R * 0.08, eyeY - R * 0.14), Offset(headCenter.dx + eyeSpacing + R * 0.08, eyeY - R * 0.09), browPaint);

      final double eyeR = R * 0.10;
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);

      final Path tear = Path()
        ..moveTo(headCenter.dx - eyeSpacing - R * 0.05, eyeY + R * 0.12)
        ..quadraticBezierTo(headCenter.dx - eyeSpacing - R * 0.10, eyeY + R * 0.22, headCenter.dx - eyeSpacing - R * 0.05, eyeY + R * 0.22)
        ..quadraticBezierTo(headCenter.dx - eyeSpacing, eyeY + R * 0.22, headCenter.dx - eyeSpacing - R * 0.05, eyeY + R * 0.12)
        ..close();
      canvas.drawPath(tear, Paint()..color = const Color(0xFF64B5F6));

      final double mouthY = headCenter.dy + R * 0.28;
      final Path sadMouth = Path()
        ..moveTo(headCenter.dx - R * 0.10, mouthY + R * 0.02)
        ..quadraticBezierTo(center.dx, mouthY - R * 0.03, headCenter.dx + R * 0.10, mouthY + R * 0.02);
      canvas.drawPath(sadMouth, browPaint);

    } else {
      final double eyeR = R * 0.095;
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing - eyeR * 0.32, eyeY - eyeR * 0.32), eyeR * 0.42, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing - eyeR * 0.32, eyeY - eyeR * 0.32), eyeR * 0.42, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(headCenter.dx - eyeSpacing + eyeR * 0.35, eyeY + eyeR * 0.35), eyeR * 0.20, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(headCenter.dx + eyeSpacing + eyeR * 0.35, eyeY + eyeR * 0.35), eyeR * 0.20, Paint()..color = Colors.white);

      final double mouthY = headCenter.dy + R * 0.26;
      final Paint mouthStroke = Paint()
        ..color = const Color(0xFF0D2818)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.045).clamp(1.2, 2.5)
        ..strokeCap = StrokeCap.round;

      final Path smile = Path()
        ..moveTo(headCenter.dx - R * 0.12, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.07, headCenter.dx + R * 0.12, mouthY);
      canvas.drawPath(smile, mouthStroke);

      // Puntiña de la lengua bífida asomando curiosa
      final Path tongueTip = Path()
        ..moveTo(center.dx - R * 0.025, mouthY + R * 0.05)
        ..lineTo(center.dx - R * 0.05, mouthY + R * 0.14)
        ..lineTo(center.dx, mouthY + R * 0.10)
        ..lineTo(center.dx + R * 0.05, mouthY + R * 0.14)
        ..lineTo(center.dx + R * 0.025, mouthY + R * 0.05)
        ..close();
      canvas.drawPath(tongueTip, Paint()..color = const Color(0xFFE63946));

      canvas.drawCircle(Offset(headCenter.dx - R * 0.38, mouthY), R * 0.08, Paint()..color = const Color(0x28E91E63));
      canvas.drawCircle(Offset(headCenter.dx + R * 0.38, mouthY), R * 0.08, Paint()..color = const Color(0x28E91E63));
    }
  }

  @override
  bool shouldRepaint(covariant _AnacondaVerdePainter oldDelegate) =>
      oldDelegate.expression != expression;
}

/// 5. Vector del Cangrejo del Manglar (*Cardisoma crassum* / Cangrejo violinista).
/// Símbolo de los manglares costeros con caparazón azul índigo, tenazas coralinas expresivas y ojos en pedúnculo.
class _CangrejoManglarPainter extends CustomPainter {
  final MascotExpression expression;

  _CangrejoManglarPainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final bool isWorried = expression == MascotExpression.worried;
    final bool isHappy = expression == MascotExpression.happy ||
        expression == MascotExpression.celebrating ||
        expression == MascotExpression.excited ||
        expression == MascotExpression.surprised;

    final Paint groundShadow = Paint()
      ..color = const Color(0x220A9396)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.95), width: w * 0.72, height: h * 0.10),
      groundShadow,
    );

    final Offset center = Offset(w * 0.5, h * 0.54);
    final double R = w * 0.35;

    // 1. PATITAS MARCHADORAS INFERIORES (3 a cada lado)
    final Paint legPaint = Paint()
      ..color = const Color(0xFFE76F51)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.07).clamp(2.0, 3.8)
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final double xOffset = R * (0.45 + i * 0.18);
      final double yBase = center.dy + R * (0.22 + i * 0.14);
      // Pata izquierda
      final Path leftLeg = Path()
        ..moveTo(center.dx - xOffset * 0.7, yBase)
        ..quadraticBezierTo(center.dx - xOffset * 1.35, yBase + R * 0.12, center.dx - xOffset * 1.15, yBase + R * 0.32);
      canvas.drawPath(leftLeg, legPaint);

      // Pata derecha
      final Path rightLeg = Path()
        ..moveTo(center.dx + xOffset * 0.7, yBase)
        ..quadraticBezierTo(center.dx + xOffset * 1.35, yBase + R * 0.12, center.dx + xOffset * 1.15, yBase + R * 0.32);
      canvas.drawPath(rightLeg, legPaint);
    }

    // 2. GRANDES TENAZAS / QUELAS CORALINAS
    final double clawShiftY = isHappy ? -R * 0.18 : (isWorried ? R * 0.12 : 0.0);
    final double clawShiftX = isWorried ? -R * 0.15 : 0.0;

    final Paint armPaint = Paint()
      ..color = const Color(0xFFE76F51)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.11).clamp(3.0, 5.0)
      ..strokeCap = StrokeCap.round;

    // Brazo izquierdo
    canvas.drawLine(
      Offset(center.dx - R * 0.55, center.dy),
      Offset(center.dx - R * 0.95 - clawShiftX, center.dy - R * 0.30 + clawShiftY),
      armPaint,
    );
    // Brazo derecho
    canvas.drawLine(
      Offset(center.dx + R * 0.55, center.dy),
      Offset(center.dx + R * 0.95 + clawShiftX, center.dy - R * 0.30 + clawShiftY),
      armPaint,
    );

    // Pinza izquierda
    final Offset lClawCenter = Offset(center.dx - R * 1.05 - clawShiftX, center.dy - R * 0.40 + clawShiftY);
    final Paint clawPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFF4A261), Color(0xFFE76F51), Color(0xFFD62828)],
      ).createShader(Rect.fromCircle(center: lClawCenter, radius: R * 0.4));

    final Path leftClawPath = Path()
      ..moveTo(lClawCenter.dx + R * 0.15, lClawCenter.dy + R * 0.18)
      ..quadraticBezierTo(lClawCenter.dx - R * 0.30, lClawCenter.dy + R * 0.28, lClawCenter.dx - R * 0.26, lClawCenter.dy - R * 0.10)
      ..quadraticBezierTo(lClawCenter.dx - R * 0.10, lClawCenter.dy - R * 0.30, lClawCenter.dx + R * 0.12, lClawCenter.dy - R * 0.18)
      ..close();
    canvas.drawPath(leftClawPath, clawPaint);

    // Pinza derecha
    final Offset rClawCenter = Offset(center.dx + R * 1.05 + clawShiftX, center.dy - R * 0.40 + clawShiftY);
    final Path rightClawPath = Path()
      ..moveTo(rClawCenter.dx - R * 0.15, rClawCenter.dy + R * 0.18)
      ..quadraticBezierTo(rClawCenter.dx + R * 0.30, rClawCenter.dy + R * 0.28, rClawCenter.dx + R * 0.26, rClawCenter.dy - R * 0.10)
      ..quadraticBezierTo(rClawCenter.dx + R * 0.10, rClawCenter.dy - R * 0.30, rClawCenter.dx - R * 0.12, rClawCenter.dy - R * 0.18)
      ..close();
    canvas.drawPath(rightClawPath, clawPaint);

    // 3. CAPARAZÓN PRINCIPAL (CARAPACE)
    final Rect carapaceRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + R * 0.10),
      width: R * 1.62,
      height: R * 1.15,
    );
    final Paint carapacePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        radius: 0.9,
        colors: [Color(0xFF0077B6), Color(0xFF005F73), Color(0xFF0A192F)],
      ).createShader(carapaceRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(carapaceRect, Radius.circular(R * 0.52)),
      carapacePaint,
    );

    // Borde decorativo coralino del caparazón
    final Paint carapaceBorder = Paint()
      ..color = const Color(0xFFF4A261)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.04).clamp(1.4, 2.4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(carapaceRect, Radius.circular(R * 0.52)),
      carapaceBorder,
    );

    // 4. OJOS EN PEDÚNCULO (Eyestalks verticales)
    final double stalkSpacing = R * 0.28;
    final double stalkTopY = center.dy - R * 0.40;

    final Paint stalkPaint = Paint()
      ..color = const Color(0xFFE76F51)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (R * 0.08).clamp(2.4, 4.0)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(center.dx - stalkSpacing, center.dy - R * 0.20), Offset(center.dx - stalkSpacing, stalkTopY), stalkPaint);
    canvas.drawLine(Offset(center.dx + stalkSpacing, center.dy - R * 0.20), Offset(center.dx + stalkSpacing, stalkTopY), stalkPaint);

    final double eyeR = R * 0.18;
    final Paint eyeSclera = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx - stalkSpacing, stalkTopY), eyeR, eyeSclera);
    canvas.drawCircle(Offset(center.dx + stalkSpacing, stalkTopY), eyeR, eyeSclera);

    final Paint darkFeature = Paint()..color = const Color(0xFF0A192F);

    // 5. EXPRESIONES EN LOS OJOS Y BOCA
    if (isHappy) {
      final Paint happyEyes = Paint()
        ..color = const Color(0xFF0A192F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.055).clamp(1.4, 2.8)
        ..strokeCap = StrokeCap.round;

      final double arcW = eyeR * 0.65;
      final double arcH = eyeR * 0.45;
      final Path lEye = Path()
        ..moveTo(center.dx - stalkSpacing - arcW, stalkTopY + arcH * 0.2)
        ..quadraticBezierTo(center.dx - stalkSpacing, stalkTopY - arcH, center.dx - stalkSpacing + arcW, stalkTopY + arcH * 0.2);
      final Path rEye = Path()
        ..moveTo(center.dx + stalkSpacing - arcW, stalkTopY + arcH * 0.2)
        ..quadraticBezierTo(center.dx + stalkSpacing, stalkTopY - arcH, center.dx + stalkSpacing + arcW, stalkTopY + arcH * 0.2);
      canvas.drawPath(lEye, happyEyes);
      canvas.drawPath(rEye, happyEyes);

      // Boquita abierta alegre sobre el caparazón
      final double mouthY = center.dy + R * 0.12;
      final Path mouth = Path()
        ..moveTo(center.dx - R * 0.14, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.18, center.dx + R * 0.14, mouthY)
        ..close();
      canvas.drawPath(mouth, Paint()..color = const Color(0xFF880E4F));
      canvas.drawPath(mouth, happyEyes);

      // Dientecillos o lengua
      final Path tongue = Path()
        ..moveTo(center.dx - R * 0.08, mouthY + R * 0.08)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.14, center.dx + R * 0.08, mouthY + R * 0.08)
        ..close();
      canvas.drawPath(tongue, Paint()..color = const Color(0xFFFF80AB));

    } else if (isWorried) {
      canvas.drawCircle(Offset(center.dx - stalkSpacing, stalkTopY), eyeR * 0.65, darkFeature);
      canvas.drawCircle(Offset(center.dx + stalkSpacing, stalkTopY), eyeR * 0.65, darkFeature);
      canvas.drawCircle(Offset(center.dx - stalkSpacing - eyeR * 0.2, stalkTopY - eyeR * 0.2), eyeR * 0.28, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + stalkSpacing - eyeR * 0.2, stalkTopY - eyeR * 0.2), eyeR * 0.28, Paint()..color = Colors.white);

      // Lagrimita
      final Path tear = Path()
        ..moveTo(center.dx - stalkSpacing - eyeR * 0.3, stalkTopY + eyeR * 0.8)
        ..quadraticBezierTo(center.dx - stalkSpacing - eyeR * 0.6, stalkTopY + eyeR * 1.5, center.dx - stalkSpacing - eyeR * 0.3, stalkTopY + eyeR * 1.5)
        ..quadraticBezierTo(center.dx - stalkSpacing, stalkTopY + eyeR * 1.5, center.dx - stalkSpacing - eyeR * 0.3, stalkTopY + eyeR * 0.8)
        ..close();
      canvas.drawPath(tear, Paint()..color = const Color(0xFF48CAE4));

      // Boquita triste
      final double mouthY = center.dy + R * 0.18;
      final Paint mouthLine = Paint()
        ..color = const Color(0xFFF4A261)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.045).clamp(1.4, 2.5)
        ..strokeCap = StrokeCap.round;
      final Path sadMouth = Path()
        ..moveTo(center.dx - R * 0.10, mouthY + R * 0.02)
        ..quadraticBezierTo(center.dx, mouthY - R * 0.04, center.dx + R * 0.10, mouthY + R * 0.02);
      canvas.drawPath(sadMouth, mouthLine);

    } else {
      // Sonriente normal con grandes pupilas brillantes
      final double pupilR = eyeR * 0.60;
      canvas.drawCircle(Offset(center.dx - stalkSpacing, stalkTopY), pupilR, darkFeature);
      canvas.drawCircle(Offset(center.dx + stalkSpacing, stalkTopY), pupilR, darkFeature);
      canvas.drawCircle(Offset(center.dx - stalkSpacing - pupilR * 0.35, stalkTopY - pupilR * 0.35), pupilR * 0.42, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + stalkSpacing - pupilR * 0.35, stalkTopY - pupilR * 0.35), pupilR * 0.42, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx - stalkSpacing + pupilR * 0.35, stalkTopY + pupilR * 0.35), pupilR * 0.20, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + stalkSpacing + pupilR * 0.35, stalkTopY + pupilR * 0.35), pupilR * 0.20, Paint()..color = Colors.white);

      final double mouthY = center.dy + R * 0.12;
      final Paint mouthStroke = Paint()
        ..color = const Color(0xFFF4A261)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.045).clamp(1.2, 2.5)
        ..strokeCap = StrokeCap.round;

      final Path smile = Path()
        ..moveTo(center.dx - R * 0.12, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.10, center.dx + R * 0.12, mouthY);
      canvas.drawPath(smile, mouthStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _CangrejoManglarPainter oldDelegate) =>
      oldDelegate.expression != expression;
}

/// 6. Vector de la Iguana Verde del Bosque Seco Tropical (*Iguana iguana*).
/// Símbolo de resistencia al sol y calor con cresta dorsal espinosa, papada colgante y escama subtimpánica.
class _IguanaVerdePainter extends CustomPainter {
  final MascotExpression expression;

  _IguanaVerdePainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final bool isWorried = expression == MascotExpression.worried;
    final bool isHappy = expression == MascotExpression.happy ||
        expression == MascotExpression.celebrating ||
        expression == MascotExpression.excited ||
        expression == MascotExpression.surprised;

    final Paint groundShadow = Paint()
      ..color = const Color(0x221B4332)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.95), width: w * 0.70, height: h * 0.10),
      groundShadow,
    );

    final Offset center = Offset(w * 0.5, h * 0.50);
    final double R = w * 0.35;

    // 1. CRESTA DORSAL ESPINOSA (Espinas redondeadas a lo largo de la cabeza)
    final double crestDroop = isWorried ? R * 0.08 : 0.0;
    const int spineCount = 6;
    for (int i = 0; i < spineCount; i++) {
      final double sx = center.dx - R * 0.40 + i * (R * 0.80 / (spineCount - 1));
      final double sy = center.dy - R * 0.48 - (math.sin(i * math.pi / (spineCount - 1)) * R * 0.15) + crestDroop;
      final double spineH = R * (0.16 + math.sin(i * math.pi / (spineCount - 1)) * 0.12);

      final Path spine = Path()
        ..moveTo(sx - R * 0.06, sy + R * 0.08)
        ..lineTo(sx, sy - spineH)
        ..lineTo(sx + R * 0.06, sy + R * 0.08)
        ..close();

      final Paint spinePaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF48CAE4), Color(0xFF2A9D8F), Color(0xFF1B4332)],
        ).createShader(Rect.fromLTWH(sx - R * 0.06, sy - spineH, R * 0.12, spineH + R * 0.08));

      canvas.drawPath(spine, spinePaint);
    }

    // 2. PAPADA COLGANTE (Dewlap redondo de la iguana)
    final Path dewlap = Path()
      ..moveTo(center.dx - R * 0.28, center.dy + R * 0.22)
      ..quadraticBezierTo(center.dx, center.dy + R * 0.75, center.dx + R * 0.35, center.dy + R * 0.25)
      ..close();

    final Paint dewlapPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF74C69D), Color(0xFF52B788), Color(0xFF2D6A4F)],
      ).createShader(Rect.fromLTWH(center.dx - R * 0.3, center.dy + R * 0.2, R * 0.65, R * 0.55));
    canvas.drawPath(dewlap, dewlapPaint);

    // Escamitas de sierra en el borde de la papada
    final Paint sawPaint = Paint()..color = const Color(0xFFD8F3DC);
    for (int s = 1; s <= 4; s++) {
      final double t = s / 5.0;
      final double sx = center.dx - R * 0.20 + t * R * 0.40;
      final double sy = center.dy + R * 0.50 + math.sin(t * math.pi) * R * 0.18;
      canvas.drawCircle(Offset(sx, sy), (R * 0.035).clamp(1.0, 1.8), sawPaint);
    }

    // 3. CABEZA PRINCIPAL
    final Rect headRect = Rect.fromCenter(center: center, width: R * 1.65, height: R * 1.35);
    final Paint headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.3),
        radius: 0.95,
        colors: [Color(0xFF80ED99), Color(0xFF52B788), Color(0xFF2D6A4F)],
      ).createShader(headRect);

    canvas.drawOval(headRect, headPaint);

    // Hocico cálido y soleado
    final Rect snoutRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + R * 0.12),
      width: R * 0.95,
      height: R * 0.65,
    );
    canvas.drawOval(snoutRect, Paint()..color = const Color(0x33FFD166));

    // Narinas
    final Paint darkFeature = Paint()..color = const Color(0xFF143621);
    canvas.drawCircle(Offset(center.dx - R * 0.14, center.dy + R * 0.08), R * 0.03, darkFeature);
    canvas.drawCircle(Offset(center.dx + R * 0.14, center.dy + R * 0.08), R * 0.03, darkFeature);

    // 4. ESCAMA SUBTIMPÁNICA (Placa circular en la mejilla típica de la iguana)
    final Offset plateLeft = Offset(center.dx - R * 0.58, center.dy + R * 0.18);
    final Offset plateRight = Offset(center.dx + R * 0.58, center.dy + R * 0.18);
    final double plateR = R * 0.15;
    final Paint platePaint = Paint()..color = const Color(0xFFE9D8A6);
    final Paint plateBorder = Paint()
      ..color = const Color(0xFF1B4332)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(plateLeft, plateR, platePaint);
    canvas.drawCircle(plateLeft, plateR, plateBorder);
    canvas.drawCircle(plateRight, plateR, platePaint);
    canvas.drawCircle(plateRight, plateR, plateBorder);

    // 5. EXPRESIONES: OJOS Y BOCA
    final double eyeSpacing = R * 0.35;
    final double eyeY = center.dy - R * 0.12;

    if (isHappy) {
      final Paint happyEyes = Paint()
        ..color = const Color(0xFF143621)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.055).clamp(1.4, 2.8)
        ..strokeCap = StrokeCap.round;

      final double arcW = R * 0.085;
      final double arcH = R * 0.065;
      final Path lEye = Path()
        ..moveTo(center.dx - eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(center.dx - eyeSpacing, eyeY - arcH, center.dx - eyeSpacing + arcW, eyeY + arcH * 0.2);
      final Path rEye = Path()
        ..moveTo(center.dx + eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(center.dx + eyeSpacing, eyeY - arcH, center.dx + eyeSpacing + arcW, eyeY + arcH * 0.2);
      canvas.drawPath(lEye, happyEyes);
      canvas.drawPath(rEye, happyEyes);

      // Sonrisa ancha reptiliana
      final double mouthY = center.dy + R * 0.24;
      final Path mouth = Path()
        ..moveTo(center.dx - R * 0.18, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.16, center.dx + R * 0.18, mouthY)
        ..close();
      canvas.drawPath(mouth, Paint()..color = const Color(0xFF880E4F));
      canvas.drawPath(mouth, happyEyes);

      final Path tongue = Path()
        ..moveTo(center.dx - R * 0.09, mouthY + R * 0.09)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.15, center.dx + R * 0.09, mouthY + R * 0.09)
        ..close();
      canvas.drawPath(tongue, Paint()..color = const Color(0xFFFF80AB));

      canvas.drawCircle(Offset(center.dx - R * 0.44, mouthY), R * 0.09, Paint()..color = const Color(0x35E76F51));
      canvas.drawCircle(Offset(center.dx + R * 0.44, mouthY), R * 0.09, Paint()..color = const Color(0x35E76F51));

    } else if (isWorried) {
      final Paint browPaint = Paint()
        ..color = const Color(0xFF143621)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.04).clamp(1.2, 2.2)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(center.dx - eyeSpacing - R * 0.08, eyeY - R * 0.10), Offset(center.dx - eyeSpacing + R * 0.08, eyeY - R * 0.15), browPaint);
      canvas.drawLine(Offset(center.dx + eyeSpacing - R * 0.08, eyeY - R * 0.15), Offset(center.dx + eyeSpacing + R * 0.08, eyeY - R * 0.10), browPaint);

      final double eyeR = R * 0.10;
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(center.dx - eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);

      final Path tear = Path()
        ..moveTo(center.dx - eyeSpacing - R * 0.06, eyeY + R * 0.12)
        ..quadraticBezierTo(center.dx - eyeSpacing - R * 0.12, eyeY + R * 0.22, center.dx - eyeSpacing - R * 0.06, eyeY + R * 0.22)
        ..quadraticBezierTo(center.dx - eyeSpacing, eyeY + R * 0.22, center.dx - eyeSpacing - R * 0.06, eyeY + R * 0.12)
        ..close();
      canvas.drawPath(tear, Paint()..color = const Color(0xFF64B5F6));

      final double mouthY = center.dy + R * 0.28;
      final Path sadMouth = Path()
        ..moveTo(center.dx - R * 0.14, mouthY + R * 0.02)
        ..quadraticBezierTo(center.dx, mouthY - R * 0.04, center.dx + R * 0.14, mouthY + R * 0.02);
      canvas.drawPath(sadMouth, browPaint);

    } else {
      final double eyeR = R * 0.095;
      // Iris ambarina / dorada reptiliana
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), eyeR, Paint()..color = const Color(0xFFE9C46A));
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), eyeR, Paint()..color = const Color(0xFFE9C46A));

      // Pupila vertical amable
      canvas.drawOval(Rect.fromCenter(center: Offset(center.dx - eyeSpacing, eyeY), width: eyeR * 0.8, height: eyeR * 1.5), darkFeature);
      canvas.drawOval(Rect.fromCenter(center: Offset(center.dx + eyeSpacing, eyeY), width: eyeR * 0.8, height: eyeR * 1.5), darkFeature);

      // Brillo
      canvas.drawCircle(Offset(center.dx - eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.35, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.35, Paint()..color = Colors.white);

      final double mouthY = center.dy + R * 0.24;
      final Paint mouthStroke = Paint()
        ..color = const Color(0xFF143621)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.045).clamp(1.2, 2.5)
        ..strokeCap = StrokeCap.round;

      final Path smile = Path()
        ..moveTo(center.dx - R * 0.16, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.08, center.dx + R * 0.16, mouthY);
      canvas.drawPath(smile, mouthStroke);

      canvas.drawCircle(Offset(center.dx - R * 0.42, mouthY), R * 0.08, Paint()..color = const Color(0x28E76F51));
      canvas.drawCircle(Offset(center.dx + R * 0.42, mouthY), R * 0.08, Paint()..color = const Color(0x28E76F51));
    }
  }

  @override
  bool shouldRepaint(covariant _IguanaVerdePainter oldDelegate) =>
      oldDelegate.expression != expression;
}

/// 7. Vector del Chigüiro de los Llanos y Sabana (*Hydrochoerus hydrochaeris*).
/// Símbolo de serenidad llanera con hocico rectangular chato, orejitas redondas, flor de moriche y máxima ternura zen.
class _ChiguiroPainter extends CustomPainter {
  final MascotExpression expression;

  _ChiguiroPainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final bool isWorried = expression == MascotExpression.worried;
    final bool isHappy = expression == MascotExpression.happy ||
        expression == MascotExpression.celebrating ||
        expression == MascotExpression.excited ||
        expression == MascotExpression.surprised;

    final Paint groundShadow = Paint()
      ..color = const Color(0x224A3B32)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.95), width: w * 0.70, height: h * 0.10),
      groundShadow,
    );

    final Offset center = Offset(w * 0.5, h * 0.50);
    final double R = w * 0.35;

    // 1. OREJITAS REDONDAS EN LAS ESQUINAS SUPERIORES
    final double earR = R * 0.22;
    final Offset leftEar = Offset(center.dx - R * 0.58, center.dy - R * 0.55);
    final Offset rightEar = Offset(center.dx + R * 0.58, center.dy - R * 0.55);

    final Paint outerEar = Paint()..color = const Color(0xFF6D4C41);
    final Paint innerEar = Paint()..color = const Color(0xFFD7CCC8);

    canvas.drawCircle(leftEar, earR, outerEar);
    canvas.drawCircle(leftEar, earR * 0.55, innerEar);
    canvas.drawCircle(rightEar, earR, outerEar);
    canvas.drawCircle(rightEar, earR * 0.55, innerEar);

    // 2. CABEZA Y HOCICO RECTANGULAR CHATO (Icono indiscutible del Chigüiro)
    final Rect headRect = Rect.fromCenter(center: Offset(center.dx, center.dy - R * 0.10), width: R * 1.55, height: R * 1.30);
    final Paint headPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.2, -0.3),
        radius: 0.95,
        colors: [Color(0xFFA1887F), Color(0xFF8D6E63), Color(0xFF5D4037)],
      ).createShader(headRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(headRect, Radius.circular(R * 0.45)),
      headPaint,
    );

    // Morro / hocico chato frontal
    final Rect muzzleRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + R * 0.22),
      width: R * 1.15,
      height: R * 0.72,
    );
    final Paint muzzlePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8D6E63), Color(0xFF6D4C41), Color(0xFF4E342E)],
      ).createShader(muzzleRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(muzzleRect, Radius.circular(R * 0.35)),
      muzzlePaint,
    );

    // Narinas chatas en la parte alta del hocico
    final Paint darkFeature = Paint()..color = const Color(0xFF271A15);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx - R * 0.16, center.dy + R * 0.08), width: R * 0.12, height: R * 0.08),
      darkFeature,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx + R * 0.16, center.dy + R * 0.08), width: R * 0.12, height: R * 0.08),
      darkFeature,
    );

    // Flor amarilla llanera o brizna de pasto en la orejita
    final Offset flowerPos = Offset(rightEar.dx + R * 0.10, rightEar.dy - R * 0.12);
    canvas.drawCircle(flowerPos, R * 0.11, Paint()..color = const Color(0xFFFFB703));
    canvas.drawCircle(flowerPos, R * 0.05, Paint()..color = const Color(0xFFFB8500));
    final Path stem = Path()
      ..moveTo(flowerPos.dx, flowerPos.dy + R * 0.08)
      ..quadraticBezierTo(flowerPos.dx - R * 0.08, flowerPos.dy + R * 0.18, flowerPos.dx - R * 0.15, flowerPos.dy + R * 0.14);
    canvas.drawPath(stem, Paint()..color = const Color(0xFF52B788)..style = PaintingStyle.stroke..strokeWidth = 2.0);

    // 3. EXPRESIONES: OJOS Y BOCA ZEN
    final double eyeSpacing = R * 0.38;
    final double eyeY = center.dy - R * 0.18;

    if (isHappy) {
      final Paint happyEyes = Paint()
        ..color = const Color(0xFF271A15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.055).clamp(1.4, 2.8)
        ..strokeCap = StrokeCap.round;

      final double arcW = R * 0.085;
      final double arcH = R * 0.065;
      final Path lEye = Path()
        ..moveTo(center.dx - eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(center.dx - eyeSpacing, eyeY - arcH, center.dx - eyeSpacing + arcW, eyeY + arcH * 0.2);
      final Path rEye = Path()
        ..moveTo(center.dx + eyeSpacing - arcW, eyeY + arcH * 0.2)
        ..quadraticBezierTo(center.dx + eyeSpacing, eyeY - arcH, center.dx + eyeSpacing + arcW, eyeY + arcH * 0.2);
      canvas.drawPath(lEye, happyEyes);
      canvas.drawPath(rEye, happyEyes);

      // Boquita abierta alegre
      final double mouthY = center.dy + R * 0.32;
      final Path mouth = Path()
        ..moveTo(center.dx - R * 0.14, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.18, center.dx + R * 0.14, mouthY)
        ..close();
      canvas.drawPath(mouth, Paint()..color = const Color(0xFF880E4F));
      canvas.drawPath(mouth, happyEyes);

      // Dos dientecitos incisivos blancos de chigüiro
      final Paint toothPaint = Paint()..color = Colors.white;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(center.dx - R * 0.08, mouthY, R * 0.07, R * 0.08), const Radius.circular(2)), toothPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(center.dx + R * 0.01, mouthY, R * 0.07, R * 0.08), const Radius.circular(2)), toothPaint);

      canvas.drawCircle(Offset(center.dx - R * 0.44, mouthY), R * 0.10, Paint()..color = const Color(0x35E91E63));
      canvas.drawCircle(Offset(center.dx + R * 0.44, mouthY), R * 0.10, Paint()..color = const Color(0x35E91E63));

    } else if (isWorried) {
      final Paint browPaint = Paint()
        ..color = const Color(0xFF271A15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.04).clamp(1.2, 2.2)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(center.dx - eyeSpacing - R * 0.08, eyeY - R * 0.10), Offset(center.dx - eyeSpacing + R * 0.08, eyeY - R * 0.15), browPaint);
      canvas.drawLine(Offset(center.dx + eyeSpacing - R * 0.08, eyeY - R * 0.15), Offset(center.dx + eyeSpacing + R * 0.08, eyeY - R * 0.10), browPaint);

      final double eyeR = R * 0.10;
      canvas.drawCircle(Offset(center.dx - eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(center.dx + eyeSpacing, eyeY), eyeR, darkFeature);
      canvas.drawCircle(Offset(center.dx - eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(center.dx + eyeSpacing - eyeR * 0.3, eyeY - eyeR * 0.3), eyeR * 0.45, Paint()..color = Colors.white);

      final Path tear = Path()
        ..moveTo(center.dx - eyeSpacing - R * 0.06, eyeY + R * 0.12)
        ..quadraticBezierTo(center.dx - eyeSpacing - R * 0.12, eyeY + R * 0.22, center.dx - eyeSpacing - R * 0.06, eyeY + R * 0.22)
        ..quadraticBezierTo(center.dx - eyeSpacing, eyeY + R * 0.22, center.dx - eyeSpacing - R * 0.06, eyeY + R * 0.12)
        ..close();
      canvas.drawPath(tear, Paint()..color = const Color(0xFF64B5F6));

      final double mouthY = center.dy + R * 0.38;
      final Path sadMouth = Path()
        ..moveTo(center.dx - R * 0.12, mouthY + R * 0.02)
        ..quadraticBezierTo(center.dx, mouthY - R * 0.04, center.dx + R * 0.12, mouthY + R * 0.02);
      canvas.drawPath(sadMouth, browPaint);

    } else {
      // Expresión ultra-zen y pacífica con ojos entrecerrados serenos
      final Paint zenEyePaint = Paint()
        ..color = const Color(0xFF271A15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (R * 0.05).clamp(1.4, 2.6)
        ..strokeCap = StrokeCap.round;

      final double eyeW = R * 0.10;
      canvas.drawLine(Offset(center.dx - eyeSpacing - eyeW, eyeY), Offset(center.dx - eyeSpacing + eyeW, eyeY), zenEyePaint);
      canvas.drawLine(Offset(center.dx + eyeSpacing - eyeW, eyeY), Offset(center.dx + eyeSpacing + eyeW, eyeY), zenEyePaint);

      final double mouthY = center.dy + R * 0.35;
      final Path smile = Path()
        ..moveTo(center.dx - R * 0.12, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + R * 0.07, center.dx + R * 0.12, mouthY);
      canvas.drawPath(smile, zenEyePaint);

      canvas.drawCircle(Offset(center.dx - R * 0.42, mouthY - R * 0.04), R * 0.08, Paint()..color = const Color(0x35E91E63));
      canvas.drawCircle(Offset(center.dx + R * 0.42, mouthY - R * 0.04), R * 0.08, Paint()..color = const Color(0x35E91E63));
    }
  }

  @override
  bool shouldRepaint(covariant _ChiguiroPainter oldDelegate) =>
      oldDelegate.expression != expression;
}
