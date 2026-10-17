import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomPainter que ilustra el paisaje vivo y ambiental de la ruta de exploración
/// de forma 100% inmersiva para cada uno de los 7 ecosistemas oficiales.
/// No utiliza carteles ni iconos UI: dibuja árboles, cordilleras, fauna nativa y ríos reales.
class EcosystemRouteSceneryPainter extends CustomPainter {
  final String ecoCode;
  final double totalHeight;

  EcosystemRouteSceneryPainter({
    required this.ecoCode,
    required this.totalHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = totalHeight;

    final normalized = ecoCode.toUpperCase();

    if (normalized.contains('PARAMO')) {
      _drawParamoScenery(canvas, w, h);
    } else if (normalized.contains('OCEANO')) {
      _drawOceanoScenery(canvas, w, h);
    } else if (normalized.contains('SELVA') || normalized.contains('AMAZON')) {
      _drawSelvaAmazonicaScenery(canvas, w, h);
    } else if (normalized.contains('MANGLAR')) {
      _drawManglarScenery(canvas, w, h);
    } else if (normalized.contains('SECO') || normalized.contains('TROPICAL')) {
      _drawBosqueSecoScenery(canvas, w, h);
    } else if (normalized.contains('LLANOS') || normalized.contains('SABANA')) {
      _drawLlanosScenery(canvas, w, h);
    } else {
      // Default: BOSQUE_ANDINO
      _drawBosqueAndinoScenery(canvas, w, h);
    }
  }

  // =========================================================================
  // 1. BOSQUE ANDINO — Cordilleras, palmas de cera, robles y oso de anteojos
  // =========================================================================
  void _drawBosqueAndinoScenery(Canvas canvas, double w, double h) {
    // 1. Siluetas de la Cordillera de los Andes en el fondo
    _drawAndeanCordilleraBackground(canvas, w, h);

    // 2. Riachuelo de montaña con piedras de río
    _drawMountainStream(canvas, w, h);

    // 3. Palmas de Cera del Quindío (altas, esbeltas, con anillos)
    _drawWaxPalm(canvas, Offset(w * 0.14, 160), 75);
    _drawWaxPalm(canvas, Offset(w * 0.88, 240), 85);
    _drawWaxPalm(canvas, Offset(w * 0.12, 490), 80);
    _drawWaxPalm(canvas, Offset(w * 0.86, 680), 90);
    _drawWaxPalm(canvas, Offset(w * 0.15, 870), 78);
    _drawWaxPalm(canvas, Offset(w * 0.84, 1080), 82);

    // 4. Robles Andinos y Encenillos nativos frondosos
    _drawAndeanOak(canvas, Offset(w * 0.82, 380), 32);
    _drawAndeanOak(canvas, Offset(w * 0.18, 620), 30);
    _drawAndeanOak(canvas, Offset(w * 0.80, 890), 34);
    _drawAndeanOak(canvas, Offset(w * 0.16, 1020), 28);

    // 5. El Oso de Anteojos explorando pacíficamente entre las montañas
    _drawOsoDeAnteojos(canvas, Offset(w * 0.76, 520), 1.1);

    // 6. Rocas andinas con musgo y bromelias silvestres
    _drawMossyBoulder(canvas, Offset(w * 0.24, 320), 22, 14);
    _drawMossyBoulder(canvas, Offset(w * 0.74, 760), 24, 15);
    _drawMossyBoulder(canvas, Offset(w * 0.26, 940), 20, 13);

    // 7. Flores y orquídeas andinas nativas brotando en el pasto
    _drawWildOrchid(canvas, Offset(w * 0.22, 220), const Color(0xFFE91E63));
    _drawWildOrchid(canvas, Offset(w * 0.78, 450), const Color(0xFFFFB703));
    _drawWildOrchid(canvas, Offset(w * 0.20, 720), const Color(0xFFE91E63));
    _drawWildOrchid(canvas, Offset(w * 0.82, 980), const Color(0xFFFFB703));

    // 8. Niebla andina suave flotando entre los valles
    _drawFloatingMist(canvas, Offset(w * 0.35, 180), 140, 28);
    _drawFloatingMist(canvas, Offset(w * 0.65, 580), 150, 30);
    _drawFloatingMist(canvas, Offset(w * 0.40, 920), 130, 26);
  }

  void _drawAndeanCordilleraBackground(Canvas canvas, double w, double h) {
    // Cordillera lejana (azulada / verde bosque profundo)
    final Path backRidge = Path()
      ..moveTo(0, 180)
      ..quadraticBezierTo(w * 0.20, 60, w * 0.38, 120)
      ..quadraticBezierTo(w * 0.55, 30, w * 0.75, 110)
      ..quadraticBezierTo(w * 0.88, 50, w, 90)
      ..lineTo(w, 280)
      ..lineTo(0, 280)
      ..close();

    final Paint backRidgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF1E3A2F).withValues(alpha: 0.30),
          const Color(0xFF142B23).withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 30, w, 250));
    canvas.drawPath(backRidge, backRidgePaint);

    // Cordillera media (verde esmeralda andino)
    final Path frontRidge = Path()
      ..moveTo(0, 220)
      ..quadraticBezierTo(w * 0.28, 110, w * 0.50, 170)
      ..quadraticBezierTo(w * 0.72, 95, w, 160)
      ..lineTo(w, 320)
      ..lineTo(0, 320)
      ..close();

    final Paint frontRidgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF2D6A4F).withValues(alpha: 0.35),
          const Color(0xFF1B4332).withValues(alpha: 0.08),
        ],
      ).createShader(Rect.fromLTWH(0, 95, w, 230));
    canvas.drawPath(frontRidge, frontRidgePaint);

    // Sutil relieve montañoso a lo largo de la ruta
    for (double y = 450; y < h; y += 420) {
      final Path sideMtn = Path()
        ..moveTo(0, y + 80)
        ..quadraticBezierTo(w * 0.30, y - 40, w * 0.60, y + 60)
        ..lineTo(0, y + 100)
        ..close();
      canvas.drawPath(
        sideMtn,
        Paint()..color = const Color(0xFF2D6A4F).withValues(alpha: 0.12),
      );
    }
  }

  void _drawMountainStream(Canvas canvas, double w, double h) {
    // El río nace orgánicamente en el paso de montaña de la cordillera alta (y ~ 65)
    // y desciende sinuosas curvas hasta salir naturalmente por el fondo de la pantalla (h + 80).
    const double startY = 65.0;
    final double endY = h + 80.0;

    // Camino del río con ensanchamiento progresivo desde el deshielo hasta el valle
    final Path stream = Path()
      // Margen izquierdo del río
      ..moveTo(w * 0.745, startY)
      ..quadraticBezierTo(w * 0.73, 140, w * 0.81, 230)
      ..quadraticBezierTo(w * 0.89, 330, w * 0.77, 460)
      ..quadraticBezierTo(w * 0.68, 590, w * 0.84, 730)
      ..quadraticBezierTo(w * 0.94, 870, w * 0.76, 1020)
      ..quadraticBezierTo(w * 0.66, 1170, w * 0.83, 1330)
      ..quadraticBezierTo(w * 0.93, 1490, w * 0.78, endY)
      // Base ensanchada al salir de la pantalla
      ..lineTo(w * 0.86, endY)
      // Margen derecho del río
      ..quadraticBezierTo(w * 1.00, 1490, w * 0.90, 1330)
      ..quadraticBezierTo(w * 0.73, 1170, w * 0.83, 1020)
      ..quadraticBezierTo(w * 1.00, 870, w * 0.90, 730)
      ..quadraticBezierTo(w * 0.74, 590, w * 0.83, 460)
      ..quadraticBezierTo(w * 0.94, 330, w * 0.86, 230)
      ..quadraticBezierTo(w * 0.78, 140, w * 0.77, startY)
      ..close();

    final Paint streamPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFCAF0F8), // Nieve/deshielo cristalino en la cumbre
          Color(0xFF90E0EF),
          Color(0xFF00B4D8),
          Color(0xFF0096C7),
          Color(0xFF0077B6),
        ],
        stops: [0.0, 0.15, 0.45, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(w * 0.65, startY, w * 0.35, endY - startY));
    canvas.drawPath(stream, streamPaint);

    // Orilla y espuma en el nacimiento (pequeñas piedras y espuma de deshielo)
    final Paint springFoam = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.758, startY + 2), width: 14, height: 6),
      springFoam,
    );

    // Rocas de montaña en el nacimiento
    final Paint rockPaint = Paint()
      ..color = const Color(0xFF334155).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.742, startY + 1), 3.5, rockPaint);
    canvas.drawCircle(Offset(w * 0.775, startY + 2), 2.8, rockPaint);

    // Ondas y corrientes de agua translúcidas a lo largo del cauce
    final Paint ripplePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final Path ripples = Path()
      ..moveTo(w * 0.78, 190)
      ..quadraticBezierTo(w * 0.82, 220, w * 0.83, 240)
      ..moveTo(w * 0.82, 380)
      ..quadraticBezierTo(w * 0.80, 420, w * 0.78, 450)
      ..moveTo(w * 0.76, 640)
      ..quadraticBezierTo(w * 0.81, 675, w * 0.85, 715)
      ..moveTo(w * 0.86, 920)
      ..quadraticBezierTo(w * 0.82, 965, w * 0.78, 1010)
      ..moveTo(w * 0.77, 1220)
      ..quadraticBezierTo(w * 0.83, 1265, w * 0.87, 1315);
    canvas.drawPath(ripples, ripplePaint);
  }

  void _drawWaxPalm(Canvas canvas, Offset base, double height) {
    // Tronco blanco esbelto con ligera curvatura
    final Path trunk = Path()
      ..moveTo(base.dx - 2.0, base.dy)
      ..quadraticBezierTo(base.dx + 2.5, base.dy - height * 0.5, base.dx - 1.0, base.dy - height)
      ..lineTo(base.dx + 1.0, base.dy - height)
      ..quadraticBezierTo(base.dx + 4.5, base.dy - height * 0.5, base.dx + 2.0, base.dy)
      ..close();
    canvas.drawPath(trunk, Paint()..color = const Color(0xFFF8FAFC));

    // Sombra del tronco
    canvas.drawLine(
      Offset(base.dx - 0.5, base.dy),
      Offset(base.dx + 0.5, base.dy - height),
      Paint()
        ..color = const Color(0xFF94A3B8).withValues(alpha: 0.6)
        ..strokeWidth = 1.0,
    );

    // Anillos oscuros de la palma de cera
    final Paint ringPaint = Paint()
      ..color = const Color(0xFF64748B).withValues(alpha: 0.65)
      ..strokeWidth = 1.2;
    for (double f = 0.20; f <= 0.85; f += 0.15) {
      final double ringY = base.dy - height * f;
      final double ringX = base.dx + 1.2 * f;
      canvas.drawLine(Offset(ringX - 2.0, ringY), Offset(ringX + 2.0, ringY), ringPaint);
    }

    // Corona frondosa de palmas verdes
    final Offset top = Offset(base.dx, base.dy - height);
    final Paint deepLeaf = Paint()..color = const Color(0xFF1B4332);
    final Paint lightLeaf = Paint()..color = const Color(0xFF2D6A4F);
    final Paint brightLeaf = Paint()..color = const Color(0xFF4ADE80);

    // Puntas de palma radiales
    for (int i = 0; i < 7; i++) {
      final double angle = (i * math.pi / 3.5) - (math.pi / 1.8);
      final double lx = top.dx + math.cos(angle) * 16;
      final double ly = top.dy + math.sin(angle) * 12;
      canvas.drawLine(top, Offset(lx, ly), deepLeaf..strokeWidth = 2.2);
    }

    canvas.drawCircle(top, 9, deepLeaf);
    canvas.drawCircle(Offset(top.dx - 6, top.dy + 3), 7, lightLeaf);
    canvas.drawCircle(Offset(top.dx + 6, top.dy + 3), 7, lightLeaf);
    canvas.drawCircle(Offset(top.dx, top.dy - 6), 6, brightLeaf);
  }

  void _drawAndeanOak(Canvas canvas, Offset base, double radius) {
    // Tronco leñoso
    final Paint trunk = Paint()
      ..color = const Color(0xFF3E2723)
      ..strokeWidth = 4.2
      ..strokeCap = StrokeCap.round;
    final Offset trunkTop = Offset(base.dx, base.dy - radius * 1.2);
    canvas.drawLine(base, trunkTop, trunk);

    // Ramas
    canvas.drawLine(
      Offset(base.dx, base.dy - radius * 0.6),
      Offset(base.dx - radius * 0.6, base.dy - radius * 1.0),
      Paint()..color = const Color(0xFF3E2723)..strokeWidth = 2.4,
    );
    canvas.drawLine(
      Offset(base.dx, base.dy - radius * 0.7),
      Offset(base.dx + radius * 0.6, base.dy - radius * 1.1),
      Paint()..color = const Color(0xFF3E2723)..strokeWidth = 2.4,
    );

    // Copa frondosa en capas de verde andino
    final Offset center = Offset(trunkTop.dx, trunkTop.dy - 2);
    canvas.drawCircle(Offset(center.dx, center.dy + 3), radius, Paint()..color = const Color(0xFF1B4332));
    canvas.drawCircle(Offset(center.dx - radius * 0.6, center.dy + 2), radius * 0.75, Paint()..color = const Color(0xFF23533E));
    canvas.drawCircle(Offset(center.dx + radius * 0.6, center.dy + 2), radius * 0.75, Paint()..color = const Color(0xFF2D6A4F));
    canvas.drawCircle(Offset(center.dx, center.dy - radius * 0.4), radius * 0.7, Paint()..color = const Color(0xFF388E3C));
    canvas.drawCircle(Offset(center.dx + radius * 0.2, center.dy - radius * 0.5), radius * 0.45, Paint()..color = const Color(0xFF4CAF50));
  }

  void _drawOsoDeAnteojos(Canvas canvas, Offset pos, double scale) {
    // Oso de anteojos sentado amistosamente entre la vegetación
    final double s = scale;
    // Sombra en el suelo
    canvas.drawOval(
      Rect.fromCenter(center: Offset(pos.dx, pos.dy + 14 * s), width: 34 * s, height: 12 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.15),
    );

    // Cuerpo robusto
    canvas.drawOval(
      Rect.fromCenter(center: Offset(pos.dx, pos.dy + 2 * s), width: 28 * s, height: 26 * s),
      Paint()..color = const Color(0xFF1E293B),
    );

    // Patas traseras
    canvas.drawCircle(Offset(pos.dx - 11 * s, pos.dy + 10 * s), 7 * s, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(Offset(pos.dx + 11 * s, pos.dy + 10 * s), 7 * s, Paint()..color = const Color(0xFF0F172A));

    // Cabeza
    final Offset head = Offset(pos.dx, pos.dy - 12 * s);
    canvas.drawCircle(head, 13 * s, Paint()..color = const Color(0xFF1E293B));

    // Orejas redondeadas
    canvas.drawCircle(Offset(head.dx - 10 * s, head.dy - 10 * s), 4.5 * s, Paint()..color = const Color(0xFF0F172A));
    canvas.drawCircle(Offset(head.dx + 10 * s, head.dy - 10 * s), 4.5 * s, Paint()..color = const Color(0xFF0F172A));

    // Manchas cremas características del Oso de Anteojos alrededor de los ojos
    final Paint glassesPaint = Paint()..color = const Color(0xFFFDE68A);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(head.dx - 4.5 * s, head.dy - 2 * s), width: 7 * s, height: 8 * s),
      glassesPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(head.dx + 4.5 * s, head.dy - 2 * s), width: 7 * s, height: 8 * s),
      glassesPaint,
    );
    // Puente nasal crema
    canvas.drawRect(
      Rect.fromCenter(center: Offset(head.dx, head.dy + 2 * s), width: 4 * s, height: 6 * s),
      glassesPaint,
    );

    // Ojos
    canvas.drawCircle(Offset(head.dx - 4.5 * s, head.dy - 2 * s), 2.2 * s, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(head.dx + 4.5 * s, head.dy - 2 * s), 2.2 * s, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(head.dx - 4.0 * s, head.dy - 2.8 * s), 0.8 * s, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(head.dx + 5.0 * s, head.dy - 2.8 * s), 0.8 * s, Paint()..color = Colors.white);

    // Hocico y nariz
    canvas.drawOval(
      Rect.fromCenter(center: Offset(head.dx, head.dy + 3 * s), width: 5 * s, height: 4 * s),
      Paint()..color = const Color(0xFF0F172A),
    );
  }

  void _drawMossyBoulder(Canvas canvas, Offset pos, double w, double h) {
    // Roca base
    final Rect rect = Rect.fromCenter(center: pos, width: w, height: h);
    canvas.drawOval(rect, Paint()..color = const Color(0xFF64748B));
    // Sombra inferior
    canvas.drawOval(
      Rect.fromCenter(center: Offset(pos.dx, pos.dy + h * 0.2), width: w * 0.9, height: h * 0.6),
      Paint()..color = const Color(0xFF475569),
    );
    // Capa de musgo andino en la parte superior
    canvas.drawOval(
      Rect.fromCenter(center: Offset(pos.dx - 2, pos.dy - h * 0.25), width: w * 0.7, height: h * 0.5),
      Paint()..color = const Color(0xFF2D6A4F),
    );
  }

  void _drawWildOrchid(Canvas canvas, Offset pos, Color color) {
    canvas.drawCircle(pos, 5.0, Paint()..color = color);
    canvas.drawCircle(Offset(pos.dx - 4, pos.dy), 3.5, Paint()..color = color.withValues(alpha: 0.8));
    canvas.drawCircle(Offset(pos.dx + 4, pos.dy), 3.5, Paint()..color = color.withValues(alpha: 0.8));
    canvas.drawCircle(Offset(pos.dx, pos.dy - 4), 3.5, Paint()..color = color.withValues(alpha: 0.8));
    canvas.drawCircle(pos, 2.0, Paint()..color = const Color(0xFFFFD54F));
  }

  void _drawFloatingMist(Canvas canvas, Offset pos, double w, double h) {
    final Paint mist = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCenter(center: pos, width: w, height: h));
    canvas.drawOval(Rect.fromCenter(center: pos, width: w, height: h), mist);
  }

  // =========================================================================
  // 2. PÁRAMO — Frailejones, lagunas glaciares y cóndor
  // =========================================================================
  void _drawParamoScenery(Canvas canvas, double w, double h) {
    // 1. Picos escarpados de alta montaña (Crestas rocosas irregulares de páramo)
    final Path peakBack = Path()
      ..moveTo(0, 200)
      ..lineTo(w * 0.28, 70)
      ..lineTo(w * 0.45, 130)
      ..lineTo(w * 0.72, 35)
      ..lineTo(w * 0.88, 110)
      ..lineTo(w, 75)
      ..lineTo(w, 280)
      ..lineTo(0, 280)
      ..close();
    canvas.drawPath(peakBack, Paint()..color = const Color(0xFF263238).withValues(alpha: 0.35));

    final Path peakFront = Path()
      ..moveTo(0, 250)
      ..lineTo(w * 0.22, 120)
      ..lineTo(w * 0.38, 160)
      ..lineTo(w * 0.62, 90)
      ..lineTo(w * 0.82, 170)
      ..lineTo(w, 130)
      ..lineTo(w, 320)
      ..lineTo(0, 320)
      ..close();
    canvas.drawPath(peakFront, Paint()..color = const Color(0xFF37474F).withValues(alpha: 0.45));

    // Estratos y fallas rocosas en los picos de páramo
    final Paint rockCrevice = Paint()
      ..color = const Color(0xFF161C1F).withValues(alpha: 0.40)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.72, 35), Offset(w * 0.68, 140), rockCrevice);
    canvas.drawLine(Offset(w * 0.28, 70), Offset(w * 0.34, 150), rockCrevice);

    // 2. Laguna glaciar andina con orilla rocosa y turba
    final Offset lakeCenter1 = Offset(w * 0.80, 420);
    _drawParamoGlacialLagoon(canvas, lakeCenter1, 105, 54);

    // Segunda laguna glaciar en altitud media-baja (ecosistema de lagunas encadenadas)
    final Offset lakeCenter2 = Offset(w * 0.18, 980);
    _drawParamoGlacialLagoon(canvas, lakeCenter2, 85, 46);

    // 3. Frailejones nativos a los lados del camino (verde oliva opaco y caqui)
    _drawFrailejon(canvas, Offset(w * 0.16, 220), 28);
    _drawFrailejon(canvas, Offset(w * 0.84, 310), 32);
    _drawFrailejon(canvas, Offset(w * 0.14, 520), 30);
    _drawFrailejon(canvas, Offset(w * 0.88, 650), 34);
    _drawFrailejon(canvas, Offset(w * 0.18, 860), 31);
    _drawFrailejon(canvas, Offset(w * 0.82, 1140), 33);
    _drawFrailejon(canvas, Offset(w * 0.15, 1340), 29);

    // 4. Parches de pajonal andino (Calamagrostis) y turberas en tonos caqui/ocre
    for (double y = 280; y < h; y += 320) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.20, y), width: 50, height: 16),
        Paint()..color = const Color(0xFF8D7B50).withValues(alpha: 0.24),
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.82, y + 140), width: 56, height: 18),
        Paint()..color = const Color(0xFF6E6845).withValues(alpha: 0.26),
      );
      // Mechones de pajonal silvestre
      _drawParamoPajonalTuft(canvas, Offset(w * 0.22, y + 5));
      _drawParamoPajonalTuft(canvas, Offset(w * 0.80, y + 145));
    }

    // 5. Fauna andina: Venado de páramo pastando junto a la vegetación
    _drawParamoDeer(canvas, Offset(w * 0.76, 760));

    // 6. Manto de niebla densa de páramo
    _drawDenseFogBands(canvas, w, h);

    // 7. Cóndor planeando en las alturas
    _drawCondor(canvas, Offset(w * 0.35, 120), 1.2);
  }

  void _drawParamoGlacialLagoon(Canvas canvas, Offset center, double width, double height) {
    // Orilla de turba y piedra oscura
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width, height: height),
      Paint()..color = const Color(0xFF384339),
    );
    // Espejo de agua profunda
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width - 12, height: height - 10),
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF34565C), Color(0xFF1F373D), Color(0xFF132328)],
        ).createShader(Rect.fromCircle(center: center, radius: width / 2)),
    );
    // Ondas concéntricas de agua gélida
    canvas.drawOval(
      Rect.fromCenter(center: center, width: width * 0.45, height: height * 0.40),
      Paint()
        ..color = const Color(0xFF8EE3EF).withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  void _drawParamoPajonalTuft(Canvas canvas, Offset pos) {
    final Paint tuftPaint = Paint()
      ..color = const Color(0xFF9E8D5E).withValues(alpha: 0.60)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(pos, Offset(pos.dx - 3, pos.dy - 8), tuftPaint);
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - 10), tuftPaint);
    canvas.drawLine(pos, Offset(pos.dx + 3, pos.dy - 8), tuftPaint);
  }

  void _drawParamoDeer(Canvas canvas, Offset pos) {
    final Paint deerBody = Paint()..color = const Color(0xFF6D4C41).withValues(alpha: 0.85);
    // Cuerpo
    canvas.drawOval(Rect.fromCenter(center: pos, width: 22, height: 13), deerBody);
    // Cabeza y cuello
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx - 10, pos.dy - 9), width: 9, height: 7), deerBody);
    // Orejas
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx - 12, pos.dy - 14), width: 3, height: 6), deerBody);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx - 9, pos.dy - 14), width: 3, height: 6), deerBody);
    // Patas
    final Paint deerLeg = Paint()
      ..color = const Color(0xFF5D4037).withValues(alpha: 0.85)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(pos.dx - 6, pos.dy + 4), Offset(pos.dx - 6, pos.dy + 14), deerLeg);
    canvas.drawLine(Offset(pos.dx - 2, pos.dy + 4), Offset(pos.dx - 2, pos.dy + 14), deerLeg);
    canvas.drawLine(Offset(pos.dx + 5, pos.dy + 4), Offset(pos.dx + 5, pos.dy + 14), deerLeg);
    canvas.drawLine(Offset(pos.dx + 9, pos.dy + 4), Offset(pos.dx + 9, pos.dy + 14), deerLeg);
    // Cola blanca
    canvas.drawCircle(Offset(pos.dx + 11, pos.dy - 2), 2.5, Paint()..color = Colors.white.withValues(alpha: 0.8));
  }

  void _drawDenseFogBands(Canvas canvas, double w, double h) {
    final Paint fogPaint = Paint()
      ..color = const Color(0xFFECEFF1).withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    for (double y = 140; y < h; y += 380) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.50, y), width: w * 0.95, height: 60),
        fogPaint,
      );
    }
  }

  void _drawFrailejon(Canvas canvas, Offset base, double height) {
    final double trunkH = height * 0.65;
    // Tallo lanudo grueso de hojas secas (necromasa)
    canvas.drawRect(
      Rect.fromLTWH(base.dx - 3.5, base.dy - trunkH, 7, trunkH),
      Paint()..color = const Color(0xFF332219),
    );
    // Rayas de hojas viejas protectoras
    canvas.drawLine(
      Offset(base.dx - 3.5, base.dy - trunkH * 0.5),
      Offset(base.dx + 3.5, base.dy - trunkH * 0.5),
      Paint()..color = const Color(0xFF4A3525)..strokeWidth = 1.5,
    );

    // Roseta apical en verde oliva opaco y caqui
    final Offset top = Offset(base.dx, base.dy - trunkH);
    for (int i = 0; i < 8; i++) {
      final double angle = i * math.pi / 4;
      final double lx = top.dx + math.cos(angle) * (height * 0.45);
      final double ly = top.dy + math.sin(angle) * (height * 0.35);
      canvas.drawLine(
        top,
        Offset(lx, ly),
        Paint()
          ..color = const Color(0xFF6B705C) // Verde oliva opaco
          ..strokeWidth = 3.6
          ..strokeCap = StrokeCap.round,
      );
    }
    // Hojas interiores caqui / amarillo opaco
    for (int i = 0; i < 6; i++) {
      final double angle = (i * math.pi / 3) + 0.3;
      final double lx = top.dx + math.cos(angle) * (height * 0.28);
      final double ly = top.dy + math.sin(angle) * (height * 0.22);
      canvas.drawLine(
        top,
        Offset(lx, ly),
        Paint()
          ..color = const Color(0xFFB5A869) // Caqui / amarillo opaco
          ..strokeWidth = 2.8
          ..strokeCap = StrokeCap.round,
      );
    }
    // Núcleo lanudo plateado
    canvas.drawCircle(top, 4.5, Paint()..color = const Color(0xFFD8D3B8));
  }

  void _drawCondor(Canvas canvas, Offset pos, double scale) {
    final Path wings = Path()
      ..moveTo(pos.dx, pos.dy)
      ..quadraticBezierTo(pos.dx - 22 * scale, pos.dy - 12 * scale, pos.dx - 36 * scale, pos.dy - 4 * scale)
      ..lineTo(pos.dx - 20 * scale, pos.dy + 3 * scale)
      ..lineTo(pos.dx, pos.dy + 4 * scale)
      ..lineTo(pos.dx + 20 * scale, pos.dy + 3 * scale)
      ..lineTo(pos.dx + 36 * scale, pos.dy - 4 * scale)
      ..quadraticBezierTo(pos.dx + 22 * scale, pos.dy - 12 * scale, pos.dx, pos.dy)
      ..close();
    canvas.drawPath(wings, Paint()..color = const Color(0xFF212121));
    // Collar blanco del cóndor
    canvas.drawCircle(Offset(pos.dx, pos.dy + 2 * scale), 3 * scale, Paint()..color = Colors.white);
  }

  // =========================================================================
  // 3. OCÉANO — Arrecifes, algas, corales y tortuga marina
  // =========================================================================
  void _drawOceanoScenery(Canvas canvas, double w, double h) {
    // Corales ramificados
    _drawCoralBranch(canvas, Offset(w * 0.16, 260), const Color(0xFFFF7043));
    _drawCoralBranch(canvas, Offset(w * 0.84, 480), const Color(0xFFAB47BC));
    _drawCoralBranch(canvas, Offset(w * 0.14, 760), const Color(0xFFFFCA28));
    _drawCoralBranch(canvas, Offset(w * 0.86, 980), const Color(0xFF26A69A));

    // Tortuga marina nadando pacíficamente
    _drawSeaTurtle(canvas, Offset(w * 0.78, 340), 1.2);

    // Burbujas ascendiendo
    for (double y = 140; y < h; y += 180) {
      canvas.drawCircle(Offset(w * 0.22, y), 5, Paint()..color = Colors.white.withValues(alpha: 0.45));
      canvas.drawCircle(Offset(w * 0.80, y + 60), 7, Paint()..color = Colors.white.withValues(alpha: 0.35));
    }
  }

  void _drawCoralBranch(Canvas canvas, Offset base, Color color) {
    final Paint p = Paint()..color = color..strokeWidth = 4.0..strokeCap = StrokeCap.round;
    canvas.drawLine(base, Offset(base.dx, base.dy - 24), p);
    canvas.drawLine(Offset(base.dx, base.dy - 12), Offset(base.dx - 12, base.dy - 28), p);
    canvas.drawLine(Offset(base.dx, base.dy - 16), Offset(base.dx + 12, base.dy - 30), p);
  }

  void _drawSeaTurtle(Canvas canvas, Offset pos, double scale) {
    final double s = scale;
    // Caparazón
    canvas.drawOval(
      Rect.fromCenter(center: pos, width: 26 * s, height: 34 * s),
      Paint()..color = const Color(0xFF2E7D32),
    );
    // Aletas delanteras
    canvas.drawOval(
      Rect.fromCenter(center: Offset(pos.dx - 16 * s, pos.dy - 6 * s), width: 14 * s, height: 6 * s),
      Paint()..color = const Color(0xFF1B5E20),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(pos.dx + 16 * s, pos.dy - 6 * s), width: 14 * s, height: 6 * s),
      Paint()..color = const Color(0xFF1B5E20),
    );
    // Cabeza
    canvas.drawCircle(Offset(pos.dx, pos.dy - 20 * s), 5 * s, Paint()..color = const Color(0xFF388E3C));
  }

  // =========================================================================
  // 4. SELVA AMAZÓNICA — Dosel arbóreo equilibrado, ceibas colosales, lianas y fauna
  // =========================================================================
  void _drawSelvaAmazonicaScenery(Canvas canvas, double w, double h) {
    // 1. Manto suave de vapor del dosel tropical
    _drawJungleVaporBands(canvas, w, h);

    // 2. Ceibas y palmeras amazónicas enmarcando los costados con espaciado amplio y limpio
    for (double y = 180; y < h + 100; y += 320) {
      final bool alt = ((y ~/ 320) % 2) == 0;
      if (alt) {
        _drawRouteJungleCeiba(canvas, Offset(w * 0.11, y), 36);
        _drawRouteJunglePalm(canvas, Offset(w * 0.89, y + 90), 46);
        _drawRouteBroadleaf(canvas, Offset(w * 0.16, y + 15));
      } else {
        _drawRouteJungleCeiba(canvas, Offset(w * 0.88, y), 38);
        _drawRouteJunglePalm(canvas, Offset(w * 0.12, y + 80), 44);
        _drawRouteBroadleaf(canvas, Offset(w * 0.82, y + 18));
      }
    }

    // 3. Fauna emblemática distribuida armoniosamente
    // Danta en la sección media
    _drawRouteTapir(canvas, Offset(w * 0.22, 620));

    // Guacamayas rojas (posadas y volando)
    _drawRouteMacaw(canvas, Offset(w * 0.85, 290));
    _drawFlyingMacaw(canvas, Offset(w * 0.40, 480), 1.0);
    _drawRouteMacaw(canvas, Offset(w * 0.13, 940));

    // Tucán posado en el dosel alto
    _drawRouteToucan(canvas, Offset(w * 0.87, 780));

    // Mariposas Morpho azul revoloteando suavemente
    for (double y = 260; y < h; y += 440) {
      _drawRouteMorpho(canvas, Offset(w * 0.20, y));
      _drawRouteMorpho(canvas, Offset(w * 0.80, y + 220));
    }
  }

  void _drawJungleVaporBands(Canvas canvas, double w, double h) {
    final Paint mist = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    for (double y = 180; y < h; y += 380) {
      canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.50, y), width: w * 0.90, height: 50), mist);
    }
  }

  void _drawRouteJungleCeiba(Canvas canvas, Offset base, double radius) {
    // Tronco con raíces tablares
    final Path trunk = Path()
      ..moveTo(base.dx - 10, base.dy)
      ..lineTo(base.dx - 4, base.dy - 36)
      ..lineTo(base.dx + 4, base.dy - 36)
      ..lineTo(base.dx + 10, base.dy)
      ..close();
    canvas.drawPath(trunk, Paint()..color = const Color(0xFF3E2723));

    // Dosel estratificado
    final Offset center = Offset(base.dx, base.dy - 46);
    canvas.drawCircle(Offset(center.dx, center.dy + 4), radius, Paint()..color = const Color(0xFF0F2B1D));
    canvas.drawCircle(Offset(center.dx - radius * 0.5, center.dy + 2), radius * 0.75, Paint()..color = const Color(0xFF1B4332));
    canvas.drawCircle(Offset(center.dx + radius * 0.5, center.dy + 2), radius * 0.75, Paint()..color = const Color(0xFF1B4332));
    canvas.drawCircle(Offset(center.dx, center.dy - radius * 0.35), radius * 0.65, Paint()..color = const Color(0xFF2D6A4F));

    // Lianas colgantes de las ramas
    final Paint vine = Paint()
      ..color = const Color(0xFF388E3C).withValues(alpha: 0.85)
      ..strokeWidth = 1.4;
    canvas.drawLine(Offset(center.dx - 12, center.dy), Offset(center.dx - 10, base.dy - 6), vine);
    canvas.drawLine(Offset(center.dx + 14, center.dy), Offset(center.dx + 16, base.dy - 8), vine);
    canvas.drawCircle(Offset(center.dx - 10, base.dy - 10), 2.2, Paint()..color = const Color(0xFFFF4081));
  }

  void _drawRouteJunglePalm(Canvas canvas, Offset base, double height) {
    final Paint trunk = Paint()
      ..color = const Color(0xFF4A3525)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke;
    final Offset top = Offset(base.dx, base.dy - height);
    canvas.drawLine(base, top, trunk);

    final Paint frond = Paint()
      ..color = const Color(0xFF2D6A4F)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 7; i++) {
      final double angle = (i * math.pi / 3.5) - 0.2;
      final double fx = top.dx + math.cos(angle) * 16;
      final double fy = top.dy + math.sin(angle) * 9;
      canvas.drawLine(top, Offset(fx, fy), frond);
    }
  }

  void _drawRouteBroadleaf(Canvas canvas, Offset pos) {
    final Paint leaf = Paint()..color = const Color(0xFF2D6A4F).withValues(alpha: 0.75);
    final Paint leafLight = Paint()..color = const Color(0xFF52B788).withValues(alpha: 0.75);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx - 6, pos.dy - 6), width: 12, height: 18), leaf);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 6, pos.dy - 8), width: 14, height: 20), leafLight);
  }

  void _drawRouteTapir(Canvas canvas, Offset pos) {
    final Paint body = Paint()..color = const Color(0xFF2E241E).withValues(alpha: 0.85);
    // Cuerpo robusto
    canvas.drawOval(Rect.fromCenter(center: pos, width: 26, height: 16), body);
    // Cabeza con trompa
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 12, pos.dy - 3), width: 11, height: 9), body);
    // Probóscide
    canvas.drawLine(Offset(pos.dx + 17, pos.dy - 2), Offset(pos.dx + 19, pos.dy + 4), Paint()..color = const Color(0xFF221A15)..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    // Oreja con punta blanca
    canvas.drawCircle(Offset(pos.dx + 10, pos.dy - 7), 2.5, body);
    canvas.drawCircle(Offset(pos.dx + 10, pos.dy - 7), 1.0, Paint()..color = Colors.white);
    // Patas
    final Paint leg = Paint()..color = const Color(0xFF221A15)..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(pos.dx - 7, pos.dy + 6), Offset(pos.dx - 7, pos.dy + 16), leg);
    canvas.drawLine(Offset(pos.dx - 2, pos.dy + 6), Offset(pos.dx - 2, pos.dy + 16), leg);
    canvas.drawLine(Offset(pos.dx + 6, pos.dy + 6), Offset(pos.dx + 6, pos.dy + 16), leg);
  }

  void _drawRouteMacaw(Canvas canvas, Offset pos) {
    // Cuerpo rojo de guacamaya
    canvas.drawOval(Rect.fromCenter(center: pos, width: 8, height: 18), Paint()..color = const Color(0xFFD32F2F));
    // Ala azul y amarilla
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 2, pos.dy + 1), width: 5, height: 14), Paint()..color = const Color(0xFF1976D2));
    canvas.drawCircle(Offset(pos.dx + 2, pos.dy - 1), 2.0, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(Offset(pos.dx, pos.dy - 11), 3.5, Paint()..color = const Color(0xFFD32F2F));
    // Cola larga
    canvas.drawLine(Offset(pos.dx, pos.dy + 9), Offset(pos.dx + 1, pos.dy + 22), Paint()..color = const Color(0xFFD32F2F)..strokeWidth = 2.0);
  }

  void _drawFlyingMacaw(Canvas canvas, Offset pos, double scale) {
    final Paint red = Paint()..color = const Color(0xFFE53935);
    final Paint blue = Paint()..color = const Color(0xFF1E88E5);
    final Paint yellow = Paint()..color = const Color(0xFFFFEB3B);

    final Path wings = Path()
      ..moveTo(pos.dx, pos.dy)
      ..lineTo(pos.dx - 18 * scale, pos.dy - 8 * scale)
      ..lineTo(pos.dx - 12 * scale, pos.dy + 4 * scale)
      ..lineTo(pos.dx, pos.dy + 2 * scale)
      ..lineTo(pos.dx + 12 * scale, pos.dy + 4 * scale)
      ..lineTo(pos.dx + 18 * scale, pos.dy - 8 * scale)
      ..close();
    canvas.drawPath(wings, red);

    canvas.drawLine(Offset(pos.dx - 16 * scale, pos.dy - 6 * scale), Offset(pos.dx - 8 * scale, pos.dy), yellow..strokeWidth = 2.0);
    canvas.drawLine(Offset(pos.dx + 16 * scale, pos.dy - 6 * scale), Offset(pos.dx + 8 * scale, pos.dy), yellow..strokeWidth = 2.0);
    canvas.drawLine(Offset(pos.dx - 18 * scale, pos.dy - 8 * scale), Offset(pos.dx - 10 * scale, pos.dy - 1 * scale), blue..strokeWidth = 2.0);
    canvas.drawLine(Offset(pos.dx + 18 * scale, pos.dy - 8 * scale), Offset(pos.dx + 10 * scale, pos.dy - 1 * scale), blue..strokeWidth = 2.0);

    canvas.drawLine(pos, Offset(pos.dx, pos.dy + 14 * scale), red..strokeWidth = 2.2);
  }

  void _drawRouteToucan(Canvas canvas, Offset pos) {
    canvas.drawOval(Rect.fromCenter(center: pos, width: 8, height: 14), Paint()..color = const Color(0xFF212121));
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx - 2, pos.dy - 2), width: 5, height: 7), Paint()..color = const Color(0xFFFFF9C4));
    final Path bill = Path()
      ..moveTo(pos.dx - 3, pos.dy - 5)
      ..quadraticBezierTo(pos.dx - 12, pos.dy - 3, pos.dx - 14, pos.dy + 1)
      ..lineTo(pos.dx - 3, pos.dy)
      ..close();
    canvas.drawPath(bill, Paint()..color = const Color(0xFFFFB300));
    canvas.drawCircle(Offset(pos.dx - 13, pos.dy + 1), 1.2, Paint()..color = const Color(0xFFE53935));
  }

  void _drawRouteMorpho(Canvas canvas, Offset pos) {
    final Paint wing = Paint()..color = const Color(0xFF00B4D8).withValues(alpha: 0.85);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx - 3, pos.dy - 2), width: 7, height: 6), wing);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 3, pos.dy - 2), width: 7, height: 6), wing);
    canvas.drawCircle(pos, 1.2, Paint()..color = Colors.black);
  }

  // =========================================================================
  // 5. MANGLAR — Raíces zancudas sobre agua salobre y garzas
  // =========================================================================
  void _drawManglarScenery(Canvas canvas, double w, double h) {
    for (double y = 200; y < h; y += 380) {
      _drawMangroveTree(canvas, Offset(w * 0.15, y));
      _drawMangroveTree(canvas, Offset(w * 0.85, y + 180));
    }
  }

  void _drawMangroveTree(Canvas canvas, Offset pos) {
    // Raíces zancudas
    final Paint roots = Paint()..color = const Color(0xFF4E342E)..strokeWidth = 3.2..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx - 14, pos.dy + 24), roots);
    canvas.drawLine(pos, Offset(pos.dx + 14, pos.dy + 24), roots);
    canvas.drawLine(pos, Offset(pos.dx, pos.dy + 26), roots);
    // Copa verde denso
    canvas.drawCircle(Offset(pos.dx, pos.dy - 18), 24, Paint()..color = const Color(0xFF00695C));
  }

  // =========================================================================
  // 6. BOSQUE SECO TROPICAL — Cárcavas de la Tatacoa, guayacanes y cardones
  // =========================================================================
  void _drawBosqueSecoScenery(Canvas canvas, double w, double h) {
    for (double y = 180; y < h; y += 340) {
      final bool alt = ((y ~/ 340) % 2) == 0;
      if (alt) {
        _drawYellowGuayacan(canvas, Offset(w * 0.15, y));
        _drawRouteCactus(canvas, Offset(w * 0.86, y + 80));
      } else {
        _drawYellowGuayacan(canvas, Offset(w * 0.85, y));
        _drawRouteCactus(canvas, Offset(w * 0.14, y + 80));
      }
    }
  }

  void _drawRouteCactus(Canvas canvas, Offset pos) {
    final Paint cactusGreen = Paint()
      ..color = const Color(0xFF386641)
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - 28), cactusGreen);
    canvas.drawLine(Offset(pos.dx, pos.dy - 12), Offset(pos.dx - 8, pos.dy - 12), cactusGreen);
    canvas.drawLine(Offset(pos.dx - 8, pos.dy - 12), Offset(pos.dx - 8, pos.dy - 24), cactusGreen);
    canvas.drawLine(Offset(pos.dx, pos.dy - 10), Offset(pos.dx + 8, pos.dy - 10), cactusGreen);
    canvas.drawLine(Offset(pos.dx + 8, pos.dy - 10), Offset(pos.dx + 8, pos.dy - 26), cactusGreen);
  }

  void _drawYellowGuayacan(Canvas canvas, Offset pos) {
    canvas.drawRect(Rect.fromLTWH(pos.dx - 3, pos.dy - 26, 6, 26), Paint()..color = const Color(0xFF5D4037));
    // Copa amarilla espectacular
    canvas.drawCircle(Offset(pos.dx, pos.dy - 32), 26, Paint()..color = const Color(0xFFFFD54F));
    canvas.drawCircle(Offset(pos.dx - 10, pos.dy - 30), 18, Paint()..color = const Color(0xFFFFCA28));
    canvas.drawCircle(Offset(pos.dx + 10, pos.dy - 30), 18, Paint()..color = const Color(0xFFFFEE58));
  }

  // =========================================================================
  // 7. LLANOS Y SABANA — Palmas moriche, ganadería llanera, corocoras y chigüiros
  // =========================================================================
  void _drawLlanosScenery(Canvas canvas, double w, double h) {
    // 1. Palmas moriche a ambos lados de la ruta
    for (double y = 180; y < h; y += 380) {
      _drawMorichePalm(canvas, Offset(w * 0.13, y));
      _drawMorichePalm(canvas, Offset(w * 0.87, y + 190));
    }

    // 2. Cercos de hato ganadero llanero
    _drawRouteHatoFence(canvas, Offset(w * 0.05, 360), Offset(w * 0.28, 360));
    _drawRouteHatoFence(canvas, Offset(w * 0.72, 720), Offset(w * 0.95, 720));

    // 3. Ganadería llanera criolla (vaca cebú con giba y ternero)
    _drawRouteLlaneroCattle(canvas, Offset(w * 0.20, 395));
    _drawRouteLlaneroCattle(canvas, Offset(w * 0.82, 755), isCalf: true);

    // 4. Corocoras rojas en el suelo y en vuelo
    _drawRouteCorocora(canvas, Offset(w * 0.77, 330));
    _drawRouteCorocora(canvas, Offset(w * 0.83, 345));
    _drawRouteFlyingCorocora(canvas, Offset(w * 0.38, 220));
    _drawRouteFlyingCorocora(canvas, Offset(w * 0.46, 205));

    // 5. Familia de Chigüiros (Capibaras)
    _drawCapybara(canvas, Offset(w * 0.22, 850));
    _drawCapybara(canvas, Offset(w * 0.28, 858), isSmall: true);

    // 6. Mechones de pasto dorado de sabana
    for (double y = 220; y < h; y += 260) {
      _drawRouteLlanosGrass(canvas, Offset(w * 0.09, y));
      _drawRouteLlanosGrass(canvas, Offset(w * 0.91, y + 130));
    }
  }

  void _drawMorichePalm(Canvas canvas, Offset pos) {
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - 65), Paint()..color = const Color(0xFF6D4C41)..strokeWidth = 3.5);
    final Offset top = Offset(pos.dx, pos.dy - 65);
    // Corona de frondas de palma moriche
    final Paint frond = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 7; i++) {
      final double angle = (i * math.pi / 3.5) - 0.2;
      final double fx = top.dx + math.cos(angle) * 16;
      final double fy = top.dy + math.sin(angle) * 10;
      canvas.drawLine(top, Offset(fx, fy), frond);
    }
    canvas.drawCircle(top, 10, Paint()..color = const Color(0xFF1B5E20));
    // Racimos de moriche
    canvas.drawCircle(Offset(top.dx - 3, top.dy + 6), 3, Paint()..color = const Color(0xFFD84315));
    canvas.drawCircle(Offset(top.dx + 3, top.dy + 6), 3, Paint()..color = const Color(0xFFBF360C));
  }

  void _drawRouteHatoFence(Canvas canvas, Offset p1, Offset p2) {
    final Paint wire = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(p1.dx, p1.dy - 6), Offset(p2.dx, p2.dy - 6), wire);
    canvas.drawLine(Offset(p1.dx, p1.dy - 14), Offset(p2.dx, p2.dy - 14), wire);

    final Paint post = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    const int count = 4;
    for (int i = 0; i < count; i++) {
      final double t = i / (count - 1);
      final double x = p1.dx + (p2.dx - p1.dx) * t;
      final double y = p1.dy + (p2.dy - p1.dy) * t;
      canvas.drawLine(Offset(x, y), Offset(x, y - 20), post);
    }
  }

  void _drawRouteLlaneroCattle(Canvas canvas, Offset pos, {bool isCalf = false}) {
    final double s = isCalf ? 0.65 : 1.0;
    final Paint coat = Paint()..color = const Color(0xFFECEFF1);

    // Patas
    final Paint leg = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..strokeWidth = 2.0 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(pos.dx - 7 * s, pos.dy + 4 * s), Offset(pos.dx - 7 * s, pos.dy + 14 * s), leg);
    canvas.drawLine(Offset(pos.dx - 2 * s, pos.dy + 4 * s), Offset(pos.dx - 2 * s, pos.dy + 14 * s), leg);
    canvas.drawLine(Offset(pos.dx + 4 * s, pos.dy + 4 * s), Offset(pos.dx + 4 * s, pos.dy + 14 * s), leg);
    canvas.drawLine(Offset(pos.dx + 8 * s, pos.dy + 4 * s), Offset(pos.dx + 8 * s, pos.dy + 14 * s), leg);

    // Cuerpo
    canvas.drawOval(Rect.fromCenter(center: pos, width: 22 * s, height: 14 * s), coat);
    // Giba
    if (!isCalf) {
      canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 3 * s, pos.dy - 6 * s), width: 7 * s, height: 5 * s), coat);
    }

    // Cabeza
    final Offset headPos = Offset(pos.dx + 11 * s, pos.dy - 3 * s);
    canvas.drawOval(Rect.fromCenter(center: headPos, width: 9 * s, height: 10 * s), coat);
    canvas.drawOval(Rect.fromCenter(center: Offset(headPos.dx + 3 * s, headPos.dy + 3 * s), width: 5 * s, height: 4 * s), Paint()..color = const Color(0xFF78909C));

    // Cuernos si es adulto
    if (!isCalf) {
      final Paint horn = Paint()
        ..color = const Color(0xFFFFF8E1)
        ..strokeWidth = 1.6 * s
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(headPos.dx, headPos.dy - 4 * s), Offset(headPos.dx - 3 * s, headPos.dy - 8 * s), horn);
      canvas.drawLine(Offset(headPos.dx + 3 * s, headPos.dy - 4 * s), Offset(headPos.dx + 6 * s, headPos.dy - 8 * s), horn);
    }

    // Cola
    canvas.drawLine(Offset(pos.dx - 10 * s, pos.dy), Offset(pos.dx - 12 * s, pos.dy + 8 * s), Paint()..color = const Color(0xFF90A4AE)..strokeWidth = 1.2 * s);
  }

  void _drawRouteCorocora(Canvas canvas, Offset pos) {
    final Paint red = Paint()..color = const Color(0xFFE53935);
    // Patas largas
    final Paint leg = Paint()..color = const Color(0xFFFF8A80)..strokeWidth = 1.2;
    canvas.drawLine(pos, Offset(pos.dx - 2, pos.dy + 9), leg);
    canvas.drawLine(pos, Offset(pos.dx + 2, pos.dy + 9), leg);
    // Cuerpo
    canvas.drawOval(Rect.fromCenter(center: pos, width: 7, height: 11), red);
    // Cabeza y cuello
    canvas.drawCircle(Offset(pos.dx + 3, pos.dy - 7), 2.5, red);
    // Pico curvado largo
    final Path bill = Path()
      ..moveTo(pos.dx + 4, pos.dy - 7)
      ..quadraticBezierTo(pos.dx + 8, pos.dy - 7, pos.dx + 9, pos.dy - 2);
    canvas.drawPath(bill, Paint()..color = const Color(0xFFB71C1C)..strokeWidth = 1.2..style = PaintingStyle.stroke);
  }

  void _drawRouteFlyingCorocora(Canvas canvas, Offset pos) {
    final Paint redBird = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final Path wings = Path()
      ..moveTo(pos.dx - 8, pos.dy - 2)
      ..quadraticBezierTo(pos.dx - 4, pos.dy + 2, pos.dx, pos.dy)
      ..quadraticBezierTo(pos.dx + 4, pos.dy + 2, pos.dx + 8, pos.dy - 2);
    canvas.drawPath(wings, redBird);
    canvas.drawCircle(Offset(pos.dx, pos.dy), 1.2, Paint()..color = const Color(0xFFB71C1C));
  }

  void _drawCapybara(Canvas canvas, Offset pos, {bool isSmall = false}) {
    final double s = isSmall ? 0.65 : 1.0;
    canvas.drawOval(Rect.fromCenter(center: pos, width: 26 * s, height: 16 * s), Paint()..color = const Color(0xFF795548));
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 11 * s, pos.dy - 4 * s), width: 12 * s, height: 11 * s), Paint()..color = const Color(0xFF6D4C41));
    canvas.drawCircle(Offset(pos.dx + 12 * s, pos.dy - 7 * s), 1.5 * s, Paint()..color = const Color(0xFF4E342E));
    canvas.drawCircle(Offset(pos.dx + 14 * s, pos.dy - 4 * s), 1.0 * s, Paint()..color = Colors.black);
  }

  void _drawRouteLlanosGrass(Canvas canvas, Offset pos) {
    final Paint grass = Paint()
      ..color = const Color(0xFFD4E09B).withValues(alpha: 0.8)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(pos, Offset(pos.dx - 4, pos.dy - 10), grass);
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - 13), grass);
    canvas.drawLine(pos, Offset(pos.dx + 4, pos.dy - 9), grass);
  }

  @override
  bool shouldRepaint(covariant EcosystemRouteSceneryPainter oldDelegate) =>
      oldDelegate.ecoCode != ecoCode || oldDelegate.totalHeight != totalHeight;
}
