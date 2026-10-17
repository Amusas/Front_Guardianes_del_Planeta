import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/avatar_config.dart';

/// Renderizador vectorial dinámico para el avatar del niño en "Guardianes del Planeta".
/// Escala limpiamente a cualquier tamaño sin perder nitidez.
class ChildAvatarWidget extends StatelessWidget {
  final AvatarConfig config;
  final double size;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final bool showShadow;

  const ChildAvatarWidget({
    super.key,
    required this.config,
    this.size = 64.0,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 3.0,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = getGradientColors(config.backgroundId);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: showBorder
            ? Border.all(
                color: borderColor ?? AppColors.white,
                width: borderWidth,
              )
            : null,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: size * 0.1,
                  offset: Offset(0, size * 0.04),
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size),
          painter: _AvatarPainter(
            config: config,
          ),
        ),
      ),
    );
  }

  static List<Color> getGradientColors(String backgroundId) {
    switch (backgroundId) {
      case 'oceano':
        return const [Color(0xFF4FC3F7), Color(0xFF0277BD)];
      case 'solar':
        return const [Color(0xFFFFD54F), Color(0xFFF57C00)];
      case 'orquidea':
        return const [Color(0xFFBA68C8), Color(0xFF6A1B9A)];
      case 'atardecer':
        return const [Color(0xFFFF8A65), Color(0xFFC62828)];
      case 'menta':
        return const [Color(0xFF4DB6AC), Color(0xFF00695C)];
      case 'esmeralda':
      default:
        return const [AppColors.emerald, AppColors.forestGreen];
    }
  }
}

class _AvatarPainter extends CustomPainter {
  final AvatarConfig config;

  _AvatarPainter({required this.config});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // 1. Dibujar personaje base
    _drawCharacter(canvas, size, center);

    // 2. Dibujar expresión (ojos, boca, rubor)
    _drawExpression(canvas, size, center);

