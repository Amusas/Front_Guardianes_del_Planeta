import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Emblema e ícono vectorial oficial de "Guardianes del Planeta".
/// Representa la Tierra protegida por alas de hojas de guardián,
/// un brote de vida en la cima, el escudo dorado de explorador
/// y destellos de aventura y conservación.
class PlanetEarthLogo extends StatelessWidget {
  final double size;

  const PlanetEarthLogo({super.key, this.size = 120.0});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Emblema de Guardianes del Planeta: La Tierra protegida por hojas de guardián con brote de vida y escudo dorado',
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _GuardianPlanetPainter(),
        ),
      ),
    );
  }
}

class _GuardianPlanetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.52);
    final planetRadius = w * 0.32;

    // 1. Resplandor / Halo exterior atmosférico
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.pastelGreen.withOpacity(0.55),
          AppColors.turquoiseLight.withOpacity(0.20),
          Colors.transparent,
        ],
        stops: const [0.35, 0.70, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: planetRadius * 1.55));
    canvas.drawCircle(center, planetRadius * 1.55, auraPaint);

    // 2. Alas protectoras de Laurel / Hojas de Guardián que abrazan el planeta
    _drawGuardianLaurelWings(canvas, w, h, center, planetRadius);

    // 3. Sombra inferior proyectada por el planeta
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + planetRadius * 0.98),
        width: planetRadius * 1.35,
        height: planetRadius * 0.22,
      ),
      Paint()..color = AppColors.forestGreenDark.withOpacity(0.22),
    );

    // 4. Esfera base del Planeta Tierra (Gradiente oceánico vibrante)
    final oceanRect = Rect.fromCircle(center: center, radius: planetRadius);
    final oceanShader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF56CFE1),       // Turquesa luminoso
        AppColors.turquoise,      // Turquesa oceánico
        AppColors.turquoiseDark,  // Azul marino profundo
        Color(0xFF003554),       // Abismo marino
      ],
      stops: [0.0, 0.38, 0.78, 1.0],
    ).createShader(oceanRect);

    final oceanPaint = Paint()
      ..shader = oceanShader
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, planetRadius, oceanPaint);

    // 5. Contenido interno del planeta recortado a la esfera
    canvas.save();
    canvas.clipPath(Path()..addOval(oceanRect));

    // Líneas sutiles de coordenadas esféricas
    _drawCoordinateLines(canvas, center, planetRadius);

    // Continentes detallados con relieve
    _drawContinents(canvas, center, planetRadius);

    // Destello de biodiversidad en Colombia
    _drawColombiaBeacon(canvas, center, planetRadius);

    // Nubes dinámicas estilizadas
    _drawAtmosphereClouds(canvas, center, planetRadius);

    // Sombreado 3D y brillo especular
    _drawSphereLighting(canvas, center, planetRadius);

    canvas.restore();

    // 6. Aro sutil de atmósfera exterior
    final rimPaint = Paint()
      ..color = AppColors.white.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, w * 0.016);
    canvas.drawCircle(center, planetRadius - rimPaint.strokeWidth * 0.5, rimPaint);

    // 7. Brote de Vida del Guardián (en el polo norte del planeta)
    _drawGuardianSprout(canvas, w, h, center, planetRadius);

    // 8. Escudo / Medallón dorado de Guardián (en la base del emblema)
    _drawGuardianMedal(canvas, center, planetRadius, w);

    // 9. Destellos mágicos y estrellas de exploración
    _drawSparkles(canvas, w, h);
  }

  /// Dibuja las alas de hojas de laurel que abrazan el planeta
  void _drawGuardianLaurelWings(Canvas canvas, double w, double h, Offset center, double r) {
    // Definición de hojas en cada lado (ángulo relativo, escala, rotación)
    final leafConfigs = [
      // Lado izquierdo (de abajo hacia arriba)
      {'angle': 2.35, 'dist': r * 1.02, 'rot': 0.55, 'scale': 1.0, 'left': true},
      {'angle': 2.70, 'dist': r * 1.06, 'rot': 0.15, 'scale': 1.15, 'left': true},
      {'angle': 3.10, 'dist': r * 1.08, 'rot': -0.25, 'scale': 1.25, 'left': true},
      {'angle': 3.50, 'dist': r * 1.05, 'rot': -0.65, 'scale': 1.05, 'left': true},
      {'angle': 3.85, 'dist': r * 0.98, 'rot': -1.05, 'scale': 0.85, 'left': true},

      // Lado derecho (simétrico, abrazando el planeta)
      {'angle': 0.80, 'dist': r * 1.02, 'rot': -0.55, 'scale': 1.0, 'left': false},
      {'angle': 0.44, 'dist': r * 1.06, 'rot': -0.15, 'scale': 1.15, 'left': false},
      {'angle': 0.04, 'dist': r * 1.08, 'rot': 0.25, 'scale': 1.25, 'left': false},
      {'angle': -0.36, 'dist': r * 1.05, 'rot': 0.65, 'scale': 1.05, 'left': false},
      {'angle': -0.71, 'dist': r * 0.98, 'rot': 1.05, 'scale': 0.85, 'left': false},
    ];

    // Tallo de soporte / arco curvo debajo
    final stemPaint = Paint()
      ..color = AppColors.forestGreenDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.0, w * 0.022)
      ..strokeCap = StrokeCap.round;

    final leftStem = Path();
    leftStem.moveTo(center.dx, center.dy + r * 1.08);
    leftStem.quadraticBezierTo(
      center.dx - r * 1.25, center.dy + r * 0.75,
      center.dx - r * 1.08, center.dy - r * 0.35,
    );
    canvas.drawPath(leftStem, stemPaint);

    final rightStem = Path();
    rightStem.moveTo(center.dx, center.dy + r * 1.08);
    rightStem.quadraticBezierTo(
      center.dx + r * 1.25, center.dy + r * 0.75,
      center.dx + r * 1.08, center.dy - r * 0.35,
    );
    canvas.drawPath(rightStem, stemPaint);

    // Dibujar cada hoja del laurel
    for (final cfg in leafConfigs) {
      final angle = cfg['angle'] as double;
      final dist = cfg['dist'] as double;
      final rot = cfg['rot'] as double;
      final scale = cfg['scale'] as double;
      final isLeft = cfg['left'] as bool;

      final pos = Offset(
        center.dx + dist * math.cos(angle),
        center.dy + dist * math.sin(angle),
      );

      _drawSingleLaurelLeaf(canvas, pos, rot, scale * (w * 0.08), isLeft);
    }
  }

  /// Dibuja una hoja de laurel estilizada con gradiente y nervadura
  void _drawSingleLaurelLeaf(Canvas canvas, Offset pos, double rotation, double length, bool isLeft) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(rotation);

    final leafWidth = length * 0.52;

    // Sombra exterior de la hoja
    final shadowPath = Path();
    shadowPath.moveTo(0, 0);
    shadowPath.quadraticBezierTo(leafWidth * 0.7, -length * 0.5, 0, -length);
    shadowPath.quadraticBezierTo(-leafWidth * 0.7, -length * 0.5, 0, 0);
    canvas.drawPath(shadowPath, Paint()..color = AppColors.forestGreenDark);

    // Cuerpo principal de la hoja con gradiente esmeralda
    final leafBody = Path();
    leafBody.moveTo(0, 0);
    leafBody.quadraticBezierTo(leafWidth * 0.62, -length * 0.48, 0, -length * 0.95);
    leafBody.quadraticBezierTo(-leafWidth * 0.62, -length * 0.48, 0, 0);

    final leafGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: isLeft
          ? const [AppColors.forestGreen, AppColors.emerald, AppColors.emeraldLight]
          : const [AppColors.forestGreenDark, AppColors.emerald, AppColors.pastelGreen],
    ).createShader(Rect.fromCenter(center: Offset(0, -length * 0.5), width: leafWidth, height: length));

    canvas.drawPath(leafBody, Paint()..shader = leafGradient);

    // Resplandor en la mitad de la hoja (relieve)
    final highlightPath = Path();
    highlightPath.moveTo(0, 0);
    highlightPath.quadraticBezierTo(leafWidth * 0.55, -length * 0.48, 0, -length * 0.95);
    highlightPath.close();
    canvas.drawPath(
      highlightPath,
      Paint()..color = AppColors.white.withOpacity(0.18),
    );

    // Nervadura central dorada sutil
    final veinPaint = Paint()
      ..color = AppColors.goldLight.withOpacity(0.75)
      ..strokeWidth = math.max(1.0, length * 0.07)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(0, 0), Offset(0, -length * 0.78), veinPaint);

    canvas.restore();
  }

  /// Líneas esféricas de latitud / longitud sutiles
  void _drawCoordinateLines(Canvas canvas, Offset center, double r) {
    final linePaint = Paint()
      ..color = AppColors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Ecuador
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + r * 0.05), width: r * 2.0, height: r * 0.55),
      linePaint,
    );
    // Trópico norte
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy - r * 0.38), width: r * 1.8, height: r * 0.45),
      linePaint,
    );
    // Trópico sur
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + r * 0.48), width: r * 1.7, height: r * 0.42),
      linePaint,
    );
  }

  /// Dibuja los continentes estilizados con relieve y vegetación
  void _drawContinents(Canvas canvas, Offset center, double r) {
    final landUnderlayPaint = Paint()
      ..color = AppColors.forestGreenDark
      ..style = PaintingStyle.fill;

    final landPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.emeraldLight,
          AppColors.emerald,
          AppColors.forestGreen,
        ],
        stops: [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: r))
      ..style = PaintingStyle.fill;

    // 1. América del Norte y Centroamérica (Esquina superior izquierda)
    final northAmerica = Path();
    northAmerica.moveTo(center.dx - r * 0.95, center.dy - r * 0.45);
    northAmerica.quadraticBezierTo(center.dx - r * 0.65, center.dy - r * 0.85, center.dx - r * 0.25, center.dy - r * 0.80);
    northAmerica.quadraticBezierTo(center.dx - r * 0.15, center.dy - r * 0.60, center.dx - r * 0.30, center.dy - r * 0.35);
    northAmerica.quadraticBezierTo(center.dx - r * 0.20, center.dy - r * 0.20, center.dx - r * 0.32, center.dy - r * 0.05); // Istmo
    northAmerica.quadraticBezierTo(center.dx - r * 0.55, center.dy - r * 0.15, center.dx - r * 0.75, center.dy - r * 0.10);
    northAmerica.quadraticBezierTo(center.dx - r * 0.90, center.dy - r * 0.25, center.dx - r * 0.95, center.dy - r * 0.45);
    northAmerica.close();

    // 2. América del Sur (Centro - Destacando Colombia y Amazonía)
    final southAmerica = Path();
    southAmerica.moveTo(center.dx - r * 0.32, center.dy - r * 0.05); // Entrada desde Panamá / Caribe colombiano
    southAmerica.quadraticBezierTo(center.dx - r * 0.10, center.dy - r * 0.08, center.dx + r * 0.05, center.dy + r * 0.02); // Costa caribe
    southAmerica.quadraticBezierTo(center.dx + r * 0.28, center.dy + r * 0.15, center.dx + r * 0.22, center.dy + r * 0.38); // Saliente de Brasil / Amazonas
    southAmerica.quadraticBezierTo(center.dx + r * 0.08, center.dy + r * 0.62, center.dx - r * 0.02, center.dy + r * 0.82); // Hacia Patagonia
    southAmerica.quadraticBezierTo(center.dx - r * 0.12, center.dy + r * 0.80, center.dx - r * 0.15, center.dy + r * 0.60); // Cabo de Hornos
    southAmerica.quadraticBezierTo(center.dx - r * 0.28, center.dy + r * 0.32, center.dx - r * 0.32, center.dy + r * 0.15); // Costa del Pacífico
    southAmerica.quadraticBezierTo(center.dx - r * 0.38, center.dy + r * 0.05, center.dx - r * 0.32, center.dy - r * 0.05);
    southAmerica.close();

    // 3. Europa y África (Hemisferio derecho)
    final africaEurope = Path();
    africaEurope.moveTo(center.dx + r * 0.42, center.dy - r * 0.70); // Europa
    africaEurope.quadraticBezierTo(center.dx + r * 0.65, center.dy - r * 0.75, center.dx + r * 0.85, center.dy - r * 0.60);
    africaEurope.quadraticBezierTo(center.dx + r * 0.75, center.dy - r * 0.35, center.dx + r * 0.88, center.dy - r * 0.15);
    africaEurope.quadraticBezierTo(center.dx + r * 0.95, center.dy + r * 0.15, center.dx + r * 0.72, center.dy + r * 0.45); // África sur
    africaEurope.quadraticBezierTo(center.dx + r * 0.55, center.dy + r * 0.60, center.dx + r * 0.45, center.dy + r * 0.40);
    africaEurope.quadraticBezierTo(center.dx + r * 0.48, center.dy + r * 0.10, center.dx + r * 0.38, center.dy - r * 0.10); // Golfo de Guinea
    africaEurope.quadraticBezierTo(center.dx + r * 0.32, center.dy - r * 0.35, center.dx + r * 0.42, center.dy - r * 0.70);
    africaEurope.close();

    // 4. Isla / Antillas
    final islands = Path()
      ..addOval(Rect.fromCircle(center: Offset(center.dx - r * 0.12, center.dy - r * 0.20), radius: r * 0.045))
      ..addOval(Rect.fromCircle(center: Offset(center.dx - r * 0.02, center.dy - r * 0.16), radius: r * 0.035))
      ..addOval(Rect.fromCircle(center: Offset(center.dx + r * 0.88, center.dy + r * 0.32), radius: r * 0.04)); // Madagascar estilizada

    // Dibujar sombras de base (relieve de costa)
    canvas.save();
    canvas.translate(1.5, 2.0);
    canvas.drawPath(northAmerica, landUnderlayPaint);
    canvas.drawPath(southAmerica, landUnderlayPaint);
    canvas.drawPath(africaEurope, landUnderlayPaint);
    canvas.drawPath(islands, landUnderlayPaint);
    canvas.restore();

    // Dibujar continentes iluminados
    canvas.drawPath(northAmerica, landPaint);
    canvas.drawPath(southAmerica, landPaint);
    canvas.drawPath(africaEurope, landPaint);
    canvas.drawPath(islands, landPaint);

    // Resaltado de la cordillera de los Andes (veta verde lima / dorada suave)
    final andesRidge = Path();
    andesRidge.moveTo(center.dx - r * 0.28, center.dy + r * 0.02);
    andesRidge.quadraticBezierTo(center.dx - r * 0.22, center.dy + r * 0.25, center.dx - r * 0.18, center.dy + r * 0.52);
    final ridgePaint = Paint()
      ..color = AppColors.pastelGreen.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, r * 0.04)
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(andesRidge, ridgePaint);
  }

  /// Faro / Destello guardián en la posición de Colombia
  void _drawColombiaBeacon(Canvas canvas, Offset center, double r) {
    final colombiaPos = Offset(center.dx - r * 0.16, center.dy - r * 0.02);

    // Aura dorada de Colombia
    canvas.drawCircle(
      colombiaPos,
      r * 0.11,
      Paint()..color = AppColors.gold.withOpacity(0.28),
    );
    canvas.drawCircle(
      colombiaPos,
      r * 0.06,
      Paint()..color = AppColors.goldLight.withOpacity(0.6),
    );

    // Pequeño diamante brillante
    _draw4PointStar(
      canvas,
      colombiaPos,
      outerRadius: r * 0.075,
      innerRadius: r * 0.025,
      paint: Paint()..color = AppColors.gold,
    );
    canvas.drawCircle(colombiaPos, r * 0.02, Paint()..color = AppColors.white);
  }

  /// Nubes atmosféricas semitransparentes en suaves curvas
  void _drawAtmosphereClouds(Canvas canvas, Offset center, double r) {
    final cloudPaint = Paint()
      ..color = AppColors.white.withOpacity(0.40)
      ..style = PaintingStyle.fill;

    // Nube 1: Hemisferio norte
    final cloud1 = Path();
    cloud1.moveTo(center.dx - r * 0.75, center.dy - r * 0.50);
    cloud1.quadraticBezierTo(center.dx - r * 0.40, center.dy - r * 0.65, center.dx - r * 0.05, center.dy - r * 0.45);
    cloud1.quadraticBezierTo(center.dx + r * 0.25, center.dy - r * 0.35, center.dx + r * 0.60, center.dy - r * 0.42);
    cloud1.quadraticBezierTo(center.dx + r * 0.40, center.dy - r * 0.30, center.dx, center.dy - r * 0.35);
    cloud1.quadraticBezierTo(center.dx - r * 0.35, center.dy - r * 0.45, center.dx - r * 0.75, center.dy - r * 0.50);
    cloud1.close();
    canvas.drawPath(cloud1, cloudPaint);

    // Nube 2: Hemisferio sur / Pacífico
    final cloud2 = Path();
    cloud2.moveTo(center.dx - r * 0.85, center.dy + r * 0.42);
    cloud2.quadraticBezierTo(center.dx - r * 0.55, center.dy + r * 0.32, center.dx - r * 0.25, center.dy + r * 0.48);
    cloud2.quadraticBezierTo(center.dx - r * 0.50, center.dy + r * 0.55, center.dx - r * 0.85, center.dy + r * 0.42);
    cloud2.close();
    canvas.drawPath(cloud2, cloudPaint..color = AppColors.white.withOpacity(0.32));
  }

  /// Iluminación esférica 3D: brillo especular y sombra ambiental
  void _drawSphereLighting(Canvas canvas, Offset center, double r) {
    // 1. Sombra de borde inferior derecho (océano profundo)
    final shadowShader = RadialGradient(
      center: const Alignment(0.45, 0.45),
      radius: 0.95,
      colors: [
        Colors.transparent,
        Colors.transparent,
        AppColors.forestGreenDark.withOpacity(0.20),
        const Color(0xFF001F3F).withOpacity(0.55),
      ],
      stops: const [0.0, 0.55, 0.82, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: r));

    canvas.drawCircle(center, r, Paint()..shader = shadowShader);

    // 2. Reflejo especular superior izquierdo (luz solar suave)
    final highlightPath = Path();
    highlightPath.moveTo(center.dx - r * 0.78, center.dy - r * 0.25);
    highlightPath.quadraticBezierTo(
      center.dx - r * 0.70, center.dy - r * 0.70,
      center.dx - r * 0.25, center.dy - r * 0.78,
    );
    highlightPath.quadraticBezierTo(
      center.dx - r * 0.45, center.dy - r * 0.55,
      center.dx - r * 0.78, center.dy - r * 0.25,
    );
    highlightPath.close();

    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.white.withOpacity(0.50),
          AppColors.white.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawPath(highlightPath, highlightPaint);
  }

  /// Brote de Vida del Guardián en la parte superior del planeta
  void _drawGuardianSprout(Canvas canvas, double w, double h, Offset center, double r) {
    final sproutBase = Offset(center.dx, center.dy - r * 0.94);
    final sproutScale = w * 0.16;

    // Tallo principal
    final stem = Path();
    stem.moveTo(sproutBase.dx, sproutBase.dy);
    stem.quadraticBezierTo(sproutBase.dx, sproutBase.dy - sproutScale * 0.45, sproutBase.dx, sproutBase.dy - sproutScale * 0.85);
    canvas.drawPath(
      stem,
      Paint()
        ..color = AppColors.forestGreenDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(2.0, w * 0.02)
        ..strokeCap = StrokeCap.round,
    );

    // Hoja izquierda del brote
    final leftLeaf = Path();
    leftLeaf.moveTo(sproutBase.dx, sproutBase.dy - sproutScale * 0.50);
    leftLeaf.cubicTo(
      sproutBase.dx - sproutScale * 0.75, sproutBase.dy - sproutScale * 0.65,
      sproutBase.dx - sproutScale * 0.80, sproutBase.dy - sproutScale * 1.15,
      sproutBase.dx - sproutScale * 0.15, sproutBase.dy - sproutScale * 1.25,
    );
    leftLeaf.quadraticBezierTo(
      sproutBase.dx - sproutScale * 0.20, sproutBase.dy - sproutScale * 0.75,
      sproutBase.dx, sproutBase.dy - sproutScale * 0.50,
    );
    canvas.drawPath(
      leftLeaf,
      Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.forestGreen, AppColors.emerald, AppColors.emeraldLight],
        ).createShader(Rect.fromCircle(center: sproutBase, radius: sproutScale)),
    );

    // Hoja derecha del brote (más erguida)
    final rightLeaf = Path();
    rightLeaf.moveTo(sproutBase.dx, sproutBase.dy - sproutScale * 0.40);
    rightLeaf.cubicTo(
      sproutBase.dx + sproutScale * 0.70, sproutBase.dy - sproutScale * 0.60,
      sproutBase.dx + sproutScale * 0.85, sproutBase.dy - sproutScale * 1.10,
      sproutBase.dx + sproutScale * 0.20, sproutBase.dy - sproutScale * 1.35,
    );
    rightLeaf.quadraticBezierTo(
      sproutBase.dx + sproutScale * 0.15, sproutBase.dy - sproutScale * 0.75,
      sproutBase.dx, sproutBase.dy - sproutScale * 0.40,
    );
    canvas.drawPath(
      rightLeaf,
      Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.emerald, AppColors.emeraldLight, AppColors.pastelGreen],
        ).createShader(Rect.fromCircle(center: sproutBase, radius: sproutScale)),
    );

    // Semilla / Orbe de energía dorado en la base del brote
    canvas.drawCircle(
      Offset(sproutBase.dx, sproutBase.dy - sproutScale * 0.2),
      sproutScale * 0.22,
      Paint()..color = AppColors.goldDark,
    );
    canvas.drawCircle(
      Offset(sproutBase.dx, sproutBase.dy - sproutScale * 0.2),
      sproutScale * 0.16,
      Paint()..color = AppColors.gold,
    );
    canvas.drawCircle(
      Offset(sproutBase.dx - sproutScale * 0.05, sproutBase.dy - sproutScale * 0.25),
      sproutScale * 0.05,
      Paint()..color = AppColors.white,
    );
  }

  /// Medallón / Escudo dorado de Guardián en la unión inferior de las hojas
  void _drawGuardianMedal(Canvas canvas, Offset center, double r, double w) {
    final medalCenter = Offset(center.dx, center.dy + r * 1.02);
    final medalRadius = w * 0.088;

    // Sombra del medallón
    canvas.drawCircle(
      Offset(medalCenter.dx, medalCenter.dy + 2.5),
      medalRadius,
      Paint()..color = AppColors.forestGreenDark.withOpacity(0.35),
    );

    // Aro exterior dorado oscuro
    canvas.drawCircle(
      medalCenter,
      medalRadius,
      Paint()..color = AppColors.goldDark,
    );

    // Cuerpo interior dorado brillante con gradiente
    final goldShader = const RadialGradient(
      colors: [AppColors.goldLight, AppColors.gold, AppColors.goldDark],
      stops: [0.3, 0.75, 1.0],
    ).createShader(Rect.fromCircle(center: medalCenter, radius: medalRadius * 0.88));

    canvas.drawCircle(
      medalCenter,
      medalRadius * 0.88,
      Paint()..shader = goldShader,
    );

    // Borde interno biselado
    canvas.drawCircle(
      medalCenter,
      medalRadius * 0.75,
      Paint()
        ..color = AppColors.white.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Emblema central de la hoja de Guardián (grabado en verde bosque)
    final emblemLeaf = Path();
    emblemLeaf.moveTo(medalCenter.dx, medalCenter.dy + medalRadius * 0.45);
    emblemLeaf.quadraticBezierTo(
      medalCenter.dx - medalRadius * 0.45, medalCenter.dy,
      medalCenter.dx, medalCenter.dy - medalRadius * 0.45,
    );
    emblemLeaf.quadraticBezierTo(
      medalCenter.dx + medalRadius * 0.45, medalCenter.dy,
      medalCenter.dx, medalCenter.dy + medalRadius * 0.45,
    );
    emblemLeaf.close();
    canvas.drawPath(emblemLeaf, Paint()..color = AppColors.forestGreenDark);

    // Nervadura de la hojita en oro
    canvas.drawLine(
      Offset(medalCenter.dx, medalCenter.dy + medalRadius * 0.35),
      Offset(medalCenter.dx, medalCenter.dy - medalRadius * 0.35),
      Paint()
        ..color = AppColors.goldLight
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Destellos mágicos, estrellas de exploración y partículas de aventura
  void _drawSparkles(Canvas canvas, double w, double h) {
    // 1. Gran estrella dorada de exploración (Esquina superior derecha)
    _draw4PointStar(
      canvas,
      Offset(w * 0.88, h * 0.16),
      outerRadius: w * 0.075,
      innerRadius: w * 0.022,
      paint: Paint()..color = AppColors.gold,
    );
    canvas.drawCircle(Offset(w * 0.88, h * 0.16), w * 0.015, Paint()..color = AppColors.white);

    // 2. Estrella dorada mediana (Esquina superior izquierda)
    _draw4PointStar(
      canvas,
      Offset(w * 0.14, h * 0.20),
      outerRadius: w * 0.055,
      innerRadius: w * 0.018,
      paint: Paint()..color = AppColors.goldLight,
    );
    canvas.drawCircle(Offset(w * 0.14, h * 0.20), w * 0.012, Paint()..color = AppColors.white);

    // 3. Pequeña estrella / chispa (Flanco inferior derecho)
    _draw4PointStar(
      canvas,
      Offset(w * 0.86, h * 0.72),
      outerRadius: w * 0.040,
      innerRadius: w * 0.012,
      paint: Paint()..color = AppColors.gold,
    );

    // 4. Pequeña estrella / chispa (Flanco inferior izquierdo)
    _draw4PointStar(
      canvas,
      Offset(w * 0.12, h * 0.68),
      outerRadius: w * 0.038,
      innerRadius: w * 0.012,
      paint: Paint()..color = AppColors.goldLight,
    );

    // Partículas de luz flotantes
    canvas.drawCircle(Offset(w * 0.24, h * 0.12), w * 0.012, Paint()..color = AppColors.pastelGreen);
    canvas.drawCircle(Offset(w * 0.78, h * 0.32), w * 0.010, Paint()..color = AppColors.white.withOpacity(0.85));
    canvas.drawCircle(Offset(w * 0.80, h * 0.08), w * 0.008, Paint()..color = AppColors.goldLight);
  }

  /// Dibuja una estrella de 4 puntas con curvas estilizadas
  void _draw4PointStar(
    Canvas canvas,
    Offset center, {
    required double outerRadius,
    required double innerRadius,
    required Paint paint,
  }) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final nextAngle = angle + math.pi / 2;
      final midAngle = angle + math.pi / 4;

      final tip = Offset(
        center.dx + outerRadius * math.cos(angle - math.pi / 2),
        center.dy + outerRadius * math.sin(angle - math.pi / 2),
      );
      final corner = Offset(
        center.dx + innerRadius * math.cos(midAngle - math.pi / 2),
        center.dy + innerRadius * math.sin(midAngle - math.pi / 2),
      );
      final nextTip = Offset(
        center.dx + outerRadius * math.cos(nextAngle - math.pi / 2),
        center.dy + outerRadius * math.sin(nextAngle - math.pi / 2),
      );

      if (i == 0) {
        path.moveTo(tip.dx, tip.dy);
      }
      path.quadraticBezierTo(center.dx, center.dy, corner.dx, corner.dy);
      path.quadraticBezierTo(center.dx, center.dy, nextTip.dx, nextTip.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