    // 3. Dibujar accesorio
    _drawAccessory(canvas, size, center);
  }

  void _drawCharacter(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    switch (config.characterId) {
      case 'oso':
        _drawBear(canvas, size, center);
        break;
      case 'jaguar':
        _drawJaguar(canvas, size, center);
        break;
      case 'delfin':
        _drawDolphin(canvas, size, center);
        break;
      case 'condor':
        _drawCondor(canvas, size, center);
        break;
      case 'tortuga':
        _drawTurtle(canvas, size, center);
        break;
      case 'explorador':
      default:
        _drawHumanExplorer(canvas, size, center);
        break;
    }
  }

  // --- Explorador Humano ---
  void _drawHumanExplorer(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    // Cuello
    final neckPaint = Paint()..color = const Color(0xFFFFCC80);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy + h * 0.35), width: w * 0.28, height: h * 0.25),
        const Radius.circular(8),
      ),
      neckPaint,
    );

    // Ropa (camiseta guardián)
    final shirtPaint = Paint()..color = AppColors.forestGreen;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + h * 0.62), width: w * 0.85, height: h * 0.6),
      math.pi,
      math.pi,
      true,
      shirtPaint,
    );

    // Cabeza (piel)
    final skinPaint = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(Offset(center.dx, center.dy + h * 0.04), w * 0.32, skinPaint);

    // Cabello
    final hairPaint = Paint()..color = const Color(0xFF4E342E);
    // Base superior del cabello
    final hairPath = Path()
      ..moveTo(center.dx - w * 0.34, center.dy + h * 0.05)
      ..cubicTo(
        center.dx - w * 0.35, center.dy - h * 0.34,
        center.dx + w * 0.35, center.dy - h * 0.34,
        center.dx + w * 0.34, center.dy + h * 0.05,
      )
      ..quadraticBezierTo(center.dx + w * 0.15, center.dy - h * 0.12, center.dx, center.dy - h * 0.1)
      ..quadraticBezierTo(center.dx - w * 0.2, center.dy - h * 0.14, center.dx - w * 0.34, center.dy + h * 0.05)
      ..close();
    canvas.drawPath(hairPath, hairPaint);

    // Mechón frontal juguetón
    final fringePath = Path()
      ..moveTo(center.dx - w * 0.18, center.dy - h * 0.18)
      ..quadraticBezierTo(center.dx - w * 0.05, center.dy - h * 0.08, center.dx + w * 0.08, center.dy - h * 0.18)
      ..close();
    canvas.drawPath(fringePath, hairPaint);
  }

  // --- Oso de Anteojos ---
  void _drawBear(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final darkFur = Paint()..color = const Color(0xFF2C221C);
    final earInner = Paint()..color = const Color(0xFFE8DCC8);

    // Orejas
    canvas.drawCircle(Offset(center.dx - w * 0.26, center.dy - h * 0.24), w * 0.11, darkFur);
    canvas.drawCircle(Offset(center.dx + w * 0.26, center.dy - h * 0.24), w * 0.11, darkFur);
    canvas.drawCircle(Offset(center.dx - w * 0.26, center.dy - h * 0.24), w * 0.06, earInner);
    canvas.drawCircle(Offset(center.dx + w * 0.26, center.dy - h * 0.24), w * 0.06, earInner);

    // Cuerpo
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + h * 0.6), width: w * 0.9, height: h * 0.6),
      math.pi,
      math.pi,
      true,
      darkFur,
    );

    // Cabeza
    canvas.drawCircle(Offset(center.dx, center.dy + h * 0.02), w * 0.35, darkFur);

    // Manchas claras de anteojos
    final glassesFur = Paint()..color = const Color(0xFFF3E9D2);
    // Anillo ojo izquierdo
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx - w * 0.13, center.dy - h * 0.02), width: w * 0.18, height: h * 0.2),
      glassesFur,
    );
    // Anillo ojo derecho
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx + w * 0.13, center.dy - h * 0.02), width: w * 0.18, height: h * 0.2),
      glassesFur,
    );
    // Hocico crema
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + h * 0.14), width: w * 0.32, height: h * 0.24),
      glassesFur,
    );

    // Nariz oso
    final nosePaint = Paint()..color = const Color(0xFF1E140F);
    final nosePath = Path()
      ..moveTo(center.dx - w * 0.07, center.dy + h * 0.09)
      ..lineTo(center.dx + w * 0.07, center.dy + h * 0.09)
      ..quadraticBezierTo(center.dx, center.dy + h * 0.16, center.dx - w * 0.07, center.dy + h * 0.09)
      ..close();
    canvas.drawPath(nosePath, nosePaint);
  }

  // --- Jaguar Dorado ---
  void _drawJaguar(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final yellowFur = Paint()..color = const Color(0xFFFFA726);
    final darkSpots = Paint()..color = const Color(0xFF5D4037);

    // Orejas
    canvas.drawCircle(Offset(center.dx - w * 0.27, center.dy - h * 0.22), w * 0.1, darkSpots);
    canvas.drawCircle(Offset(center.dx + w * 0.27, center.dy - h * 0.22), w * 0.1, darkSpots);
    canvas.drawCircle(Offset(center.dx - w * 0.27, center.dy - h * 0.22), w * 0.05, Paint()..color = const Color(0xFFFFCC80));
    canvas.drawCircle(Offset(center.dx + w * 0.27, center.dy - h * 0.22), w * 0.05, Paint()..color = const Color(0xFFFFCC80));

    // Cabeza
    canvas.drawCircle(Offset(center.dx, center.dy + h * 0.04), w * 0.34, yellowFur);

    // Manchas / Rosetas de jaguar
    canvas.drawCircle(Offset(center.dx - w * 0.24, center.dy + h * 0.02), w * 0.04, darkSpots);
    canvas.drawCircle(Offset(center.dx + w * 0.24, center.dy + h * 0.02), w * 0.04, darkSpots);
    canvas.drawCircle(Offset(center.dx - w * 0.18, center.dy - h * 0.16), w * 0.035, darkSpots);
    canvas.drawCircle(Offset(center.dx + w * 0.18, center.dy - h * 0.16), w * 0.035, darkSpots);

    // Hocico claro
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + h * 0.15), width: w * 0.3, height: h * 0.2),
      Paint()..color = const Color(0xFFFFF3E0),
    );

    // Nariz rosada
    final nosePaint = Paint()..color = const Color(0xFFE57373);
    final nosePath = Path()
      ..moveTo(center.dx - w * 0.06, center.dy + h * 0.11)
      ..lineTo(center.dx + w * 0.06, center.dy + h * 0.11)
      ..lineTo(center.dx, center.dy + h * 0.16)
      ..close();
    canvas.drawPath(nosePath, nosePaint);
  }

  // --- Delfín Rosado ---
  void _drawDolphin(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final pinkBody = Paint()..color = const Color(0xFFF48FB1);
    final bellyPaint = Paint()..color = const Color(0xFFFCE4EC);

    // Aleta dorsal
    final finPath = Path()
      ..moveTo(center.dx - w * 0.12, center.dy - h * 0.15)
      ..quadraticBezierTo(center.dx, center.dy - h * 0.35, center.dx + w * 0.12, center.dy - h * 0.18)
      ..close();
    canvas.drawPath(finPath, pinkBody);

    // Cuerpo redondeado
    canvas.drawCircle(Offset(center.dx, center.dy + h * 0.04), w * 0.34, pinkBody);

    // Vientre claro
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + h * 0.2), width: w * 0.45, height: h * 0.3),
      0,
      math.pi,
      true,
      bellyPaint,
    );

    // Hocico largo de delfín de río
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + h * 0.16), width: w * 0.24, height: h * 0.16),
      pinkBody,
    );
  }

  // --- Cóndor Andino ---
  void _drawCondor(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final darkFeather = Paint()..color = const Color(0xFF263238);
    final whiteRuff = Paint()..color = AppColors.white;

    // Cabeza oscura
    canvas.drawCircle(Offset(center.dx, center.dy - h * 0.02), w * 0.3, darkFeather);

    // Cuello de plumas blancas (collar de cóndor)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + h * 0.26), width: w * 0.58, height: h * 0.22),
      whiteRuff,
    );

    // Cresta carnosa característica
    final crestPaint = Paint()..color = const Color(0xFFB71C1C);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy - h * 0.24), width: w * 0.16, height: h * 0.14),
      crestPaint,
    );

    // Pico ganchudo dorado
    final beakPaint = Paint()..color = const Color(0xFFFFB300);
    final beakPath = Path()
      ..moveTo(center.dx - w * 0.08, center.dy + h * 0.06)
      ..lineTo(center.dx + w * 0.08, center.dy + h * 0.06)
      ..lineTo(center.dx, center.dy + h * 0.2)
      ..close();
    canvas.drawPath(beakPath, beakPaint);
  }

  // --- Tortuga Marina ---
  void _drawTurtle(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final greenSkin = Paint()..color = const Color(0xFF81C784);
    final shellPaint = Paint()..color = const Color(0xFF2E7D32);

    // Caparazón detrás de la cabeza
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + h * 0.4), width: w * 0.8, height: h * 0.5),
      math.pi,
      math.pi,
      true,
      shellPaint,
    );

    // Cabeza suave
    canvas.drawCircle(Offset(center.dx, center.dy + h * 0.02), w * 0.32, greenSkin);

    // Aletitas laterales
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx - w * 0.35, center.dy + h * 0.22), width: w * 0.2, height: h * 0.12),
      greenSkin,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx + w * 0.35, center.dy + h * 0.22), width: w * 0.2, height: h * 0.12),
      greenSkin,
    );
  }

  // --- Expresiones faciales ---
  void _drawExpression(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final eyeDark = Paint()..color = const Color(0xFF212121);
    final eyeShine = Paint()..color = Colors.white;
    final blush = Paint()..color = const Color(0xFFFF8A80).withOpacity(0.5);

    double eyeY = center.dy - h * 0.02;
    double leftEyeX = center.dx - w * 0.12;
    double rightEyeX = center.dx + w * 0.12;

    if (config.characterId == 'condor') {
      eyeY = center.dy - h * 0.06;
      leftEyeX = center.dx - w * 0.14;
      rightEyeX = center.dx + w * 0.14;
    }

    // Mejillas sonrosadas (blush)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(leftEyeX - w * 0.06, eyeY + h * 0.1), width: w * 0.1, height: h * 0.06),
      blush,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(rightEyeX + w * 0.06, eyeY + h * 0.1), width: w * 0.1, height: h * 0.06),
      blush,
    );

    switch (config.expressionId) {
      case 'feliz':
        // Ojo izquierdo abierto y brillante
        canvas.drawCircle(Offset(leftEyeX, eyeY), w * 0.06, eyeDark);
        canvas.drawCircle(Offset(leftEyeX - w * 0.02, eyeY - h * 0.02), w * 0.022, eyeShine);

        // Ojo derecho haciendo guiño ^
        final winkPaint = Paint()
          ..color = const Color(0xFF212121)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.035
          ..strokeCap = StrokeCap.round;
        final winkPath = Path()
          ..moveTo(rightEyeX - w * 0.05, eyeY + h * 0.01)
          ..quadraticBezierTo(rightEyeX, eyeY - h * 0.03, rightEyeX + w * 0.05, eyeY + h * 0.01);
        canvas.drawPath(winkPath, winkPaint);

        // Sonrisa grande y abierta
        _drawMouth(canvas, size, center, isOpen: true);
        break;

      case 'audaz':
        // Mirada decidida con cejas inclinadas
        canvas.drawCircle(Offset(leftEyeX, eyeY), w * 0.055, eyeDark);
        canvas.drawCircle(Offset(rightEyeX, eyeY), w * 0.055, eyeDark);
        canvas.drawCircle(Offset(leftEyeX - w * 0.015, eyeY - h * 0.015), w * 0.02, eyeShine);
        canvas.drawCircle(Offset(rightEyeX - w * 0.015, eyeY - h * 0.015), w * 0.02, eyeShine);

        // Cejas audaces
        final browPaint = Paint()
          ..color = const Color(0xFF212121)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.025
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(leftEyeX - w * 0.06, eyeY - h * 0.08), Offset(leftEyeX + w * 0.05, eyeY - h * 0.05), browPaint);
        canvas.drawLine(Offset(rightEyeX + w * 0.06, eyeY - h * 0.08), Offset(rightEyeX - w * 0.05, eyeY - h * 0.05), browPaint);

        // Sonrisa de confianza
        _drawMouth(canvas, size, center, isSmirk: true);
        break;

      case 'sonriente':
      default:
        // Ambos ojos abiertos y amables
        canvas.drawCircle(Offset(leftEyeX, eyeY), w * 0.055, eyeDark);
        canvas.drawCircle(Offset(rightEyeX, eyeY), w * 0.055, eyeDark);
        canvas.drawCircle(Offset(leftEyeX - w * 0.018, eyeY - h * 0.018), w * 0.02, eyeShine);
        canvas.drawCircle(Offset(rightEyeX - w * 0.018, eyeY - h * 0.018), w * 0.02, eyeShine);

        _drawMouth(canvas, size, center, isOpen: false);
        break;
    }
  }

  void _drawMouth(Canvas canvas, Size size, Offset center, {bool isOpen = false, bool isSmirk = false}) {
    if (config.characterId == 'condor') return; // El cóndor ya tiene su pico

    final w = size.width;
    final h = size.height;
    final mouthY = center.dy + h * 0.18;

    final mouthPaint = Paint()
      ..color = const Color(0xFF422213)
      ..style = isOpen ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round;

    if (isOpen) {
      final path = Path()
        ..moveTo(center.dx - w * 0.09, mouthY - h * 0.02)
        ..quadraticBezierTo(center.dx, mouthY + h * 0.08, center.dx + w * 0.09, mouthY - h * 0.02)
        ..close();
      canvas.drawPath(path, mouthPaint);

      // Lengüita rosada dentro de la boca abierta
      final tonguePaint = Paint()..color = const Color(0xFFFF8A80);
      final tonguePath = Path()
        ..moveTo(center.dx - w * 0.05, mouthY + h * 0.02)
        ..quadraticBezierTo(center.dx, mouthY + h * 0.08, center.dx + w * 0.05, mouthY + h * 0.02)
        ..close();
      canvas.drawPath(tonguePath, tonguePaint);
    } else if (isSmirk) {
      final path = Path()
        ..moveTo(center.dx - w * 0.05, mouthY)
        ..quadraticBezierTo(center.dx + w * 0.02, mouthY + h * 0.03, center.dx + w * 0.1, mouthY - h * 0.02);
      canvas.drawPath(path, mouthPaint);
    } else {
      final path = Path()
        ..moveTo(center.dx - w * 0.08, mouthY)
        ..quadraticBezierTo(center.dx, mouthY + h * 0.04, center.dx + w * 0.08, mouthY);
      canvas.drawPath(path, mouthPaint);
    }
  }

  // --- Accesorios ---
  void _drawAccessory(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    switch (config.accessoryId) {
      case 'gorra':
        _drawExplorerCap(canvas, size, center);
        break;
      case 'corona_hojas':
        _drawLeafCrown(canvas, size, center);
        break;
      case 'gafas':
        _drawAdventureGoggles(canvas, size, center);
        break;
      case 'corona_solar':
        _drawSunCrown(canvas, size, center);
        break;
      case 'bufanda':
        _drawAndeanScarf(canvas, size, center);
        break;
      case 'none':
      default:
        break;
    }
  }

  void _drawExplorerCap(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final capPaint = Paint()..color = const Color(0xFF33691E);
    final visorPaint = Paint()..color = const Color(0xFF1B5E20);
    final badgePaint = Paint()..color = AppColors.gold;

    // Corona de la gorra
    final capPath = Path()
      ..moveTo(center.dx - w * 0.32, center.dy - h * 0.16)
      ..quadraticBezierTo(center.dx, center.dy - h * 0.46, center.dx + w * 0.32, center.dy - h * 0.16)
      ..close();
    canvas.drawPath(capPath, capPaint);

    // Visera frontal
    final visorPath = Path()
      ..moveTo(center.dx - w * 0.35, center.dy - h * 0.14)
      ..quadraticBezierTo(center.dx, center.dy - h * 0.06, center.dx + w * 0.35, center.dy - h * 0.14)
      ..quadraticBezierTo(center.dx, center.dy - h * 0.18, center.dx - w * 0.35, center.dy - h * 0.14)
      ..close();
    canvas.drawPath(visorPath, visorPaint);

    // Insignia dorada de hoja en la gorra
    canvas.drawCircle(Offset(center.dx, center.dy - h * 0.26), w * 0.05, badgePaint);
    final leafPaint = Paint()..color = AppColors.forestGreen;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy - h * 0.26), width: w * 0.04, height: h * 0.06),
      leafPaint,
    );
  }

  void _drawLeafCrown(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final vinePaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round;

    final leafPaint = Paint()..color = const Color(0xFF66BB6A);

    // Arco de enredadera
    final vinePath = Path()
      ..moveTo(center.dx - w * 0.32, center.dy - h * 0.12)
      ..quadraticBezierTo(center.dx, center.dy - h * 0.26, center.dx + w * 0.32, center.dy - h * 0.12);
    canvas.drawPath(vinePath, vinePaint);

    // Hojas sobre la corona
    final leafCenters = [
      Offset(center.dx - w * 0.22, center.dy - h * 0.2),
      Offset(center.dx - w * 0.08, center.dy - h * 0.24),
      Offset(center.dx + w * 0.08, center.dy - h * 0.24),
      Offset(center.dx + w * 0.22, center.dy - h * 0.2),
    ];

    for (final pt in leafCenters) {
      canvas.drawOval(
        Rect.fromCenter(center: pt, width: w * 0.07, height: h * 0.09),
        leafPaint,
      );
    }
  }

  void _drawAdventureGoggles(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final strapPaint = Paint()
      ..color = const Color(0xFF3E2723)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04;
    final rimPaint = Paint()
      ..color = const Color(0xFFFFB300)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03;
    final glassPaint = Paint()..color = const Color(0xFF81D4FA).withOpacity(0.8);

    // Correa sobre la frente
    canvas.drawLine(
      Offset(center.dx - w * 0.36, center.dy - h * 0.16),
      Offset(center.dx + w * 0.36, center.dy - h * 0.16),
      strapPaint,
    );

    // Lentes de las gafas
    final leftCenter = Offset(center.dx - w * 0.13, center.dy - h * 0.16);
    final rightCenter = Offset(center.dx + w * 0.13, center.dy - h * 0.16);

    canvas.drawCircle(leftCenter, w * 0.11, glassPaint);
    canvas.drawCircle(leftCenter, w * 0.11, rimPaint);
    canvas.drawCircle(rightCenter, w * 0.11, glassPaint);
    canvas.drawCircle(rightCenter, w * 0.11, rimPaint);
  }

  void _drawSunCrown(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final goldPaint = Paint()..color = AppColors.gold;
    final rayPaint = Paint()
      ..color = AppColors.goldLight
      ..style = PaintingStyle.fill;

    // Diadema base
    final bandPath = Path()
      ..moveTo(center.dx - w * 0.3, center.dy - h * 0.18)
      ..quadraticBezierTo(center.dx, center.dy - h * 0.25, center.dx + w * 0.3, center.dy - h * 0.18)
      ..lineTo(center.dx + w * 0.3, center.dy - h * 0.14)
      ..quadraticBezierTo(center.dx, center.dy - h * 0.21, center.dx - w * 0.3, center.dy - h * 0.14)
      ..close();
    canvas.drawPath(bandPath, goldPaint);

    // Rayos solares radiantes
    final rays = [
      Offset(center.dx - w * 0.2, center.dy - h * 0.28),
      Offset(center.dx - w * 0.1, center.dy - h * 0.35),
      Offset(center.dx, center.dy - h * 0.4),
      Offset(center.dx + w * 0.1, center.dy - h * 0.35),
      Offset(center.dx + w * 0.2, center.dy - h * 0.28),
    ];

    for (final pt in rays) {
      canvas.drawCircle(pt, w * 0.035, rayPaint);
    }
  }

  void _drawAndeanScarf(Canvas canvas, Size size, Offset center) {
    final w = size.width;
    final h = size.height;

    final scarfPaint = Paint()..color = const Color(0xFFD84315);
    final patternPaint = Paint()..color = AppColors.gold;

    // Bufanda enrollada en el cuello
    final scarfRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + h * 0.34),
      width: w * 0.52,
      height: h * 0.16,
    );
    canvas.drawRRect(RRect.fromRectAndRadius(scarfRect, const Radius.circular(10)), scarfPaint);

    // Detalle de diseño andino
    canvas.drawCircle(Offset(center.dx - w * 0.12, center.dy + h * 0.34), w * 0.025, patternPaint);
    canvas.drawCircle(Offset(center.dx, center.dy + h * 0.34), w * 0.025, patternPaint);
    canvas.drawCircle(Offset(center.dx + w * 0.12, center.dy + h * 0.34), w * 0.025, patternPaint);

    // Fleco cayendo hacia un lado
    final fringeRect = Rect.fromLTWH(center.dx + w * 0.08, center.dy + h * 0.36, w * 0.12, h * 0.18);
    canvas.drawRRect(RRect.fromRectAndRadius(fringeRect, const Radius.circular(4)), scarfPaint);
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter oldDelegate) {
    return oldDelegate.config != config;
  }
}
