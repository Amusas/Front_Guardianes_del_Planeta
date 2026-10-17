import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/ecosystem_model.dart';

/// CustomPainter con animaciones dinámicas por ecosistema y nivel artístico premium:
/// - Animación de agua fluyendo continuamente en ríos (Bosque Andino, Selva Amazónica).
/// - Cascada con caída de agua continua y espuma viva.
/// - Páramo auténtico: colores opacos (verde musgo, gris terroso, picos escarpados sin nieve)
///   con estratos de niebla andina desplazándose en tiempo real y frailejones meciéndose.
/// - Manglar orgánico: estuario y ensenada de agua salobre con islotes de lodo, canales serpenteantes,
///   marea viva y raíces zancudas de mangle rojo auténticas (sin bloques azules planos).
/// - Océano con nado de tortuga marina, burbujas ascendentes y corales ondeantes.
/// - Bosque Seco con sol ardiente pulsante y ondas de calor.
/// - Llanos con pastizales ondulantes y estero con agua viva.
class EnhancedIsometricIslandPainter extends CustomPainter {
  final EcosystemModel ecosystem;
  final Animation<double>? animation;
  final double animationValue;

  EnhancedIsometricIslandPainter({
    required this.ecosystem,
    this.animation,
    this.animationValue = 0.0,
  }) : super(repaint: animation);

  double get anim => animation?.value ?? animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final String ecoId = ecosystem.id.toLowerCase();

    // 0. Sombra flotante elíptica difusa debajo de la isla
    final Paint shadowPaint = Paint()
      ..color = AppColors.darkText.withOpacity(0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.91), width: w * 0.80, height: 28),
      shadowPaint,
    );

    // Vértices del rombo isométrico de la superficie
    final Offset top = Offset(w * 0.5, h * 0.32);
    final Offset right = Offset(w * 0.93, h * 0.52);
    final Offset bottom = Offset(w * 0.5, h * 0.72);
    final Offset left = Offset(w * 0.07, h * 0.52);

    // 1. Capas geológicas inferiores con estratos y cortes de roca
    _drawGeologicalBase(canvas, left, right, bottom, ecoId);

    // 2. Superficie vegetal / acuática con iluminación ambiental
    _drawIslandSurface(canvas, top, right, bottom, left, w, ecoId);

    // 3. Sol ambiental diferenciado por ecosistema
    _drawSun(canvas, w, h, ecoId);

    // 4. Elementos específicos, agua realista animada y flora/fauna viva
    _drawEcosystemSpecificFeatures(canvas, w, h, top, bottom, ecoId);
  }

  void _drawGeologicalBase(Canvas canvas, Offset left, Offset right, Offset bottom, String ecoId) {
    final Color rockLeftColor = _getRockLeftColor(ecoId);
    final Color rockRightColor = _getRockRightColor(ecoId);
    final Color rockTipColor = _getRockTipColor(ecoId);

    // Cara izquierda
    final Path rockLeft = Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(bottom.dx, bottom.dy + 44)
      ..lineTo(left.dx, left.dy + 36)
      ..close();
    canvas.drawPath(rockLeft, Paint()..color = rockLeftColor);

    // Estrato o línea geológica izquierda
    final Paint strataLeft = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(left.dx, left.dy + 18),
      Offset(bottom.dx, bottom.dy + 22),
      strataLeft,
    );

    // Cara derecha
    final Path rockRight = Path()
      ..moveTo(bottom.dx, bottom.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(right.dx, right.dy + 36)
      ..lineTo(bottom.dx, bottom.dy + 44)
      ..close();
    canvas.drawPath(rockRight, Paint()..color = rockRightColor);

    // Estrato o línea geológica derecha
    final Paint strataRight = Paint()
      ..color = Colors.black.withOpacity(0.20)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(bottom.dx, bottom.dy + 22),
      Offset(right.dx, right.dy + 18),
      strataRight,
    );

    // Punta geológica inferior
    final Path rockTip = Path()
      ..moveTo(bottom.dx - 45, bottom.dy + 42)
      ..lineTo(bottom.dx, bottom.dy + 68)
      ..lineTo(bottom.dx + 45, bottom.dy + 42)
      ..close();
    canvas.drawPath(rockTip, Paint()..color = rockTipColor);
  }

  void _drawIslandSurface(Canvas canvas, Offset top, Offset right, Offset bottom, Offset left, double w, String ecoId) {
    final Path surface = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, left.dy)
      ..close();

    final Paint surfacePaint = Paint()
      ..shader = _getSurfaceGradient(ecoId).createShader(
        Rect.fromLTWH(0, top.dy, w, bottom.dy - top.dy),
      );
    canvas.drawPath(surface, surfacePaint);

    // Resplandor / Borde de luz superior (Rim light)
    final Paint rimLight = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    final Path rimPath = Path()
      ..moveTo(left.dx, left.dy)
      ..lineTo(top.dx, top.dy)
      ..lineTo(right.dx, right.dy);
    canvas.drawPath(rimPath, rimLight);
  }

  void _drawSun(Canvas canvas, double w, double h, String ecoId) {
    if (ecoId.contains('paramo')) {
      // Sol frío velado por neblina espesa
      final Offset sunPos = Offset(w * 0.74, h * 0.18);
      canvas.drawCircle(sunPos, 22, Paint()..color = const Color(0xFFD7CCC8).withOpacity(0.25));
      canvas.drawCircle(sunPos, 14, Paint()..color = const Color(0xFFEFEBE9).withOpacity(0.60));
    } else if (ecoId.contains('oceano')) {
      // Sol tropical brillante con destellos y rotación muy lenta y relajante
      final Offset sunPos = Offset(w * 0.82, h * 0.16);
      final double sunPulse = math.sin(anim * math.pi) * 1.2;
      final double sunRotation = (anim * 2 * math.pi) * 0.25; // 4 veces más lenta
      _drawRadiantSunAnimated(
        canvas,
        sunPos,
        15 + sunPulse * 0.5,
        const Color(0xFFFFD54F),
        const Color(0xFFFFECB3),
        sunRotation,
      );
    } else if (ecoId.contains('seco') || ecoId.contains('tropical')) {
      // Sol ardiente del desierto y bosque seco con rotación suave y lenta, idéntica a la del océano
      final Offset sunPos = Offset(w * 0.78, h * 0.17);
      final double sunPulse = math.sin(anim * math.pi) * 1.2;
      final double sunRotation = (anim * 2 * math.pi) * 0.25; // 4 veces más lenta
      _drawRadiantSunAnimated(
        canvas,
        sunPos,
        17 + sunPulse * 0.5,
        const Color(0xFFFFA000),
        const Color(0xFFFFE082),
        sunRotation,
      );
    } else if (ecoId.contains('llanos') || ecoId.contains('sabana')) {
      // Sol ardiente del atardecer llanero con rotación suave y lenta, idéntica a la del océano
      final Offset sunPos = Offset(w * 0.78, h * 0.17);
      final double sunPulse = math.sin(anim * math.pi) * 1.2;
      final double sunRotation = (anim * 2 * math.pi) * 0.25; // 4 veces más lenta
      _drawRadiantSunAnimated(
        canvas,
        sunPos,
        17 + sunPulse * 0.5,
        const Color(0xFFFF6D00),
        const Color(0xFFFFD54F),
        sunRotation,
      );
    } else if (ecoId.contains('manglar')) {
      // Sol costero con rotación suave y lenta, idéntica a la del océano
      final Offset sunPos = Offset(w * 0.80, h * 0.17);
      final double sunPulse = math.sin(anim * math.pi) * 1.2;
      final double sunRotation = (anim * 2 * math.pi) * 0.25; // 4 veces más lenta
      _drawRadiantSunAnimated(
        canvas,
        sunPos,
        16 + sunPulse * 0.5,
        const Color(0xFFFFB300),
        const Color(0xFFFFF8E1),
        sunRotation,
      );
    } else if (ecoId.contains('amazonia') || ecoId.contains('selva')) {
      // Sol tropical de la Selva Amazónica: misma animación suave y velocidad lenta que el océano
      final Offset sunPos = Offset(w * 0.78, h * 0.17);
      final double sunPulse = math.sin(anim * math.pi) * 1.2;
      final double sunRotation = (anim * 2 * math.pi) * 0.25; // 4 veces más lenta
      _drawRadiantSunAnimated(
        canvas,
        sunPos,
        16 + sunPulse * 0.5,
        const Color(0xFFFFC107),
        const Color(0xFFFFF3E0),
        sunRotation,
      );
    } else {
      // Bosque Andino: Sol cálido de mañana
      final Offset sunPos = Offset(w * 0.78, h * 0.17);
      _drawRadiantSun(canvas, sunPos, 17, const Color(0xFFFFC107), const Color(0xFFFFF3E0));
    }
  }

  void _drawRadiantSun(Canvas canvas, Offset center, double radius, Color coreColor, Color haloColor) {
    // Halo externo difuso
    final Paint halo = Paint()
      ..color = haloColor.withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, radius + 12, halo);

    // Rayos discretos de luz
    final Paint rayPaint = Paint()
      ..color = coreColor.withOpacity(0.40)
      ..strokeWidth = 2.0;
    for (int i = 0; i < 8; i++) {
      final double angle = i * (math.pi / 4);
      final Offset p1 = Offset(
        center.dx + math.cos(angle) * (radius + 4),
        center.dy + math.sin(angle) * (radius + 4),
      );
      final Offset p2 = Offset(
        center.dx + math.cos(angle) * (radius + 11),
        center.dy + math.sin(angle) * (radius + 11),
      );
      canvas.drawLine(p1, p2, rayPaint);
    }

    // Núcleo solar
    canvas.drawCircle(center, radius, Paint()..color = coreColor);
    canvas.drawCircle(center, radius * 0.65, Paint()..color = Colors.white.withValues(alpha: 0.60));
  }

  void _drawRadiantSunAnimated(
    Canvas canvas,
    Offset center,
    double radius,
    Color coreColor,
    Color haloColor,
    double rotation,
  ) {
    // Halo externo pulsante difuso
    final Paint halo = Paint()
      ..color = haloColor.withValues(alpha: 0.38)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, radius + 14, halo);

    // Rayos solares rotatorios y destellos tropicales
    final Paint rayPaint = Paint()
      ..color = coreColor.withValues(alpha: 0.55)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 8; i++) {
      final double angle = rotation + (i * (math.pi / 4));
      final double rayLen = (i % 2 == 0) ? 12.0 : 7.0; // Rayos alternados largos y cortos
      final Offset p1 = Offset(
        center.dx + math.cos(angle) * (radius + 4),
        center.dy + math.sin(angle) * (radius + 4),
      );
      final Offset p2 = Offset(
        center.dx + math.cos(angle) * (radius + 4 + rayLen),
        center.dy + math.sin(angle) * (radius + 4 + rayLen),
      );
      canvas.drawLine(p1, p2, rayPaint);
    }

    // Núcleo solar y brillo
    canvas.drawCircle(center, radius, Paint()..color = coreColor);
    canvas.drawCircle(center, radius * 0.65, Paint()..color = Colors.white.withValues(alpha: 0.70));
  }

  Color _getRockLeftColor(String ecoId) {
    if (ecoId.contains('oceano')) return const Color(0xFF0077B6);
    if (ecoId.contains('paramo')) return const Color(0xFF37474F); // Pizarra andina gris plomiza
    if (ecoId.contains('manglar')) return const Color(0xFF2C3E35); // Lodo arcilloso oscuro
    if (ecoId.contains('seco') || ecoId.contains('tropical')) return const Color(0xFF9E472A); // Arcilla rojiza de la Tatacoa
    if (ecoId.contains('llanos') || ecoId.contains('sabana')) return const Color(0xFF795548);
    if (ecoId.contains('amazonia') || ecoId.contains('selva')) return const Color(0xFF2E7D32);
    return const Color(0xFF6C584C);
  }

  Color _getRockRightColor(String ecoId) {
    if (ecoId.contains('oceano')) return const Color(0xFF023E8A);
    if (ecoId.contains('paramo')) return const Color(0xFF263238);
    if (ecoId.contains('manglar')) return const Color(0xFF1E2B25);
    if (ecoId.contains('seco') || ecoId.contains('tropical')) return const Color(0xFF752D16); // Sombra profunda de cañón
    if (ecoId.contains('llanos') || ecoId.contains('sabana')) return const Color(0xFF5D4037);
    if (ecoId.contains('amazonia') || ecoId.contains('selva')) return const Color(0xFF1B5E20);
    return const Color(0xFF533E2D);
  }

  Color _getRockTipColor(String ecoId) {
    if (ecoId.contains('oceano')) return const Color(0xFF03045E);
    if (ecoId.contains('paramo')) return const Color(0xFF1C2529);
    if (ecoId.contains('manglar')) return const Color(0xFF141F1A);
    if (ecoId.contains('seco') || ecoId.contains('tropical')) return const Color(0xFF4A1A0C);
    return const Color(0xFF3E2723);
  }

  LinearGradient _getSurfaceGradient(String ecoId) {
    if (ecoId.contains('oceano')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF90E0EF), // Superficie iluminada translúcida
          Color(0xFF48CAE4), // Aguas intermedias turquesa
          Color(0xFF0096C7), // Azul marino tropical
          Color(0xFF023E8A), // Profundidad abisal
        ],
        stops: [0.0, 0.35, 0.70, 1.0],
      );
    }
    if (ecoId.contains('paramo')) {
      // Colores auténticos de páramo: verde musgo opaco, verde oscuro húmedo y pajonal caqui/amarillo opaco
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF5E6D55), Color(0xFF3F4D3C), Color(0xFF283427)],
      );
    }
    if (ecoId.contains('manglar')) {
      // Estuario de agua salobre viva rodeada de mangles
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2E7D68), Color(0xFF1B5E50), Color(0xFF13453B)],
      );
    }
    if (ecoId.contains('seco') || ecoId.contains('tropical')) {
      // Suelo arcilloso y árido de La Tatacoa: terracota, ocre tostado y tierra rojiza
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE29578), // Ocre arcilloso claro iluminado
          Color(0xFFD46A43), // Terracota cálido
          Color(0xFFB54826), // Arcilla roja profunda del Cuzco
          Color(0xFF8F3417), // Sombra de cárcava
        ],
        stops: [0.0, 0.35, 0.70, 1.0],
      );
    }
    if (ecoId.contains('llanos') || ecoId.contains('sabana')) {
      // Pastizales dorados y sabana infinita de los Llanos Orientales
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFE9EDC9), // Horizonte dorado de sabana iluminada
          Color(0xFFD4E09B), // Pasto llanero tierno
          Color(0xFF9CB380), // Sabana verde media
          Color(0xFF597A48), // Pastizal húmedo de morichal
        ],
        stops: [0.0, 0.30, 0.65, 1.0],
      );
    }
    if (ecoId.contains('amazonia') || ecoId.contains('selva')) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF52B788), Color(0xFF1B4332)],
      );
    }
    // Default Bosque Andino
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF74C69D), Color(0xFF40916C)],
    );
  }

  void _drawEcosystemSpecificFeatures(Canvas canvas, double w, double h, Offset top, Offset bottom, String ecoId) {
    if (ecoId.contains('bosque_andino') || ecoId == 'bosque_01') {
      _drawBosqueAndino(canvas, w, h, top, bottom);
    } else if (ecoId.contains('paramo')) {
      _drawParamo(canvas, w, h);
    } else if (ecoId.contains('oceano')) {
      _drawOceano(canvas, w, h);
    } else if (ecoId.contains('amazonia') || ecoId.contains('selva')) {
      _drawSelvaAmazonica(canvas, w, h, top, bottom);
    } else if (ecoId.contains('manglar')) {
      _drawManglar(canvas, w, h, bottom);
    } else if (ecoId.contains('seco') || ecoId.contains('tropical')) {
      _drawBosqueSeco(canvas, w, h);
    } else if (ecoId.contains('llanos') || ecoId.contains('sabana')) {
      _drawLlanosSabana(canvas, w, h, bottom);
    } else {
      _drawBosqueAndino(canvas, w, h, top, bottom);
    }
  }

  // =========================================================================
  // 1. BOSQUE ANDINO — Río con agua viva, Cordillera de los Andes, robles, palmas y oso
  // =========================================================================
  void _drawCordilleraAndes(Canvas canvas, double w, double h) {
    // 1. Cordillera Alta de Fondo (Picos andinos majestuosos con crestas continuas)
    final Path mtnBack = Path()
      ..moveTo(w * 0.12, h * 0.46)
      ..quadraticBezierTo(w * 0.18, h * 0.35, w * 0.25, h * 0.23) // Pico occidental
      ..quadraticBezierTo(w * 0.31, h * 0.29, w * 0.36, h * 0.30) // Collado montañoso
      ..quadraticBezierTo(w * 0.42, h * 0.22, w * 0.47, h * 0.17) // Gran cumbre andina central
      ..quadraticBezierTo(w * 0.53, h * 0.24, w * 0.58, h * 0.26) // Abra de cordillera
      ..quadraticBezierTo(w * 0.63, h * 0.21, w * 0.67, h * 0.29) // Pico oriental
      ..quadraticBezierTo(w * 0.71, h * 0.38, w * 0.75, h * 0.46)
      ..close();

    final Paint mtnBackPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1E3A2F), Color(0xFF142B23)],
      ).createShader(Rect.fromLTWH(w * 0.12, h * 0.17, w * 0.63, h * 0.30));
    canvas.drawPath(mtnBack, mtnBackPaint);

    // Facetas iluminadas de la alta cordillera (sol andino matutino)
    final Path mtnBackHighlights = Path()
      ..moveTo(w * 0.25, h * 0.23)
      ..lineTo(w * 0.30, h * 0.32)
      ..lineTo(w * 0.36, h * 0.30)
      ..lineTo(w * 0.47, h * 0.17)
      ..lineTo(w * 0.53, h * 0.25)
      ..lineTo(w * 0.67, h * 0.29)
      ..lineTo(w * 0.72, h * 0.44)
      ..lineTo(w * 0.67, h * 0.45)
      ..close();
    canvas.drawPath(
      mtnBackHighlights,
      Paint()..color = const Color(0xFF2E654C).withValues(alpha: 0.55),
    );

    // Estrato rocoso sutil de alta montaña
    final Paint rockStrata = Paint()
      ..color = const Color(0xFF4E7D63).withValues(alpha: 0.40)
      ..strokeWidth = 1.6;
    canvas.drawLine(Offset(w * 0.24, h * 0.26), Offset(w * 0.28, h * 0.28), rockStrata);
    canvas.drawLine(Offset(w * 0.45, h * 0.21), Offset(w * 0.50, h * 0.23), rockStrata);

    // Niebla de altura reposando entre los valles de la cordillera
    final Paint highMist = Paint()..color = Colors.white.withValues(alpha: 0.25);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.34, h * 0.32), width: 44, height: 12),
      highMist,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.55, h * 0.28), width: 34, height: 10),
      highMist,
    );

    // 2. Cordillera Media (Laderas y estribaciones boscosas andinas)
    final Path mtnFront = Path()
      ..moveTo(w * 0.18, h * 0.48)
      ..quadraticBezierTo(w * 0.25, h * 0.37, w * 0.33, h * 0.27) // Filo de montaña
      ..quadraticBezierTo(w * 0.39, h * 0.34, w * 0.44, h * 0.33) // Valle interandino
      ..quadraticBezierTo(w * 0.49, h * 0.27, w * 0.55, h * 0.34) // Cresta boscosa
      ..quadraticBezierTo(w * 0.60, h * 0.40, w * 0.64, h * 0.48)
      ..close();

    final Paint mtnFrontPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2D6A4F), Color(0xFF1B4332)],
      ).createShader(Rect.fromLTWH(w * 0.18, h * 0.27, w * 0.46, h * 0.22));
    canvas.drawPath(mtnFront, mtnFrontPaint);

    // Sombra orográfica en la ladera occidental
    final Path ridgeShadow = Path()
      ..moveTo(w * 0.33, h * 0.27)
      ..lineTo(w * 0.38, h * 0.44)
      ..lineTo(w * 0.44, h * 0.48)
      ..lineTo(w * 0.44, h * 0.33)
      ..close();
    canvas.drawPath(
      ridgeShadow,
      Paint()..color = const Color(0xFF143627).withValues(alpha: 0.38),
    );

    // Niebla flotante baja en el bosque de niebla
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.42, h * 0.41), width: 56, height: 14),
      Paint()..color = Colors.white.withValues(alpha: 0.30),
    );
  }

  void _drawBosqueAndino(Canvas canvas, double w, double h, Offset top, Offset bottom) {
    // 1. Cordillera de los Andes con picos orgánicos, sombreado y niebla
    _drawCordilleraAndes(canvas, w, h);

    // 2. Cauce del Río de montaña
    final Path river = Path()
      ..moveTo(w * 0.48, top.dy + 12)
      ..quadraticBezierTo(w * 0.38, h * 0.52, w * 0.55, h * 0.58)
      ..quadraticBezierTo(w * 0.62, h * 0.64, bottom.dx + 9, bottom.dy)
      ..lineTo(bottom.dx - 9, bottom.dy)
      ..quadraticBezierTo(w * 0.48, h * 0.64, w * 0.33, h * 0.52)
      ..quadraticBezierTo(w * 0.44, top.dy + 12, w * 0.48, top.dy + 12)
      ..close();
    
    final Paint riverShader = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF90E0EF), Color(0xFF00B4D8), Color(0xFF0077B6)],
      ).createShader(Rect.fromLTWH(w * 0.3, top.dy, w * 0.4, h * 0.5));
    canvas.drawPath(river, riverShader);

    // ANIMACIÓN: Agua fluyendo a lo largo del cauce
    _drawFlowingWaterCurrent(canvas, [
      Offset(w * 0.44, top.dy + 16),
      Offset(w * 0.38, h * 0.46),
      Offset(w * 0.45, h * 0.54),
      Offset(w * 0.54, h * 0.60),
      Offset(bottom.dx, bottom.dy),
    ]);

    // ANIMACIÓN: Cascada cayendo continuamente
    _drawAnimatedWaterfall(canvas, bottom.dx, bottom.dy, 42);

    // 3. FLORA DEL BOSQUE ANDINO (Palmas de cera nativas, robles andinos, encenillos)
    final double palmSway = math.sin(anim * 2 * math.pi) * 2.2;
    final double oakSway = math.cos(anim * 2 * math.pi) * 1.4;

    // Palmas de cera del Quindío (altas, esbeltas, emblemáticas)
    _drawPalmTree(canvas, Offset(w * 0.75, h * 0.48), 52, palmSway);
    _drawPalmTree(canvas, Offset(w * 0.66, h * 0.44), 62, -palmSway * 0.9);
    _drawPalmTree(canvas, Offset(w * 0.59, h * 0.46), 42, palmSway * 0.8);
    _drawPalmTree(canvas, Offset(w * 0.22, h * 0.52), 40, palmSway * 0.7);
    _drawPalmTree(canvas, Offset(w * 0.15, h * 0.50), 32, -palmSway * 0.6);

    // Robles andinos y encenillos nativos con copas frondosas en capas
    _drawAndeanOak(canvas, Offset(w * 0.83, h * 0.52), 15, oakSway);
    _drawAndeanOak(canvas, Offset(w * 0.71, h * 0.53), 13, -oakSway * 0.8);
    _drawAndeanOak(canvas, Offset(w * 0.29, h * 0.49), 14, oakSway * 0.9);
    _drawAndeanOak(canvas, Offset(w * 0.19, h * 0.47), 12, -oakSway);

    // Árboles redondos menores y arbustos de bosque de niebla
    _drawRoundTree(canvas, Offset(w * 0.88, h * 0.54), 11, const Color(0xFF2D6A4F));
    _drawRoundTree(canvas, Offset(w * 0.11, h * 0.48), 10, const Color(0xFF40916C));
    _drawRoundTree(canvas, Offset(w * 0.25, h * 0.53), 9, const Color(0xFF52B788));

    // Oso de anteojos cariñoso en la ribera
    _drawOsoAnteojos(canvas, Offset(w * 0.40, h * 0.54));

    // Nubes andinas de niebla
    _drawCloud(canvas, Offset(w * 0.26, h * 0.18), 28);
    _drawCloud(canvas, Offset(w * 0.66, h * 0.16), 22);

    // Mariposas doradas volando en bucle animado
    final double bOffset = math.sin(anim * 2 * math.pi) * 4.0;
    _drawButterfly(canvas, Offset(w * 0.68 + bOffset, h * 0.38 - bOffset * 0.6));
    _drawButterfly(canvas, Offset(w * 0.73 - bOffset, h * 0.35 + bOffset * 0.4));
  }

  // =========================================================================
  // 2. PÁRAMO AUTÉNTICO — Tonos opacos, niebla en movimiento, frailejones y cóndor
  // =========================================================================
  void _drawParamo(Canvas canvas, double w, double h) {
    // 1. ZONAS DE PAJONAL ANDINO (Amarillo opaco, ocre y caqui sobre verde oscuro)
    final Paint pajonalOcre = Paint()..color = const Color(0xFF8D7B50).withOpacity(0.65);
    final Paint pajonalCaqui = Paint()..color = const Color(0xFF6E6845).withOpacity(0.55);
    final Paint musgoHumedo = Paint()..color = const Color(0xFF334030).withOpacity(0.70);

    // Manto de turberas y pajonales
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.28, h * 0.49), width: 55, height: 18), pajonalOcre);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.68, h * 0.53), width: 60, height: 22), pajonalCaqui);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.48, h * 0.62), width: 75, height: 20), musgoHumedo);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.80, h * 0.50), width: 40, height: 14), pajonalOcre);

    // Pequeños mechones de paja de páramo (Calamagrostis) meciéndose
    final double windSway = math.sin(anim * 2 * math.pi) * 1.5;
    _drawParamoGrassTuft(canvas, Offset(w * 0.22, h * 0.55), windSway);
    _drawParamoGrassTuft(canvas, Offset(w * 0.60, h * 0.62), -windSway);
    _drawParamoGrassTuft(canvas, Offset(w * 0.74, h * 0.54), windSway * 1.2);

    // 2. PICOS ESCARPADOS DE ALTA MONTAÑA (Páramo rocoso de crestas escarpadas, SIN pirámides)
    // 2. PICOS ESCARPADOS DE ALTA MONTAÑA (Integrados en la superficie de la isla, sin salirse)
    // Pico Lejano / Cresta oriental (y: 0.28 a 0.44 dentro del rombo isométrico)
    final Path ridgeFar = Path()
      ..moveTo(w * 0.50, h * 0.44)
      ..lineTo(w * 0.56, h * 0.35)
      ..lineTo(w * 0.60, h * 0.38)
      ..lineTo(w * 0.68, h * 0.28) // Cresta escarpada
      ..lineTo(w * 0.74, h * 0.36)
      ..lineTo(w * 0.80, h * 0.46)
      ..close();
    canvas.drawPath(
      ridgeFar,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C3539), Color(0xFF1E262B)],
        ).createShader(Rect.fromLTWH(w * 0.50, h * 0.28, w * 0.30, h * 0.18)),
    );

    // Pico Principal Escarpado (cumbre contenida en h * 0.24, base en h * 0.46)
    final Path peakMain = Path()
      ..moveTo(w * 0.32, h * 0.45)
      ..lineTo(w * 0.38, h * 0.36)
      ..lineTo(w * 0.42, h * 0.38)
      ..lineTo(w * 0.47, h * 0.24) // Cumbre escarpada
      ..lineTo(w * 0.51, h * 0.30)
      ..lineTo(w * 0.55, h * 0.26) // Segundo pico menor
      ..lineTo(w * 0.61, h * 0.35)
      ..lineTo(w * 0.66, h * 0.45)
      ..close();
    canvas.drawPath(
      peakMain,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF455054), Color(0xFF2A3439), Color(0xFF1F272B)],
        ).createShader(Rect.fromLTWH(w * 0.32, h * 0.24, w * 0.34, h * 0.22)),
    );

    // Caras iluminadas y estrías rocosas en el pico
    final Path peakHighlights = Path()
      ..moveTo(w * 0.47, h * 0.24)
      ..lineTo(w * 0.51, h * 0.30)
      ..lineTo(w * 0.49, h * 0.39)
      ..lineTo(w * 0.44, h * 0.45)
      ..lineTo(w * 0.42, h * 0.38)
      ..close();
    canvas.drawPath(
      peakHighlights,
      Paint()..color = const Color(0xFF5B696E).withValues(alpha: 0.55),
    );

    // Aristas oscuras de falla geológica en el macizo
    final Paint rockCrevice = Paint()
      ..color = const Color(0xFF161C1F).withValues(alpha: 0.70)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.47, h * 0.24), Offset(w * 0.43, h * 0.37), rockCrevice);
    canvas.drawLine(Offset(w * 0.55, h * 0.26), Offset(w * 0.57, h * 0.36), rockCrevice);
    canvas.drawLine(Offset(w * 0.68, h * 0.28), Offset(w * 0.72, h * 0.38), rockCrevice);

    // 3. LAGUNA GLACIAR DE ALTA MONTAÑA CON MOVIMIENTO ONDULANTE SUAVE
    final Offset lakeCenter = Offset(w * 0.36, h * 0.56);
    // Borde de turba y piedras oscuras
    final Paint shoreline = Paint()..color = const Color(0xFF384339);
    canvas.drawOval(Rect.fromCenter(center: lakeCenter, width: 50, height: 26), shoreline);

    // Agua glacial verde-azulada oscura y profunda
    final Paint lagoonWater = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF34565C), Color(0xFF1F373D), Color(0xFF132328)],
      ).createShader(Rect.fromCircle(center: lakeCenter, radius: 25));
    canvas.drawOval(Rect.fromCenter(center: lakeCenter, width: 44, height: 21), lagoonWater);

    // ANIMACIÓN: Ondulación viva de la laguna (dos anillos concéntricos suaves)
    final double wave1 = (anim * 16.0) % 16.0;
    final double wave1Alpha = (1.0 - (wave1 / 16.0)).clamp(0.0, 0.65);
    canvas.drawOval(
      Rect.fromCenter(center: lakeCenter, width: 8.0 + wave1 * 2.2, height: 4.0 + wave1 * 1.0),
      Paint()
        ..color = const Color(0xFF8EE3EF).withValues(alpha: wave1Alpha * 0.50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final double wave2 = ((anim + 0.5) % 1.0) * 16.0;
    final double wave2Alpha = (1.0 - (wave2 / 16.0)).clamp(0.0, 0.65);
    canvas.drawOval(
      Rect.fromCenter(center: lakeCenter, width: 8.0 + wave2 * 2.2, height: 4.0 + wave2 * 1.0),
      Paint()
        ..color = Colors.white.withValues(alpha: wave2Alpha * 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Reflejo gélido sutil en la superficie de la laguna
    final double shimmer = math.sin(anim * 4 * math.pi) * 1.5;
    canvas.drawLine(
      Offset(lakeCenter.dx - 10 + shimmer, lakeCenter.dy - 3),
      Offset(lakeCenter.dx + 4 + shimmer, lakeCenter.dy - 3),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..strokeWidth = 1.3
        ..strokeCap = StrokeCap.round,
    );

    // 4. BOSQUE DE FRAILEJONES (Espeletia) MEJORADOS Y DISTRIBUIDOS
    final double frailejonSway = math.sin(anim * 2 * math.pi) * 2.8;
    // Fondo / medianos
    _drawEnhancedFrailejon(canvas, Offset(w * 0.20, h * 0.48), 18, frailejonSway * 0.8);
    _drawEnhancedFrailejon(canvas, Offset(w * 0.62, h * 0.47), 16, -frailejonSway * 0.7);
    _drawEnhancedFrailejon(canvas, Offset(w * 0.76, h * 0.48), 20, frailejonSway * 0.9);
    // Primer plano / robustos
    _drawEnhancedFrailejon(canvas, Offset(w * 0.16, h * 0.56), 24, frailejonSway);
    _drawEnhancedFrailejon(canvas, Offset(w * 0.54, h * 0.58), 26, -frailejonSway * 1.1);
    _drawEnhancedFrailejon(canvas, Offset(w * 0.68, h * 0.54), 22, frailejonSway * 1.2);
    _drawEnhancedFrailejon(canvas, Offset(w * 0.82, h * 0.58), 20, -frailejonSway * 0.9);

    // 5. CÓNDOR ANDINO EN VUELO RASANTE ENTRE LA NIEBLA
    final double condorGlide = math.sin(anim * 2 * math.pi) * 3.5;
    _drawCondor(canvas, Offset(w * 0.64, h * 0.22 + condorGlide));

    // 6. ANIMACIÓN: NIEBLA DENSA Y CONTINUA (LOOP PERFECTO SIN CORTES)
    _drawAnimatedParamoFog(canvas, w, h);
  }

  void _drawParamoGrassTuft(Canvas canvas, Offset pos, double sway) {
    final Paint strawPaint = Paint()
      ..color = const Color(0xFF9E8D5E).withValues(alpha: 0.85)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(pos, Offset(pos.dx - 4 + sway, pos.dy - 7), strawPaint);
    canvas.drawLine(pos, Offset(pos.dx - 1 + sway * 1.2, pos.dy - 9), strawPaint);
    canvas.drawLine(pos, Offset(pos.dx + 2 + sway * 0.8, pos.dy - 8), strawPaint);
    canvas.drawLine(pos, Offset(pos.dx + 5 + sway * 1.1, pos.dy - 6), strawPaint);
  }

  void _drawAnimatedParamoFog(Canvas canvas, double w, double h) {
    // Oscilación sinusoidal continua y suave: vaivén orgánico de 0.0 a 1.0 sin salto al terminar el ciclo
    final double smoothT = (math.sin(anim * 2 * math.pi) + 1.0) / 2.0;

    // Capa 1: Niebla baja densa sobre la laguna y pajonales
    final double fog1X = w * 0.12 + (smoothT * w * 0.36);
    final double fog1Opacity = 0.40 + (math.sin(anim * 2 * math.pi).abs() * 0.22);
    _drawDenseFogBank(canvas, Offset(fog1X, h * 0.61), 85, 20, fog1Opacity);
    _drawDenseFogBank(canvas, Offset(w - fog1X, h * 0.57), 90, 22, fog1Opacity * 0.9);

    // Capa 2: Niebla intermedia entre los frailejones (desfasada pi/2)
    final double smoothT2 = (math.cos(anim * 2 * math.pi) + 1.0) / 2.0;
    final double fog2X = w * 0.20 + (smoothT2 * w * 0.40);
    final double fog2Opacity = 0.45 + (math.cos(anim * 2 * math.pi).abs() * 0.20);
    _drawDenseFogBank(canvas, Offset(fog2X, h * 0.50), 100, 24, fog2Opacity);
    _drawDenseFogBank(canvas, Offset(w * 0.75 - (smoothT2 * w * 0.30), h * 0.46), 85, 20, fog2Opacity * 0.85);

    // Capa 3: Niebla alta envolviendo suavemente las cumbres
    final double smoothT3 = (math.sin((anim + 0.25) * 2 * math.pi) + 1.0) / 2.0;
    final double fog3X = w * 0.30 + (smoothT3 * w * 0.32);
    final double fog3Opacity = 0.45 + (smoothT3 * 0.25);
    _drawDenseFogBank(canvas, Offset(fog3X, h * 0.34), 110, 26, fog3Opacity);
  }

  void _drawDenseFogBank(Canvas canvas, Offset pos, double width, double height, double opacity) {
    // Núcleo denso
    final Paint coreFog = Paint()
      ..color = const Color(0xFFECEFF1).withValues(alpha: opacity * 0.70)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawOval(
      Rect.fromCenter(center: pos, width: width * 0.75, height: height * 0.65),
      coreFog,
    );

    // Manto exterior difuso
    final Paint softFog = Paint()
      ..color = const Color(0xFFCFD8DC).withValues(alpha: opacity * 0.40)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
    canvas.drawOval(
      Rect.fromCenter(center: pos, width: width, height: height),
      softFog,
    );
  }

  // =========================================================================
  // 3. OCÉANO — Arrecife de corales, aguas profundas, tortuga remando y burbujas
  // =========================================================================
  void _drawOceano(Canvas canvas, double w, double h) {
    // 1. FONDO MARINO Y BANCO DE ARENA SUBMARINO
    final Paint deepSand = Paint()..color = const Color(0xFFD4A373).withValues(alpha: 0.35);
    final Paint reefSand = Paint()..color = const Color(0xFFFFE082).withValues(alpha: 0.50);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.50, h * 0.63), width: 85, height: 26), deepSand);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.48, h * 0.61), width: 70, height: 20), reefSand);

    // 2. TEXTURA DE AGUA Y CÁUSTICAS SOLARES EN EL FONDO (Red de luz refractada viva)
    _drawOceanCaustics(canvas, w, h);

    // 3. ARRECIFE DE CORAL Y BOSQUE DE ALGAS VIBRANTES
    final double algaeSway = math.sin(anim * 2 * math.pi) * 3.5;
    // Corales cuerno de alce y cerebro
    _drawCoralBranch(canvas, Offset(w * 0.22, h * 0.53), const Color(0xFFE76F51), algaeSway);
    _drawCoralBranch(canvas, Offset(w * 0.78, h * 0.54), const Color(0xFFF4A261), -algaeSway);
    _drawCoralBrain(canvas, Offset(w * 0.66, h * 0.49), const Color(0xFFFFB703));
    _drawCoralBrain(canvas, Offset(w * 0.32, h * 0.48), const Color(0xFFFF8A65));
    // Algas marinas ondeantes
    _drawAlgae(canvas, Offset(w * 0.16, h * 0.50), algaeSway);
    _drawAlgae(canvas, Offset(w * 0.84, h * 0.51), -algaeSway * 1.1);
    _drawAlgae(canvas, Offset(w * 0.26, h * 0.47), algaeSway * 0.8);

    // 4. CARDUMEN DE PECES TROPICALES NADANDO EN FORMACIÓN
    _drawOceanFishSchool(canvas, w, h);

    // 5. TORTUGA MARINA (Chelonia mydas) CON NADO BIOLÓGICAMENTE NATURAL
    // Desplazamiento ondulante suave a través del agua mientras rema
    final double turtleGlideX = math.cos(anim * 2 * math.pi) * 6.0;
    final double turtleGlideY = math.sin(anim * 2 * math.pi) * 3.5;
    _drawRealisticSeaTurtle(canvas, Offset(w * 0.48 + turtleGlideX, h * 0.51 + turtleGlideY));

    // 6. ANIMACIÓN: BURBUJAS ASCENDENTES CON OSCILACIÓN LATERAL
    _drawAnimatedBubbles(canvas, w, h);

    // 7. OLEAJE REALISTA EN LA SUPERFICIE DEL AGUA (Crestas de espuma y ondas de viento)
    _drawOceanSurfaceWaves(canvas, w, h);
  }

  void _drawOceanCaustics(Canvas canvas, double w, double h) {
    // Red de cáusticas animadas (patrón de luz solar refractada en el fondo marino)
    final double waveShift = anim * 2 * math.pi;
    final Paint causticPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18 + math.sin(waveShift).abs() * 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    final Path caustics = Path();
    // Malla orgánica de cáusticas
    for (int i = 0; i < 4; i++) {
      final double y = h * 0.44 + (i * 12.0);
      final double xOffset = math.sin(waveShift + (i * 1.2)) * 6.0;
      caustics.moveTo(w * 0.25 + xOffset, y);
      caustics.quadraticBezierTo(
        w * 0.38 - xOffset,
        y - 5.0 + math.cos(waveShift + i) * 3.0,
        w * 0.52 + xOffset,
        y + 1.0,
      );
      caustics.quadraticBezierTo(
        w * 0.65 - xOffset,
        y + 6.0 - math.cos(waveShift + i) * 3.0,
        w * 0.76 + xOffset,
        y - 2.0,
      );
    }
    canvas.drawPath(caustics, causticPaint);
  }

  void _drawOceanSurfaceWaves(Canvas canvas, double w, double h) {
    // Ondas superficiales concéntricas y líneas de oleaje marino en el rombo
    final double t = anim * 2 * math.pi;

    // Tres frentes de olas principales que recorren la superficie marina
    final Paint waveCrestPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final Paint waveFoamPaint = Paint()
      ..color = const Color(0xFFE0F7FA).withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final double phase = (anim + (i * 0.33)) % 1.0;
      final double waveY = h * 0.38 + (phase * (h * 0.28));
      final double waveW = 40.0 + (phase * 55.0);
      final double waveAlpha = math.sin(phase * math.pi).clamp(0.0, 1.0);

      final double waveX = w * 0.50 + math.sin(t + i) * 14.0;
      final Path crest = Path()
        ..moveTo(waveX - waveW * 0.5, waveY)
        ..quadraticBezierTo(waveX - waveW * 0.2, waveY - 4.5, waveX, waveY - 1.0)
        ..quadraticBezierTo(waveX + waveW * 0.2, waveY + 3.0, waveX + waveW * 0.5, waveY);

      canvas.drawPath(
        crest,
        waveFoamPaint..color = const Color(0xFFB2EBF2).withValues(alpha: waveAlpha * 0.35),
      );
      canvas.drawPath(
        crest,
        waveCrestPaint..color = Colors.white.withValues(alpha: waveAlpha * 0.55),
      );
    }
  }

  void _drawOceanFishSchool(Canvas canvas, double w, double h) {
    // Cardumen centrado en aguas abiertas intermedias, contenido dentro del rombo
    final double schoolWave = math.sin(anim * 2 * math.pi);
    final double fish1X = w * 0.40 + schoolWave * 4.0;
    final double fish1Y = h * 0.45 + schoolWave * 2.0;

    _drawDetailedFish(canvas, Offset(fish1X, fish1Y), const Color(0xFFFFB703), 0.90);
    _drawDetailedFish(canvas, Offset(fish1X + 11, fish1Y - 4), const Color(0xFFFFD166), 0.80);
    _drawDetailedFish(canvas, Offset(fish1X + 7, fish1Y + 5), const Color(0xFFE76F51), 0.70);
    _drawDetailedFish(canvas, Offset(fish1X - 9, fish1Y + 2), const Color(0xFFFFB703), 0.65);
  }

  void _drawDetailedFish(Canvas canvas, Offset pos, Color color, double scale) {
    final Paint body = Paint()..color = color;
    // Cuerpo ovalado de pez tropical
    canvas.drawOval(
      Rect.fromCenter(center: pos, width: 11 * scale, height: 6 * scale),
      body,
    );
    // Cola en abanico
    final Path tail = Path()
      ..moveTo(pos.dx - 5 * scale, pos.dy)
      ..lineTo(pos.dx - 9 * scale, pos.dy - 3.5 * scale)
      ..lineTo(pos.dx - 8 * scale, pos.dy)
      ..lineTo(pos.dx - 9 * scale, pos.dy + 3.5 * scale)
      ..close();
    canvas.drawPath(tail, body);
    // Ojo diminuto
    canvas.drawCircle(Offset(pos.dx + 3.5 * scale, pos.dy - 1.2 * scale), 0.9 * scale, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(pos.dx + 3.8 * scale, pos.dy - 1.2 * scale), 0.5 * scale, Paint()..color = Colors.black);
  }

  void _drawAnimatedBubbles(Canvas canvas, double w, double h) {
    // Burbujas ascendentes con balanceo lateral sinusoidal
    final double t = anim * 2 * math.pi;
    for (int i = 0; i < 4; i++) {
      final double progress = (anim + (i * 0.25)) % 1.0;
      final double bY = h * 0.65 - (progress * (h * 0.26));
      final double bX = w * (0.42 + (i * 0.08)) + math.sin(t + i * 1.5) * 4.0;
      final double bSize = 2.5 + (i % 3) * 1.5;
      final double opacity = (1.0 - progress).clamp(0.2, 0.85);

      _drawTranslucentBubble(canvas, Offset(bX, bY), bSize, opacity);
    }
  }

  void _drawTranslucentBubble(Canvas canvas, Offset pos, double size, double opacity) {
    final Paint bubblePaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity * 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(pos, size, bubblePaint);

    final Paint fill = Paint()
      ..color = const Color(0xFFE0F7FA).withValues(alpha: opacity * 0.20)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, size, fill);

    // Destello de luz en la burbuja
    canvas.drawCircle(
      Offset(pos.dx - size * 0.35, pos.dy - size * 0.35),
      size * 0.30,
      Paint()..color = Colors.white.withValues(alpha: opacity * 0.75),
    );
  }

  // =========================================================================
  // 4. SELVA AMAZÓNICA — Selva virgen hiperdensa, río de aguas vivas, ceibas colosales y fauna
  // =========================================================================
  void _drawSelvaAmazonica(Canvas canvas, double w, double h, Offset top, Offset bottom) {
    final double windSway = math.sin(anim * 2 * math.pi) * 1.5;
    final double treeSway1 = math.sin(anim * 2 * math.pi) * 1.6;
    final double treeSway2 = math.cos(anim * 2 * math.pi) * 1.4;

    // 1. TEXTURA DE SUELO Y SOTOBOSQUE TROPICAL HÚMEDO (Capas de humus, pasto denso y musgos)
    final Paint humusBase = Paint()..color = const Color(0xFF0F2E1E).withValues(alpha: 0.70);
    final Paint mossLayer = Paint()..color = const Color(0xFF1E4D34).withValues(alpha: 0.60);
    final Paint grassLush = Paint()..color = const Color(0xFF2D6A4F).withValues(alpha: 0.50);

    // Manto basal orgánico sobre la superficie
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.32, h * 0.46), width: 75, height: 26), humusBase);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.68, h * 0.48), width: 80, height: 28), mossLayer);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.48, h * 0.58), width: 95, height: 32), grassLush);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.25, h * 0.56), width: 60, height: 22), humusBase);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.76, h * 0.56), width: 65, height: 24), mossLayer);

    // Mechones de pasto tropical y hojarasca silvestre distribuidos por la isla
    final List<Offset> grassTuftPositions = [
      Offset(w * 0.20, h * 0.49),
      Offset(w * 0.28, h * 0.54),
      Offset(w * 0.36, h * 0.62),
      Offset(w * 0.58, h * 0.64),
      Offset(w * 0.68, h * 0.58),
      Offset(w * 0.74, h * 0.50),
      Offset(w * 0.84, h * 0.54),
    ];
    for (final pos in grassTuftPositions) {
      _drawJungleGrassTuft(canvas, pos, windSway);
    }

    // Helechos tropicales arqueados en las riberas y sotobosque
    for (double px = w * 0.18; px < w * 0.84; px += 28) {
      _drawJungleFern(canvas, Offset(px, h * 0.56 + math.sin(px * 1.5) * 8), windSway);
    }

    // Plantas de hojas anchas (platanillos / heliconias) en el sotobosque
    _drawBroadleafPlant(canvas, Offset(w * 0.34, h * 0.53), windSway);
    _drawBroadleafPlant(canvas, Offset(w * 0.62, h * 0.54), -windSway);
    _drawBroadleafPlant(canvas, Offset(w * 0.78, h * 0.60), windSway * 0.8);

    // 2. GRAN RÍO AMAZONAS / RÍO DE AGUAS TROPICALES FLUIDAS
    // El río nace de un remanso / laguna fluvial en el interior de la selva (y: h * 0.41, 100% dentro)
    // y serpentea orgánicamente hacia el vértice frontal inferior (bottom.dx, bottom.dy).
    final Offset springOrigin = Offset(w * 0.44, h * 0.41);

    // Laguna / Nacimiento interior del río (remanso de agua cristalina entre las ceibas)
    final Paint lagoonShore = Paint()..color = const Color(0xFF6B4F35).withValues(alpha: 0.55);
    canvas.drawOval(Rect.fromCenter(center: springOrigin, width: 22, height: 11), lagoonShore);

    final Paint lagoonWater = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF48CAE4), Color(0xFF1E8C94), Color(0xFF0E4D54)],
      ).createShader(Rect.fromCircle(center: springOrigin, radius: 11));
    canvas.drawOval(Rect.fromCenter(center: springOrigin, width: 18, height: 9), lagoonWater);

    // Ondas concéntricas de agua en el remanso de origen
    final double rippleR = 3.0 + (anim * 5.0);
    final Paint ripplePaint = Paint()
      ..color = Colors.white.withValues(alpha: (1.0 - anim).clamp(0.1, 0.5))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawOval(Rect.fromCenter(center: springOrigin, width: rippleR * 2, height: rippleR), ripplePaint);

    // Cauce del río amazónico: nace en el remanso y fluye al frente
    final Path amazonRiver = Path()
      ..moveTo(springOrigin.dx + 7, springOrigin.dy + 3)
      ..quadraticBezierTo(w * 0.56, h * 0.48, w * 0.50, h * 0.56)
      ..quadraticBezierTo(w * 0.42, h * 0.64, bottom.dx + 8, bottom.dy)
      ..lineTo(bottom.dx - 8, bottom.dy)
      ..quadraticBezierTo(w * 0.32, h * 0.64, w * 0.40, h * 0.56)
      ..quadraticBezierTo(w * 0.46, h * 0.48, springOrigin.dx - 7, springOrigin.dy + 3)
      ..close();

    // Orilla de arena fina / ribera fluvial húmeda
    final Paint riverBank = Paint()
      ..color = const Color(0xFF8D6E63).withValues(alpha: 0.50)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(amazonRiver, riverBank);

    // Shader de agua fluvial viva: tonos turquesa, esmeralda y destellos de cielo
    final Paint riverWater = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF48CAE4), // Superficie con destellos cristalinos
          Color(0xFF2EC4B6), // Agua viva tropical translúcida
          Color(0xFF1E8C94), // Verde esmeralda fluvial amazónico
          Color(0xFF146B75), // Profundidad fluvial
          Color(0xFF0E4D54), // Lecho profundo
        ],
        stops: [0.0, 0.25, 0.55, 0.80, 1.0],
      ).createShader(Rect.fromLTWH(w * 0.25, springOrigin.dy, w * 0.5, bottom.dy - springOrigin.dy));
    canvas.drawPath(amazonRiver, riverWater);

    // Reflejo solar especular ondulante en la superficie del agua
    final Paint waterGleam = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    final Path gleamLine = Path()
      ..moveTo(springOrigin.dx + 2, springOrigin.dy + 4)
      ..quadraticBezierTo(w * 0.52, h * 0.49, w * 0.47, h * 0.57);
    canvas.drawPath(gleamLine, waterGleam);

    // ANIMACIÓN: Corrientes de agua que fluyen activamente hacia abajo
    _drawFlowingWaterCurrent(canvas, [
      Offset(springOrigin.dx, springOrigin.dy + 2),
      Offset(w * 0.50, h * 0.48),
      Offset(w * 0.45, h * 0.56),
      Offset(w * 0.38, h * 0.63),
      Offset(bottom.dx, bottom.dy),
    ]);

    // ANIMACIÓN: Cascada tropical que cae por el vértice inferior de la isla
    _drawAnimatedWaterfall(canvas, bottom.dx, bottom.dy, 38);

    // 3. SELVA SÚPER DENSA Y COMPACTA (Multicapa sin huecos vacíos con movimiento leve de brisa)

    // CAPA 1 (FONDO): Horizonte cerrado de dosel continuo y palmeras altas
    _drawJungleCanopyTree(canvas, Offset(w * 0.18, h * 0.38), 15, const Color(0xFF0B2117), treeSway1 * 0.4);
    _drawJungleCanopyTree(canvas, Offset(w * 0.27, h * 0.35), 16, const Color(0xFF0F2B1D), -treeSway2 * 0.4);
    _drawJungleCanopyTree(canvas, Offset(w * 0.37, h * 0.33), 17, const Color(0xFF143628), treeSway1 * 0.5);
    _drawJungleCanopyTree(canvas, Offset(w * 0.48, h * 0.33), 16, const Color(0xFF0F2B1D), -treeSway1 * 0.5);
    _drawJungleCanopyTree(canvas, Offset(w * 0.58, h * 0.34), 17, const Color(0xFF143628), treeSway2 * 0.5);
    _drawJungleCanopyTree(canvas, Offset(w * 0.68, h * 0.35), 16, const Color(0xFF0F2B1D), -treeSway2 * 0.4);
    _drawJungleCanopyTree(canvas, Offset(w * 0.78, h * 0.38), 15, const Color(0xFF0B2117), treeSway1 * 0.4);

    // Palmas altas emergentes en el fondo
    _drawJunglePalm(canvas, Offset(w * 0.14, h * 0.40), 22, treeSway1 * 0.6);
    _drawJunglePalm(canvas, Offset(w * 0.33, h * 0.33), 20, -treeSway2 * 0.6);
    _drawJunglePalm(canvas, Offset(w * 0.64, h * 0.33), 21, treeSway1 * 0.6);
    _drawJunglePalm(canvas, Offset(w * 0.83, h * 0.40), 22, -treeSway2 * 0.6);

    // CAPA 2 (MEDIA): Ceibas colosales emergentes con raíces tabulares y copas gigantescas
    _drawAmazonCeibaAnimated(canvas, Offset(w * 0.76, h * 0.46), 28, treeSway1);
    _drawAmazonCeibaAnimated(canvas, Offset(w * 0.22, h * 0.46), 26, -treeSway1 * 0.8);

    // Árboles de dosel intermedio rellenando ambos lados del río
    _drawJungleCanopyTree(canvas, Offset(w * 0.34, h * 0.43), 18, const Color(0xFF1B4332), treeSway2 * 0.6);
    _drawJungleCanopyTree(canvas, Offset(w * 0.62, h * 0.42), 19, const Color(0xFF1B4332), -treeSway1 * 0.6);
    _drawJungleCanopyTree(canvas, Offset(w * 0.70, h * 0.49), 18, const Color(0xFF235841), treeSway1 * 0.6);
    _drawJungleCanopyTree(canvas, Offset(w * 0.30, h * 0.50), 17, const Color(0xFF1E4D38), -treeSway2 * 0.6);

    // CAPA 3 (DELANTERA): Palmeras de Asaí/Chonta y arbustos riparios densos
    _drawJunglePalm(canvas, Offset(w * 0.16, h * 0.53), 22, treeSway1 * 0.75);
    _drawJunglePalm(canvas, Offset(w * 0.26, h * 0.56), 20, -treeSway2 * 0.75);
    _drawJunglePalm(canvas, Offset(w * 0.68, h * 0.56), 21, treeSway1 * 0.75);
    _drawJunglePalm(canvas, Offset(w * 0.82, h * 0.54), 22, -treeSway1 * 0.75);

    _drawJungleCanopyTree(canvas, Offset(w * 0.10, h * 0.51), 19, const Color(0xFF2D6A4F), treeSway2 * 0.7);
    _drawJungleCanopyTree(canvas, Offset(w * 0.88, h * 0.52), 20, const Color(0xFF2D6A4F), -treeSway1 * 0.7);
    _drawJungleCanopyTree(canvas, Offset(w * 0.60, h * 0.63), 16, const Color(0xFF2D6A4F), treeSway2 * 0.6);
    _drawJungleCanopyTree(canvas, Offset(w * 0.26, h * 0.61), 15, const Color(0xFF235841), -treeSway1 * 0.6);

    // Lianas colgantes de las ramas de la ceiba con balanceo suave
    final Paint vine = Paint()
      ..color = const Color(0xFF388E3C)
      ..strokeWidth = 1.3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.73, h * 0.38), Offset(w * 0.72 + treeSway1, h * 0.46), vine);
    canvas.drawLine(Offset(w * 0.79, h * 0.39), Offset(w * 0.80 - treeSway2, h * 0.45), vine);
    canvas.drawLine(Offset(w * 0.20, h * 0.39), Offset(w * 0.21 + treeSway2, h * 0.47), vine);

    // Pequeñas orquídeas/flores en las lianas
    canvas.drawCircle(Offset(w * 0.72 + treeSway1, h * 0.44), 1.8, Paint()..color = const Color(0xFFFF4081));
    canvas.drawCircle(Offset(w * 0.21 + treeSway2, h * 0.45), 1.6, Paint()..color = const Color(0xFFFFD54F));

    // 4. FAUNA EMBLEMÁTICA: DANTA AMAZÓNICA (Tapirus terrestris) EN LA ORILLA
    final double tapirBob = math.sin(anim * 2 * math.pi) * 0.8;
    _drawRealisticTapir(canvas, Offset(w * 0.39, h * 0.60 + tapirBob));

    // Guacamaya roja (Ara macao) posada en una rama alta de la Ceiba derecha
    _drawPerchedMacaw(canvas, Offset(w * 0.82 + treeSway1 * 0.5, h * 0.42));

    // 5. MARIPOSA MORPHO AZUL (Morpho peleides) VOLANDO SOBRE EL DOSEL
    final double bOffset = math.sin(anim * 4 * math.pi) * 3.5;
    _drawMorphoButterflyAnimated(canvas, Offset(w * 0.63 - bOffset, h * 0.41 + bOffset * 0.5));
  }

  void _drawJungleGrassTuft(Canvas canvas, Offset pos, double sway) {
    final Paint grassPaint = Paint()
      ..color = const Color(0xFF40916C).withValues(alpha: 0.80)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(pos, Offset(pos.dx - 3 + sway, pos.dy - 6), grassPaint);
    canvas.drawLine(pos, Offset(pos.dx + sway * 0.5, pos.dy - 8), grassPaint);
    canvas.drawLine(pos, Offset(pos.dx + 3 + sway, pos.dy - 6), grassPaint);
  }

  void _drawBroadleafPlant(Canvas canvas, Offset pos, double sway) {
    // Hojas grandes de platanillo / heliconia
    final Paint leaf = Paint()..color = const Color(0xFF2D6A4F);
    final Paint leafLight = Paint()..color = const Color(0xFF52B788);

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(sway * 0.08);

    // Tallo
    canvas.drawLine(Offset.zero, const Offset(0, -6), Paint()..color = const Color(0xFF1B4332)..strokeWidth = 1.4);
    // Hoja izquierda
    canvas.drawOval(const Rect.fromLTWH(-7, -12, 6, 10), leaf);
    // Hoja derecha
    canvas.drawOval(const Rect.fromLTWH(1, -14, 7, 11), leafLight);
    // Hoja central
    canvas.drawOval(const Rect.fromLTWH(-3, -16, 6, 12), leaf);

    canvas.restore();
  }

  void _drawPerchedMacaw(Canvas canvas, Offset pos) {
    // Cuerpo rojo brillante
    canvas.drawOval(Rect.fromCenter(center: pos, width: 4.5, height: 9), Paint()..color = const Color(0xFFE53935));
    // Ala azul y amarilla
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 1.5, pos.dy + 1), width: 2.8, height: 7), Paint()..color = const Color(0xFF1E88E5));
    canvas.drawCircle(Offset(pos.dx + 1.2, pos.dy), 1.2, Paint()..color = const Color(0xFFFFEB3B));
    // Cabeza
    canvas.drawCircle(Offset(pos.dx, pos.dy - 5.5), 2.2, Paint()..color = const Color(0xFFE53935));
    // Pico curvado
    canvas.drawCircle(Offset(pos.dx - 2.0, pos.dy - 5.0), 1.0, Paint()..color = const Color(0xFFFFF9C4));
    // Cola larga roja
    canvas.drawLine(Offset(pos.dx, pos.dy + 4), Offset(pos.dx + 1, pos.dy + 11), Paint()..color = const Color(0xFFD32F2F)..strokeWidth = 1.2);
  }

  void _drawJungleFern(Canvas canvas, Offset pos, double sway) {
    final Paint fernPaint = Paint()
      ..color = const Color(0xFF388E3C).withValues(alpha: 0.75)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(pos, Offset(pos.dx - 4 + sway, pos.dy - 7), fernPaint);
    canvas.drawLine(pos, Offset(pos.dx + sway * 0.5, pos.dy - 9), fernPaint);
    canvas.drawLine(pos, Offset(pos.dx + 4 + sway, pos.dy - 7), fernPaint);
  }

  // =========================================================================
  // 5. MANGLAR ORGÁNICO — Estuario con marea viva, canales sinuosos y raíces zancudas
  // =========================================================================
  void _drawManglar(Canvas canvas, double w, double h, Offset bottom) {
    final double mangroveSway = math.sin(anim * 2 * math.pi) * 1.5;

    // 1. Ensenada de agua marina estuarina (fondo transparente con marea)
    final Path waterBody = Path()
      ..moveTo(w * 0.20, h * 0.42)
      ..quadraticBezierTo(w * 0.50, h * 0.38, w * 0.80, h * 0.42)
      ..quadraticBezierTo(w * 0.90, h * 0.54, bottom.dx + 25, bottom.dy)
      ..lineTo(bottom.dx - 25, bottom.dy)
      ..quadraticBezierTo(w * 0.10, h * 0.54, w * 0.20, h * 0.42)
      ..close();

    final Paint waterShader = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF80CBC4), Color(0xFF26A69A), Color(0xFF00796B), Color(0xFF004D40)],
      ).createShader(Rect.fromLTWH(w * 0.1, h * 0.38, w * 0.8, h * 0.35));
    canvas.drawPath(waterBody, waterShader);

    // Reflejos y cáusticas sutiles de agua estuarina
    _drawEstuaryShimmer(canvas, w, h);

    // 2. Islotes curvos de lodo fértil intermareal y sedimentos
    final Paint mudPaint = Paint()..color = const Color(0xFF3E3B32);
    final Paint sandRim = Paint()..color = const Color(0xFFD7CCC8).withValues(alpha: 0.55);

    // Banco de lodo izquierdo
    final Path bankLeft = Path()
      ..moveTo(w * 0.15, h * 0.48)
      ..quadraticBezierTo(w * 0.30, h * 0.44, w * 0.38, h * 0.52)
      ..quadraticBezierTo(w * 0.28, h * 0.60, w * 0.15, h * 0.48)
      ..close();
    canvas.drawPath(bankLeft, mudPaint);
    canvas.drawPath(bankLeft, sandRim..style = PaintingStyle.stroke..strokeWidth = 2.0);

    // Neumatóforos (raíces respiratorias) en el banco izquierdo
    _drawPneumatophores(canvas, Offset(w * 0.18, h * 0.50), 4);

    // Banco de lodo derecho
    final Path bankRight = Path()
      ..moveTo(w * 0.62, h * 0.50)
      ..quadraticBezierTo(w * 0.76, h * 0.46, w * 0.85, h * 0.52)
      ..quadraticBezierTo(w * 0.74, h * 0.62, w * 0.62, h * 0.50)
      ..close();
    canvas.drawPath(bankRight, mudPaint);
    canvas.drawPath(bankRight, sandRim..style = PaintingStyle.stroke..strokeWidth = 2.0);

    // Neumatóforos en el banco derecho
    _drawPneumatophores(canvas, Offset(w * 0.68, h * 0.52), 5);

    // ANIMACIÓN: Marea viva — ondas y espuma marina entrando por los canales
    _drawMangroveTideWaves(canvas, w, h);

    // Cardumen de alevines de manglar nadando en el canal central
    final double fishSwim = math.sin(anim * 2 * math.pi) * 4.0;
    _drawMangroveFish(canvas, Offset(w * 0.44 + fishSwim, h * 0.53 + fishSwim * 0.25), 0.85);
    _drawMangroveFish(canvas, Offset(w * 0.51 + fishSwim, h * 0.50 - fishSwim * 0.2), 0.75);
    _drawMangroveFish(canvas, Offset(w * 0.47 + fishSwim, h * 0.56 + fishSwim * 0.2), 0.70);

    // 3. Mangles rojos con raíces zancudas arqueadas auténticas
    // Mangle de fondo (más pequeño)
    _drawRealMangroveTree(canvas, Offset(w * 0.50, h * 0.43), mangroveSway * 0.6, 0.75);
    // Mangles principales
    _drawRealMangroveTree(canvas, Offset(w * 0.28, h * 0.50), mangroveSway);
    _drawRealMangroveTree(canvas, Offset(w * 0.72, h * 0.52), -mangroveSway * 0.8);
    _drawRealMangroveTree(canvas, Offset(w * 0.82, h * 0.46), mangroveSway * 0.7, 0.85);
    // Mangle en el flanco izquierdo
    _drawRealMangroveTree(canvas, Offset(w * 0.16, h * 0.53), -mangroveSway * 0.6, 0.80);

    // ANIMACIÓN: Cangrejo azul en el centro moviendo sus tenazas
    _drawCrabAnimated(canvas, Offset(w * 0.48, h * 0.58));

    // ANIMACIÓN: Cangrejito violinista en el banco derecho agitando su tenaza mayor
    _drawFiddlerCrab(canvas, Offset(w * 0.76, h * 0.58));

    // Garza blanca pescando en el agua salobre
    _drawHeron(canvas, Offset(w * 0.38, h * 0.44));

    // Pelícano costero en vuelo rasante sobre el dosel
    final double pelicanGlide = math.sin(anim * 2 * math.pi) * 3.0;
    _drawCoastalPelican(canvas, Offset(w * 0.34 + pelicanGlide, h * 0.24));
  }

  void _drawEstuaryShimmer(Canvas canvas, double w, double h) {
    final double shimmerAlpha = 0.20 + (math.sin(anim * 2 * math.pi).abs() * 0.15);
    final Paint shimmer = Paint()
      ..color = Colors.white.withValues(alpha: shimmerAlpha)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.32, h * 0.45), Offset(w * 0.40, h * 0.45), shimmer);
    canvas.drawLine(Offset(w * 0.58, h * 0.47), Offset(w * 0.66, h * 0.47), shimmer);
    canvas.drawLine(Offset(w * 0.42, h * 0.54), Offset(w * 0.49, h * 0.54), shimmer);
  }

  void _drawPneumatophores(Canvas canvas, Offset base, int count) {
    final Paint p = Paint()
      ..color = const Color(0xFF3E2723).withValues(alpha: 0.85)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < count; i++) {
      final double x = base.dx + (i * 4.5);
      final double y = base.dy + (i % 2 == 0 ? 0 : 2);
      final double len = 4.0 + (i % 3) * 1.5;
      canvas.drawLine(Offset(x, y), Offset(x, y - len), p);
    }
  }

  void _drawMangroveFish(Canvas canvas, Offset pos, double scale) {
    final Paint fishBody = Paint()..color = const Color(0xFFB2DFDB).withValues(alpha: 0.85);
    canvas.drawOval(Rect.fromCenter(center: pos, width: 8 * scale, height: 4 * scale), fishBody);
    final Path tail = Path()
      ..moveTo(pos.dx - 3 * scale, pos.dy)
      ..lineTo(pos.dx - 6 * scale, pos.dy - 2.5 * scale)
      ..lineTo(pos.dx - 5 * scale, pos.dy)
      ..lineTo(pos.dx - 6 * scale, pos.dy + 2.5 * scale)
      ..close();
    canvas.drawPath(tail, fishBody);
    canvas.drawCircle(Offset(pos.dx + 2 * scale, pos.dy - 0.5 * scale), 0.6 * scale, Paint()..color = Colors.black);
  }

  void _drawFiddlerCrab(Canvas canvas, Offset pos) {
    final Paint crab = Paint()..color = const Color(0xFFE65100);
    // Caparazón
    canvas.drawOval(Rect.fromCenter(center: pos, width: 10, height: 6), crab);
    // Pinza gigante distintiva del cangrejo violinista
    final double clawWag = math.sin(anim * 4 * math.pi) * 2.0;
    final Paint bigClaw = Paint()..color = const Color(0xFFFFB74D);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 7, pos.dy - 4 + clawWag), width: 7, height: 4.5), bigClaw);
    // Pinza pequeña
    canvas.drawCircle(Offset(pos.dx - 5, pos.dy - 1), 1.8, crab);
    // Patitas
    final Paint leg = Paint()..color = const Color(0xFFBF360C)..strokeWidth = 1.0;
    canvas.drawLine(Offset(pos.dx - 3, pos.dy + 2), Offset(pos.dx - 6, pos.dy + 6), leg);
    canvas.drawLine(Offset(pos.dx + 3, pos.dy + 2), Offset(pos.dx + 6, pos.dy + 6), leg);
    // Ojos pedunculados
    canvas.drawCircle(Offset(pos.dx - 1.5, pos.dy - 3.5), 1.0, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(pos.dx + 1.5, pos.dy - 3.5), 1.0, Paint()..color = Colors.black);
  }

  void _drawCoastalPelican(Canvas canvas, Offset pos) {
    final double wingFlap = math.sin(anim * 3 * math.pi) * 3.0;
    final Paint pelican = Paint()..color = const Color(0xFFCFD8DC);
    // Cuerpo
    canvas.drawOval(Rect.fromCenter(center: pos, width: 14, height: 7), pelican);
    // Cabeza y bolsa gular amarilla
    canvas.drawCircle(Offset(pos.dx + 7, pos.dy - 2), 2.8, pelican);
    canvas.drawLine(Offset(pos.dx + 8, pos.dy - 1), Offset(pos.dx + 16, pos.dy), Paint()..color = const Color(0xFFFFB300)..strokeWidth = 2.0);
    canvas.drawCircle(Offset(pos.dx + 11, pos.dy + 1), 1.8, Paint()..color = const Color(0xFFFFCC80)); // Bolsa gular
    // Alas en V
    final Path wings = Path()
      ..moveTo(pos.dx - 4, pos.dy)
      ..lineTo(pos.dx - 12, pos.dy - 8 + wingFlap)
      ..lineTo(pos.dx + 2, pos.dy - 4)
      ..lineTo(pos.dx + 12, pos.dy - 8 - wingFlap)
      ..lineTo(pos.dx + 4, pos.dy)
      ..close();
    canvas.drawPath(wings, Paint()..color = const Color(0xFF90A4AE));
  }

  void _drawMangroveTideWaves(Canvas canvas, double w, double h) {
    final double tideOffset = math.sin(anim * 2 * math.pi) * 3.5;
    final Paint tideWave = Paint()
      ..color = Colors.white.withValues(alpha: 0.60)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    // Onda 1 canal central
    final Path wave1 = Path()
      ..moveTo(w * 0.42, h * 0.50 + tideOffset)
      ..quadraticBezierTo(w * 0.50, h * 0.48 + tideOffset, w * 0.58, h * 0.50 + tideOffset);
    canvas.drawPath(wave1, tideWave);

    // Onda 2 canal bajo
    final Path wave2 = Path()
      ..moveTo(w * 0.45, h * 0.62 - tideOffset)
      ..quadraticBezierTo(w * 0.52, h * 0.60 - tideOffset, w * 0.60, h * 0.62 - tideOffset);
    canvas.drawPath(wave2, tideWave);
  }

  void _drawRealMangroveTree(Canvas canvas, Offset pos, [double sway = 0.0, double scale = 1.0]) {
    // Múltiples raíces zancudas arqueadas tipo patas de araña
    final Paint rootPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..strokeWidth = 2.4 * scale
      ..style = PaintingStyle.stroke;

    // Raíz arqueada izquierda 1
    final Path r1 = Path()
      ..moveTo(pos.dx, pos.dy - 6 * scale)
      ..quadraticBezierTo(pos.dx - 14 * scale, pos.dy + 4 * scale, pos.dx - 12 * scale, pos.dy + 16 * scale);
    canvas.drawPath(r1, rootPaint);

    // Raíz arqueada izquierda 2
    final Path r2 = Path()
      ..moveTo(pos.dx, pos.dy - 6 * scale)
      ..quadraticBezierTo(pos.dx - 7 * scale, pos.dy + 6 * scale, pos.dx - 4 * scale, pos.dy + 18 * scale);
    canvas.drawPath(r2, rootPaint);

    // Raíz arqueada derecha 1
    final Path r3 = Path()
      ..moveTo(pos.dx, pos.dy - 6 * scale)
      ..quadraticBezierTo(pos.dx + 14 * scale, pos.dy + 4 * scale, pos.dx + 12 * scale, pos.dy + 16 * scale);
    canvas.drawPath(r3, rootPaint);

    // Raíz arqueada derecha 2
    final Path r4 = Path()
      ..moveTo(pos.dx, pos.dy - 6 * scale)
      ..quadraticBezierTo(pos.dx + 7 * scale, pos.dy + 6 * scale, pos.dx + 5 * scale, pos.dy + 18 * scale);
    canvas.drawPath(r4, rootPaint);

    // Tronco que se eleva sobre las raíces
    canvas.drawLine(
      Offset(pos.dx, pos.dy - 6 * scale),
      Offset(pos.dx + sway * 0.4, pos.dy - 16 * scale),
      rootPaint..strokeWidth = 3.6 * scale,
    );

    // Copa densa y brillante de mangle con balanceo
    final Offset center = Offset(pos.dx + sway, pos.dy - 22 * scale);
    final Paint foliage = Paint()..color = const Color(0xFF004D40);
    canvas.drawCircle(center, 15 * scale, foliage);
    canvas.drawCircle(Offset(center.dx - 8 * scale, center.dy + 4 * scale), 11 * scale, foliage);
    canvas.drawCircle(Offset(center.dx + 8 * scale, center.dy + 4 * scale), 11 * scale, Paint()..color = const Color(0xFF00796B));
  }

  // =========================================================================
  // 6. BOSQUE SECO TROPICAL — Desierto de la Tatacoa, cárcavas rojas, cactus y viento cálido
  // =========================================================================
  void _drawBosqueSeco(Canvas canvas, double w, double h) {
    final double windSway = math.sin(anim * 2 * math.pi) * 1.5;

    // 1. CÁRCAVAS Y LABERINTOS DE ARCILLA ROJIZA (Estilo Desierto de la Tatacoa - El Cuzco)
    _drawTatacoaCanyons(canvas, w, h);

    // 2. SUELO ÁRIDO AGRIETADO Y ESTRATOS DE SEQUEDAD
    _drawCrackedDryEarth(canvas, w, h);

    // 3. FLORA EMBLEMÁTICA DEL BOSQUE SECO Y DESIERTO COLOMBIANO
    // Ceiba Barrigona (Cavanillesia chicamochae) con tronco ensanchado característico
    _drawCeibaBarrigona(canvas, Offset(w * 0.38, h * 0.44), windSway);

    // Guayacán de flores doradas resecas
    _drawGuayacanTree(canvas, Offset(w * 0.65, h * 0.45));

    // Árbol caducifolio seco (trupillo) con ramas retorcidas
    _drawDryTree(canvas, Offset(w * 0.82, h * 0.49));

    // Cactus Candelabro gigantes (Cardones del desierto)
    _drawCandelabraCactus(canvas, Offset(w * 0.20, h * 0.54), 26);
    _drawCandelabraCactus(canvas, Offset(w * 0.78, h * 0.53), 28);
    _drawCandelabraCactus(canvas, Offset(w * 0.15, h * 0.49), 20);

    // Melocactus / Cactus Cabeza de Negro con su cefalio rojo brillante
    _drawMelocactus(canvas, Offset(w * 0.30, h * 0.59), 8.5);
    _drawMelocactus(canvas, Offset(w * 0.68, h * 0.60), 7.5);

    // 4. ANIMACIÓN: VIENTO CÁLIDO Y TOLVANERAS DEL DESIERTO
    _drawWarmWindStreams(canvas, w, h);

    // 5. FAUNA DEL DESIERTO
    // Iguana del desierto descansando sobre un montículo arcilloso con balanceo de cola
    _drawIguanaAnimated(canvas, Offset(w * 0.48, h * 0.55));

    // Gavilán / ave rapaz planeando en círculos térmicos en el cielo
    final double hawkGlide = math.sin(anim * 2 * math.pi) * 3.5;
    _drawDesertHawk(canvas, Offset(w * 0.32 + hawkGlide, h * 0.22));
  }

  void _drawTatacoaCanyons(Canvas canvas, double w, double h) {
    // Cresta erosionada fondo izquierda
    final Path canyonLeft = Path()
      ..moveTo(w * 0.20, h * 0.44)
      ..lineTo(w * 0.26, h * 0.35)
      ..lineTo(w * 0.32, h * 0.38)
      ..lineTo(w * 0.38, h * 0.34)
      ..lineTo(w * 0.46, h * 0.42)
      ..lineTo(w * 0.40, h * 0.46)
      ..close();
    canvas.drawPath(
      canyonLeft,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFC85A32), Color(0xFF8F3417)],
        ).createShader(Rect.fromLTWH(w * 0.20, h * 0.34, w * 0.26, h * 0.12)),
    );

    // Cresta erosionada fondo derecha (laberinto de cárcavas del Cuzco)
    final Path canyonRight = Path()
      ..moveTo(w * 0.52, h * 0.43)
      ..lineTo(w * 0.58, h * 0.33)
      ..lineTo(w * 0.64, h * 0.37)
      ..lineTo(w * 0.72, h * 0.31)
      ..lineTo(w * 0.80, h * 0.42)
      ..lineTo(w * 0.70, h * 0.46)
      ..close();
    canvas.drawPath(
      canyonRight,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD46A43), Color(0xFF752D16)],
        ).createShader(Rect.fromLTWH(w * 0.52, h * 0.31, w * 0.28, h * 0.15)),
    );

    // Aristas y sombras de erosión vertical en los cañones
    final Paint crevicePaint = Paint()
      ..color = const Color(0xFF5D2010).withValues(alpha: 0.75)
      ..strokeWidth = 1.6;
    canvas.drawLine(Offset(w * 0.26, h * 0.35), Offset(w * 0.28, h * 0.44), crevicePaint);
    canvas.drawLine(Offset(w * 0.38, h * 0.34), Offset(w * 0.37, h * 0.43), crevicePaint);
    canvas.drawLine(Offset(w * 0.58, h * 0.33), Offset(w * 0.59, h * 0.42), crevicePaint);
    canvas.drawLine(Offset(w * 0.72, h * 0.31), Offset(w * 0.74, h * 0.41), crevicePaint);

    // Facetas iluminadas de arcilla ocre
    final Paint lightFace = Paint()..color = const Color(0xFFF4A261).withValues(alpha: 0.45);
    final Path face1 = Path()
      ..moveTo(w * 0.26, h * 0.35)
      ..lineTo(w * 0.32, h * 0.38)
      ..lineTo(w * 0.30, h * 0.44)
      ..close();
    canvas.drawPath(face1, lightFace);

    final Path face2 = Path()
      ..moveTo(w * 0.72, h * 0.31)
      ..lineTo(w * 0.78, h * 0.39)
      ..lineTo(w * 0.74, h * 0.41)
      ..close();
    canvas.drawPath(face2, lightFace);
  }

  void _drawCrackedDryEarth(Canvas canvas, double w, double h) {
    // Parches de suelo reseco
    final Paint dryMud = Paint()..color = const Color(0xFFA7411E).withValues(alpha: 0.45);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.32, h * 0.54), width: 50, height: 18), dryMud);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.66, h * 0.56), width: 55, height: 20), dryMud);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.50, h * 0.62), width: 65, height: 22), dryMud);

    // Grietas finas de aridez
    final Paint crackPaint = Paint()
      ..color = const Color(0xFF4A1A0C).withValues(alpha: 0.55)
      ..strokeWidth = 1.0;
    // Grieta 1
    canvas.drawLine(Offset(w * 0.46, h * 0.61), Offset(w * 0.50, h * 0.63), crackPaint);
    canvas.drawLine(Offset(w * 0.50, h * 0.63), Offset(w * 0.54, h * 0.62), crackPaint);
    canvas.drawLine(Offset(w * 0.50, h * 0.63), Offset(w * 0.51, h * 0.66), crackPaint);
    // Grieta 2
    canvas.drawLine(Offset(w * 0.64, h * 0.55), Offset(w * 0.68, h * 0.57), crackPaint);
    canvas.drawLine(Offset(w * 0.68, h * 0.57), Offset(w * 0.71, h * 0.55), crackPaint);
    // Grieta 3
    canvas.drawLine(Offset(w * 0.28, h * 0.53), Offset(w * 0.33, h * 0.55), crackPaint);
    canvas.drawLine(Offset(w * 0.33, h * 0.55), Offset(w * 0.35, h * 0.58), crackPaint);
  }

  void _drawCeibaBarrigona(Canvas canvas, Offset pos, double sway) {
    // Tronco grueso abultado / barrigón
    final Path swollenTrunk = Path()
      ..moveTo(pos.dx - 5, pos.dy)
      ..quadraticBezierTo(pos.dx - 10, pos.dy - 12, pos.dx - 4 + sway * 0.3, pos.dy - 24)
      ..lineTo(pos.dx + 4 + sway * 0.3, pos.dy - 24)
      ..quadraticBezierTo(pos.dx + 10, pos.dy - 12, pos.dx + 5, pos.dy)
      ..close();
    canvas.drawPath(swollenTrunk, Paint()..color = const Color(0xFF795548));

    // Estrías de corteza seca
    canvas.drawLine(Offset(pos.dx - 2, pos.dy - 4), Offset(pos.dx - 1, pos.dy - 20), Paint()..color = const Color(0xFF5D4037)..strokeWidth = 1.2);
    canvas.drawLine(Offset(pos.dx + 2, pos.dy - 4), Offset(pos.dx + 1, pos.dy - 20), Paint()..color = const Color(0xFF5D4037)..strokeWidth = 1.2);

    // Ramas retorcidas desnudas
    final Paint branch = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final Offset top = Offset(pos.dx + sway * 0.3, pos.dy - 24);
    canvas.drawLine(top, Offset(top.dx - 12, top.dy - 10), branch);
    canvas.drawLine(top, Offset(top.dx + 12, top.dy - 9), branch);
    canvas.drawLine(top, Offset(top.dx, top.dy - 13), branch);

    // Escasas hojas caducifolias resecas amarillentas
    final Paint dryLeaves = Paint()..color = const Color(0xFFE9C46A);
    canvas.drawCircle(Offset(top.dx - 12, top.dy - 10), 3.0, dryLeaves);
    canvas.drawCircle(Offset(top.dx + 12, top.dy - 9), 3.0, dryLeaves);
    canvas.drawCircle(Offset(top.dx, top.dy - 13), 3.5, dryLeaves);
  }

  void _drawCandelabraCactus(Canvas canvas, Offset base, double height) {
    final double stemH = height;
    final Paint cactusGreen = Paint()
      ..color = const Color(0xFF386641)
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final Paint spineHighlight = Paint()
      ..color = const Color(0xFF6A994E)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Tronco principal central
    final Offset top = Offset(base.dx, base.dy - stemH);
    canvas.drawLine(base, top, cactusGreen);
    canvas.drawLine(Offset(base.dx + 0.8, base.dy), Offset(top.dx + 0.8, top.dy), spineHighlight);

    // Brazo izquierdo en forma de candelabro
    final double arm1H = stemH * 0.55;
    final Path armLeft = Path()
      ..moveTo(base.dx, base.dy - stemH * 0.40)
      ..lineTo(base.dx - 8, base.dy - stemH * 0.40)
      ..lineTo(base.dx - 8, base.dy - stemH * 0.40 - arm1H);
    canvas.drawPath(armLeft, cactusGreen..strokeWidth = 2.8);
    canvas.drawPath(armLeft, spineHighlight..strokeWidth = 1.0);

    // Brazo derecho en forma de candelabro
    final double arm2H = stemH * 0.65;
    final Path armRight = Path()
      ..moveTo(base.dx, base.dy - stemH * 0.35)
      ..lineTo(base.dx + 8, base.dy - stemH * 0.35)
      ..lineTo(base.dx + 8, base.dy - stemH * 0.35 - arm2H);
    canvas.drawPath(armRight, cactusGreen..strokeWidth = 2.8);
    canvas.drawPath(armRight, spineHighlight..strokeWidth = 1.0);
  }

  void _drawMelocactus(Canvas canvas, Offset pos, double radius) {
    // Cuerpo globoso verde oscuro
    canvas.drawCircle(pos, radius, Paint()..color = const Color(0xFF2D5A27));
    // Costillas acanaladas
    final Paint rib = Paint()
      ..color = const Color(0xFF4A7C39)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(pos.dx, pos.dy - radius), Offset(pos.dx, pos.dy + radius), rib);
    canvas.drawOval(Rect.fromCenter(center: pos, width: radius * 1.1, height: radius * 2), rib);

    // Cefalio rojo (sombrerito lanoso cilíndrico carmesí donde florece)
    final Offset cephaliumPos = Offset(pos.dx, pos.dy - radius - 2.5);
    final Paint cephaliumPaint = Paint()..color = const Color(0xFFC62828);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: cephaliumPos, width: radius * 0.75, height: 5),
        const Radius.circular(2),
      ),
      cephaliumPaint,
    );
    // Puntos de flores diminutas en el cefalio
    canvas.drawCircle(Offset(cephaliumPos.dx - 1.5, cephaliumPos.dy - 1), 0.8, Paint()..color = const Color(0xFFFF80AB));
    canvas.drawCircle(Offset(cephaliumPos.dx + 1.5, cephaliumPos.dy - 1), 0.8, Paint()..color = const Color(0xFFFF80AB));
  }

  void _drawWarmWindStreams(Canvas canvas, double w, double h) {
    // Corrientes de viento cálido ondulante que cruzan las cárcavas
    final Paint windPaint = Paint()
      ..color = const Color(0xFFFFE0B2).withValues(alpha: 0.35)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Ráfaga 1: viento cálido superior
    final double wind1Prog = (anim * 1.5) % 1.0;
    final double wind1X = w * 0.10 + (wind1Prog * w * 0.70);
    final Path gust1 = Path()
      ..moveTo(wind1X, h * 0.46)
      ..quadraticBezierTo(wind1X + 16, h * 0.44, wind1X + 32, h * 0.46)
      ..quadraticBezierTo(wind1X + 44, h * 0.48, wind1X + 54, h * 0.45);
    canvas.drawPath(gust1, windPaint..color = const Color(0xFFFFCC80).withValues(alpha: (1.0 - (wind1Prog - 0.5).abs() * 2).clamp(0.1, 0.45)));

    // Ráfaga 2: tolvanera media con giro de arena
    final double wind2Prog = (anim * 1.5 + 0.5) % 1.0;
    final double wind2X = w * 0.15 + (wind2Prog * w * 0.65);
    final Path gust2 = Path()
      ..moveTo(wind2X, h * 0.57)
      ..quadraticBezierTo(wind2X + 18, h * 0.59, wind2X + 34, h * 0.56)
      ..quadraticBezierTo(wind2X + 46, h * 0.54, wind2X + 58, h * 0.57);
    canvas.drawPath(gust2, windPaint..color = const Color(0xFFFFD54F).withValues(alpha: (1.0 - (wind2Prog - 0.5).abs() * 2).clamp(0.1, 0.40)));

    // Pequeñas partículas doradas/arenilla impulsadas por el viento
    for (int i = 0; i < 4; i++) {
      final double partProg = (anim * 2.0 + (i * 0.25)) % 1.0;
      final double px = w * 0.20 + (partProg * w * 0.60);
      final double py = h * (0.47 + (i * 0.04)) + math.sin(partProg * 4 * math.pi) * 2.5;
      final double pAlpha = math.sin(partProg * math.pi).clamp(0.0, 1.0) * 0.60;
      canvas.drawCircle(Offset(px, py), 1.2, Paint()..color = const Color(0xFFFFE082).withValues(alpha: pAlpha));
    }
  }

  void _drawDesertHawk(Canvas canvas, Offset pos) {
    final double wingAngle = math.sin(anim * 2 * math.pi) * 2.0;
    final Paint hawk = Paint()
      ..color = const Color(0xFF3E2723)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final Path wings = Path()
      ..moveTo(pos.dx - 13, pos.dy - 3 + wingAngle)
      ..quadraticBezierTo(pos.dx - 4, pos.dy + 3, pos.dx, pos.dy)
      ..quadraticBezierTo(pos.dx + 4, pos.dy + 3, pos.dx + 13, pos.dy - 3 + wingAngle);
    canvas.drawPath(wings, hawk);
    canvas.drawCircle(Offset(pos.dx, pos.dy), 1.4, Paint()..color = const Color(0xFF3E2723));
  }

  // =========================================================================
  // 7. LLANOS ORIENTALES — Gran caño llanero, ganadería criolla, corocoras y morichales
  // =========================================================================
  void _drawLlanosSabana(Canvas canvas, double w, double h, Offset bottom) {
    final double windSway = math.sin(anim * 2 * math.pi) * 2.2;
    final double palmSway = math.sin(anim * 2 * math.pi) * 1.6;

    // 1. GRAN RÍO / CAÑO LLANERO SERPENTEANTE (Río Meta / Caño de Sabana)
    final Offset riverStart = Offset(w * 0.42, h * 0.42);

    // Playa de arena dorada y orillas de ribera
    final Path sandBank = Path()
      ..moveTo(riverStart.dx - 14, riverStart.dy)
      ..quadraticBezierTo(w * 0.60, h * 0.48, w * 0.54, h * 0.58)
      ..quadraticBezierTo(w * 0.44, h * 0.66, bottom.dx + 16, bottom.dy)
      ..lineTo(bottom.dx - 16, bottom.dy)
      ..quadraticBezierTo(w * 0.32, h * 0.66, w * 0.40, h * 0.58)
      ..quadraticBezierTo(w * 0.48, h * 0.48, riverStart.dx - 14, riverStart.dy)
      ..close();
    canvas.drawPath(sandBank, Paint()..color = const Color(0xFFD7CCC8).withValues(alpha: 0.55));

    // Cauce del río de agua viva translúcida
    final Path llanosRiver = Path()
      ..moveTo(riverStart.dx + 6, riverStart.dy + 2)
      ..quadraticBezierTo(w * 0.56, h * 0.48, w * 0.50, h * 0.58)
      ..quadraticBezierTo(w * 0.41, h * 0.65, bottom.dx + 8, bottom.dy)
      ..lineTo(bottom.dx - 8, bottom.dy)
      ..quadraticBezierTo(w * 0.34, h * 0.65, w * 0.42, h * 0.58)
      ..quadraticBezierTo(w * 0.49, h * 0.48, riverStart.dx - 6, riverStart.dy + 2)
      ..close();

    final Paint riverWater = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF81D4FA), // Superficie iluminada
          Color(0xFF29B6F6), // Azul límpido de caño llanero
          Color(0xFF0288D1), // Profundidad fluvial
          Color(0xFF01579B), // Lecho profundo
        ],
        stops: [0.0, 0.30, 0.70, 1.0],
      ).createShader(Rect.fromLTWH(w * 0.3, riverStart.dy, w * 0.4, bottom.dy - riverStart.dy));
    canvas.drawPath(llanosRiver, riverWater);

    // Destellos y corriente de agua fluyendo continuamente
    _drawFlowingWaterCurrent(canvas, [
      Offset(riverStart.dx, riverStart.dy + 3),
      Offset(w * 0.52, h * 0.49),
      Offset(w * 0.45, h * 0.58),
      Offset(w * 0.38, h * 0.65),
      Offset(bottom.dx, bottom.dy),
    ]);

    // ANIMACIÓN: Cascada / desborde del río en el vértice inferior de la isla
    _drawAnimatedWaterfall(canvas, bottom.dx, bottom.dy, 32);

    // 2. INDUSTRIA GANADERA LLANERA (Cebú llanero criollo y cerco de hato)
    // Cerco de estacas y alambre típico de hato ganadero llanero
    _drawHatoFence(canvas, Offset(w * 0.10, h * 0.51), Offset(w * 0.32, h * 0.57));

    // Vaca llanera blanca con cuernos arqueados, giba cebuina y balanceo de cola
    _drawLlaneroCattle(canvas, Offset(w * 0.26, h * 0.53));
    // Ternero pastando al lado
    _drawLlaneroCattle(canvas, Offset(w * 0.17, h * 0.57), isCalf: true);

    // 3. MORICHALES LLANEROS (Palmas de Moriche bordeando el caño)
    _drawMorichePalm(canvas, Offset(w * 0.76, h * 0.45), 44, palmSway);
    _drawMorichePalm(canvas, Offset(w * 0.85, h * 0.49), 36, -palmSway * 0.8);
    _drawMorichePalm(canvas, Offset(w * 0.66, h * 0.42), 32, palmSway * 0.7);

    // 4. FAUNA EMBLEMÁTICA: COROCORAS ROJAS (Flamencos / Ibis escarlata) Y CHIGÜIROS
    // Corocoras rojas en la orilla del río bebiendo agua con sus picos curvados
    _drawCorocoraOnShore(canvas, Offset(w * 0.60, h * 0.53));
    _drawCorocoraOnShore(canvas, Offset(w * 0.66, h * 0.56));
    _drawCorocoraOnShore(canvas, Offset(w * 0.56, h * 0.58));

    // Corocoras rojas en vuelo en el cielo con aleteo animado
    final double birdFlap = math.sin(anim * 4 * math.pi) * 3.0;
    _drawCorocora(canvas, Offset(w * 0.58, h * 0.24 + birdFlap));
    _drawCorocora(canvas, Offset(w * 0.65, h * 0.22 - birdFlap));

    // Chigüiro (Capibara) adulto y cría en la orilla del agua
    _drawChiguiro(canvas, Offset(w * 0.44, h * 0.60));
    _drawChiguiro(canvas, Offset(w * 0.53, h * 0.62), isSmall: true);

    // 5. ANIMACIÓN: PASTIZALES DORADOS Y VERDES MECIÉNDOSE CON LA BRISA LLANERA
    _drawGoldenGrass(canvas, Offset(w * 0.14, h * 0.48), windSway);
    _drawGoldenGrass(canvas, Offset(w * 0.22, h * 0.50), -windSway * 0.8);
    _drawGoldenGrass(canvas, Offset(w * 0.36, h * 0.63), windSway * 1.1);
    _drawGoldenGrass(canvas, Offset(w * 0.74, h * 0.58), -windSway);
    _drawGoldenGrass(canvas, Offset(w * 0.82, h * 0.55), windSway * 0.9);
  }

  void _drawLlaneroCattle(Canvas canvas, Offset pos, {bool isCalf = false}) {
    final double s = isCalf ? 0.65 : 1.0;
    final double tailSway = math.sin(anim * 2 * math.pi) * 2.5;

    // Pelaje blanco/cenizo de ganado llanero criollo
    final Paint coat = Paint()..color = const Color(0xFFECEFF1);
    final Paint coatShade = Paint()..color = const Color(0xFFCFD8DC);

    // Patas firmes sobre la sabana
    final Paint legPaint = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..strokeWidth = 2.2 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(pos.dx - 9 * s, pos.dy + 4 * s), Offset(pos.dx - 9 * s, pos.dy + 15 * s), legPaint);
    canvas.drawLine(Offset(pos.dx - 4 * s, pos.dy + 4 * s), Offset(pos.dx - 4 * s, pos.dy + 15 * s), legPaint);
    canvas.drawLine(Offset(pos.dx + 4 * s, pos.dy + 4 * s), Offset(pos.dx + 4 * s, pos.dy + 15 * s), legPaint);
    canvas.drawLine(Offset(pos.dx + 9 * s, pos.dy + 4 * s), Offset(pos.dx + 9 * s, pos.dy + 15 * s), legPaint);

    // Cola con mechón oscilando para espantar insectos
    final Paint tailPaint = Paint()
      ..color = const Color(0xFF90A4AE)
      ..strokeWidth = 1.4 * s;
    canvas.drawLine(Offset(pos.dx - 12 * s, pos.dy), Offset(pos.dx - 15 * s + tailSway, pos.dy + 10 * s), tailPaint);
    canvas.drawCircle(Offset(pos.dx - 15 * s + tailSway, pos.dy + 11 * s), 1.6 * s, Paint()..color = const Color(0xFF455A64));

    // Cuerpo robusto
    canvas.drawOval(Rect.fromCenter(center: pos, width: 26 * s, height: 16 * s), coat);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx, pos.dy + 3 * s), width: 22 * s, height: 10 * s), coatShade);

    // Giba cebuina sobre el lomo
    if (!isCalf) {
      canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 4 * s, pos.dy - 7 * s), width: 8 * s, height: 6 * s), coat);
    }

    // Cuello y cabeza
    final Offset headPos = Offset(pos.dx + 13 * s, pos.dy - 4 * s);
    canvas.drawOval(Rect.fromCenter(center: headPos, width: 10 * s, height: 12 * s), coat);
    // Hocico oscuro
    canvas.drawOval(Rect.fromCenter(center: Offset(headPos.dx + 3 * s, headPos.dy + 4 * s), width: 6 * s, height: 5 * s), Paint()..color = const Color(0xFF78909C));

    // Orejas caídas características
    canvas.drawOval(Rect.fromCenter(center: Offset(headPos.dx - 3 * s, headPos.dy - 1 * s), width: 5 * s, height: 3 * s), coatShade);

    // Cuernos arqueados blancos con puntas oscuras
    if (!isCalf) {
      final Paint hornPaint = Paint()
        ..color = const Color(0xFFFFF8E1)
        ..strokeWidth = 1.8 * s
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final Path leftHorn = Path()
        ..moveTo(headPos.dx - 2 * s, headPos.dy - 5 * s)
        ..quadraticBezierTo(headPos.dx - 5 * s, headPos.dy - 11 * s, headPos.dx - 2 * s, headPos.dy - 12 * s);
      canvas.drawPath(leftHorn, hornPaint);

      final Path rightHorn = Path()
        ..moveTo(headPos.dx + 2 * s, headPos.dy - 5 * s)
        ..quadraticBezierTo(headPos.dx + 5 * s, headPos.dy - 11 * s, headPos.dx + 2 * s, headPos.dy - 12 * s);
      canvas.drawPath(rightHorn, hornPaint);
    }

    // Ojo
    canvas.drawCircle(Offset(headPos.dx, headPos.dy - 2 * s), 1.0 * s, Paint()..color = Colors.black);
  }

  void _drawCorocoraOnShore(Canvas canvas, Offset pos) {
    final Paint scarlet = Paint()..color = const Color(0xFFD50000); // Rojo escarlata vivo
    // Patas finas de ave zancuda
    final Paint leg = Paint()
      ..color = const Color(0xFFFF5252)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy + 8), leg);
    canvas.drawLine(Offset(pos.dx + 2, pos.dy), Offset(pos.dx + 2, pos.dy + 8), leg);

    // Cuerpo rojo escarlata
    canvas.drawOval(Rect.fromCenter(center: pos, width: 10, height: 7), scarlet);
    // Cuello y cabeza
    canvas.drawCircle(Offset(pos.dx + 5, pos.dy - 4), 2.5, scarlet);
    // Pico largo curvado hacia abajo (característico de la corocora / ibis)
    final Path bill = Path()
      ..moveTo(pos.dx + 6, pos.dy - 4)
      ..quadraticBezierTo(pos.dx + 11, pos.dy - 3, pos.dx + 13, pos.dy);
    canvas.drawPath(
      bill,
      Paint()
        ..color = const Color(0xFFFF5252)
        ..strokeWidth = 1.3
        ..style = PaintingStyle.stroke,
    );
    // Ojo diminuto
    canvas.drawCircle(Offset(pos.dx + 5.5, pos.dy - 4.5), 0.6, Paint()..color = Colors.black);
  }

  void _drawHatoFence(Canvas canvas, Offset p1, Offset p2) {
    final Paint post = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final Paint wire = Paint()
      ..color = const Color(0xFF78909C)
      ..strokeWidth = 0.9;

    // Alambres del cerco
    canvas.drawLine(Offset(p1.dx, p1.dy - 6), Offset(p2.dx, p2.dy - 6), wire);
    canvas.drawLine(Offset(p1.dx, p1.dy - 2), Offset(p2.dx, p2.dy - 2), wire);

    // Postes de madera rústica
    for (int i = 0; i <= 3; i++) {
      final double t = i / 3.0;
      final Offset pt = Offset.lerp(p1, p2, t)!;
      canvas.drawLine(pt, Offset(pt.dx, pt.dy - 10), post);
    }
  }

  // =========================================================================
  // MÉTODOS DE ANIMACIÓN DE AGUA Y FLUIDOS
  // =========================================================================

  void _drawFlowingWaterCurrent(Canvas canvas, List<Offset> points) {
    if (points.length < 2) return;

    // Calculamos vetas de corriente que viajan a lo largo de los puntos
    final Paint currentPaint = Paint()
      ..color = Colors.white.withOpacity(0.68)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      final Offset p1 = points[i];
      final Offset p2 = points[i + 1];

      // Interpolación basada en animación continua
      final double progress = (anim + (i / points.length)) % 1.0;
      final Offset start = Offset.lerp(p1, p2, (progress * 0.8).clamp(0.0, 1.0))!;
      final Offset end = Offset.lerp(p1, p2, (progress * 0.8 + 0.2).clamp(0.0, 1.0))!;

      canvas.drawLine(start, end, currentPaint);
    }
  }

  void _drawAnimatedWaterfall(Canvas canvas, double cx, double cy, double height) {
    // Cascada con líneas verticales que caen continuamente
    final Paint waterfallBack = Paint()..color = const Color(0xCCCAF0F8);
    final Path waterfallPath = Path()
      ..moveTo(cx - 9, cy)
      ..lineTo(cx + 9, cy)
      ..lineTo(cx + 7, cy + height)
      ..lineTo(cx - 7, cy + height)
      ..close();
    canvas.drawPath(waterfallPath, waterfallBack);

    // Corrientes de agua que se desplazan hacia abajo
    final Paint streamPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 3; i++) {
      final double xOffset = (i - 1) * 4.5;
      final double streamY = cy + ((anim + i * 0.33) % 1.0 * (height - 6));
      canvas.drawLine(
        Offset(cx + xOffset, streamY),
        Offset(cx + xOffset, streamY + 6),
        streamPaint,
      );
    }

    // Espuma blanca palpitante en la base de la cascada
    final double foamPulse = math.sin(anim * 4 * math.pi) * 2.0;
    final Paint foam = Paint()..color = Colors.white.withOpacity(0.88);
    canvas.drawCircle(Offset(cx - 5, cy + height), 4.5 + foamPulse * 0.5, foam);
    canvas.drawCircle(Offset(cx + 5, cy + height), 4.5 - foamPulse * 0.5, foam);
    canvas.drawCircle(Offset(cx, cy + height + 2), 3.5, foam);
  }

  // =========================================================================
  // FLORA Y BOTÁNICA DETALLADA
  // =========================================================================

  void _drawPalmTree(Canvas canvas, Offset base, double height, double sway) {
    // Tronco esbelto y curvado con sway de brisa
    final Path trunk = Path()
      ..moveTo(base.dx - 1.5, base.dy)
      ..quadraticBezierTo(base.dx + 2 + sway * 0.5, base.dy - height * 0.5, base.dx - 1 + sway, base.dy - height)
      ..lineTo(base.dx + 1 + sway, base.dy - height)
      ..quadraticBezierTo(base.dx + 4 + sway * 0.5, base.dy - height * 0.5, base.dx + 1.5, base.dy)
      ..close();
    canvas.drawPath(trunk, Paint()..color = const Color(0xFFF1F5F9));

    // Anillos oscuros característicos de la palma de cera
    final Paint ringPaint = Paint()
      ..color = const Color(0xFF64748B).withValues(alpha: 0.6)
      ..strokeWidth = 1.0;
    for (double f = 0.25; f <= 0.85; f += 0.2) {
      final double ringY = base.dy - height * f;
      final double ringX = base.dx + (sway * f * 0.7);
      canvas.drawLine(Offset(ringX - 1.4, ringY), Offset(ringX + 1.4, ringY), ringPaint);
    }

    // Corona de hojas
    final Offset top = Offset(base.dx + sway, base.dy - height);
    final Paint leaves = Paint()..color = const Color(0xFF1B4332);
    canvas.drawCircle(top, 8, leaves);
    canvas.drawCircle(Offset(top.dx - 7, top.dy + 3), 6, leaves);
    canvas.drawCircle(Offset(top.dx + 7, top.dy + 3), 6, leaves);
    canvas.drawCircle(Offset(top.dx - 4, top.dy - 6), 5, Paint()..color = const Color(0xFF2D6A4F));
    canvas.drawCircle(Offset(top.dx + 4, top.dy - 6), 5, Paint()..color = const Color(0xFF2D6A4F));
  }

  void _drawAndeanOak(Canvas canvas, Offset base, double radius, double sway) {
    // Tronco robusto y nudoso de roble andino
    final Paint trunk = Paint()
      ..color = const Color(0xFF3E2723)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    final Offset trunkTop = Offset(base.dx + sway * 0.4, base.dy - radius * 1.2);
    canvas.drawLine(base, trunkTop, trunk);

    // Ramas secundarias
    canvas.drawLine(
      Offset(base.dx, base.dy - radius * 0.6),
      Offset(base.dx - radius * 0.45 + sway * 0.2, base.dy - radius * 1.0),
      Paint()..color = const Color(0xFF3E2723)..strokeWidth = 2.0,
    );
    canvas.drawLine(
      Offset(base.dx, base.dy - radius * 0.7),
      Offset(base.dx + radius * 0.45 + sway * 0.2, base.dy - radius * 1.1),
      Paint()..color = const Color(0xFF3E2723)..strokeWidth = 2.0,
    );

    // Follaje frondoso en capas superpuestas de verde andino
    final Offset center = Offset(trunkTop.dx + sway, trunkTop.dy - 2);
    // Masa inferior (sombra)
    canvas.drawCircle(Offset(center.dx, center.dy + 2), radius, Paint()..color = const Color(0xFF1B4332));
    // Masas laterales
    canvas.drawCircle(Offset(center.dx - radius * 0.55, center.dy + 1), radius * 0.72, Paint()..color = const Color(0xFF23533E));
    canvas.drawCircle(Offset(center.dx + radius * 0.55, center.dy + 1), radius * 0.72, Paint()..color = const Color(0xFF2D6A4F));
    // Copa superior iluminada
    canvas.drawCircle(Offset(center.dx, center.dy - radius * 0.35), radius * 0.68, Paint()..color = const Color(0xFF388E3C));
    canvas.drawCircle(Offset(center.dx + radius * 0.2, center.dy - radius * 0.45), radius * 0.42, Paint()..color = const Color(0xFF4CAF50));
  }

  void _drawMorichePalm(Canvas canvas, Offset base, double height, [double sway = 0.0]) {
    final Paint trunk = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke;
    final Offset top = Offset(base.dx + sway * 0.3, base.dy - height);
    canvas.drawLine(base, top, trunk);

    final Offset crownCenter = Offset(top.dx + sway, top.dy);
    final Paint crown = Paint()..color = const Color(0xFF388E3C);
    canvas.drawCircle(crownCenter, 11, crown);
    canvas.drawCircle(Offset(crownCenter.dx - 8, crownCenter.dy + 4), 8, crown);
    canvas.drawCircle(Offset(crownCenter.dx + 8, crownCenter.dy + 4), 8, crown);
    canvas.drawCircle(Offset(crownCenter.dx, crownCenter.dy - 6), 7, Paint()..color = const Color(0xFF4CAF50));

    // Frutos del moriche (racimo colgante de drupas rojizas)
    canvas.drawCircle(Offset(crownCenter.dx - 2, crownCenter.dy + 8), 2.2, Paint()..color = const Color(0xFFBF360C));
    canvas.drawCircle(Offset(crownCenter.dx + 2, crownCenter.dy + 8), 2.2, Paint()..color = const Color(0xFFD84315));
  }

  void _drawAmazonCeiba(Canvas canvas, Offset base, double radius) {
    _drawAmazonCeibaAnimated(canvas, base, radius, 0.0);
  }

  void _drawAmazonCeibaAnimated(Canvas canvas, Offset base, double radius, double sway) {
    // Tronco con raíces tabulares gigantescas (bambas) características de la Ceiba amazónica
    final Path trunk = Path()
      ..moveTo(base.dx - 8, base.dy)
      ..lineTo(base.dx - 3 + sway * 0.3, base.dy - 20)
      ..lineTo(base.dx + 3 + sway * 0.3, base.dy - 20)
      ..lineTo(base.dx + 8, base.dy)
      ..close();
    canvas.drawPath(trunk, Paint()..color = const Color(0xFF382319));

    // Raíces tablares acentuadas
    final Paint buttress = Paint()
      ..color = const Color(0xFF261811)
      ..strokeWidth = 1.6;
    canvas.drawLine(Offset(base.dx - 6, base.dy), Offset(base.dx - 2 + sway * 0.3, base.dy - 12), buttress);
    canvas.drawLine(Offset(base.dx + 6, base.dy), Offset(base.dx + 2 + sway * 0.3, base.dy - 12), buttress);

    // Corona estratificada gigante con ramas extendidas (Dosel emergente)
    final Offset center = Offset(base.dx + sway, base.dy - 26);
    // Masa inferior sombría
    canvas.drawCircle(Offset(center.dx, center.dy + 3), radius, Paint()..color = const Color(0xFF0F2B1D));
    // Masas laterales de hojas perennes
    canvas.drawCircle(Offset(center.dx - radius * 0.55, center.dy + 2), radius * 0.75, Paint()..color = const Color(0xFF1B4332));
    canvas.drawCircle(Offset(center.dx + radius * 0.55, center.dy + 2), radius * 0.75, Paint()..color = const Color(0xFF1B4332));
    // Copa superior iluminada por el sol amazónico
    canvas.drawCircle(Offset(center.dx, center.dy - radius * 0.35), radius * 0.65, Paint()..color = const Color(0xFF2D6A4F));
    canvas.drawCircle(Offset(center.dx + radius * 0.25, center.dy - radius * 0.40), radius * 0.45, Paint()..color = const Color(0xFF40916C));
  }

  void _drawJungleCanopyTree(Canvas canvas, Offset base, double radius, Color baseColor, double sway) {
    final Paint trunk = Paint()
      ..color = const Color(0xFF332219)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    final Offset trunkTop = Offset(base.dx + sway * 0.4, base.dy - radius * 0.9);
    canvas.drawLine(base, trunkTop, trunk);

    final Offset center = Offset(trunkTop.dx + sway, trunkTop.dy - 2);
    canvas.drawCircle(center, radius, Paint()..color = baseColor);
    canvas.drawCircle(Offset(center.dx - radius * 0.3, center.dy - radius * 0.2), radius * 0.5, Paint()..color = const Color(0xFF52B788).withValues(alpha: 0.35));
  }

  void _drawJunglePalm(Canvas canvas, Offset base, double height, double sway) {
    // Tronco esbelto meciéndose
    final Paint trunk = Paint()
      ..color = const Color(0xFF4A3525)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    final Offset top = Offset(base.dx + sway, base.dy - height);
    canvas.drawLine(base, top, trunk);

    // Hojas de palma plumosas en arco (Palma de Asai / Chonta)
    final Paint frond = Paint()
      ..color = const Color(0xFF2D6A4F)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 6; i++) {
      final double angle = (i * math.pi / 3) + (sway * 0.05);
      final double fx = top.dx + math.cos(angle) * 11;
      final double fy = top.dy + math.sin(angle) * 6;
      canvas.drawLine(top, Offset(fx, fy), frond);
    }
  }

  void _drawGuayacanTree(Canvas canvas, Offset pos) {
    final Paint trunk = Paint()
      ..color = const Color(0xFF6D4C41)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - 16), trunk);

    final Offset top = Offset(pos.dx, pos.dy - 20);
    final Paint yellowFlower = Paint()..color = const Color(0xFFFFD54F);
    canvas.drawCircle(top, 14, yellowFlower);
    canvas.drawCircle(Offset(top.dx - 7, top.dy + 3), 9, Paint()..color = const Color(0xFFFFCA28));
    canvas.drawCircle(Offset(top.dx + 7, top.dy + 3), 9, Paint()..color = const Color(0xFFFFCA28));
    canvas.drawCircle(Offset(top.dx, top.dy - 6), 8, Paint()..color = const Color(0xFFFFEE58));
  }

  void _drawDryTree(Canvas canvas, Offset pos) {
    final Paint branch = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - 18), branch);
    canvas.drawLine(Offset(pos.dx, pos.dy - 12), Offset(pos.dx - 10, pos.dy - 22), branch);
    canvas.drawLine(Offset(pos.dx, pos.dy - 10), Offset(pos.dx + 10, pos.dy - 20), branch);

    canvas.drawCircle(Offset(pos.dx - 10, pos.dy - 22), 4, Paint()..color = const Color(0xFF8D6E63));
    canvas.drawCircle(Offset(pos.dx + 10, pos.dy - 20), 4, Paint()..color = const Color(0xFF8D6E63));
  }

  void _drawRoundTree(Canvas canvas, Offset pos, double radius, Color color) {
    final Paint trunk = Paint()
      ..color = const Color(0xFF4E342E)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - radius * 0.8), trunk);
    canvas.drawCircle(Offset(pos.dx, pos.dy - radius), radius, Paint()..color = color);
    canvas.drawCircle(Offset(pos.dx - radius * 0.3, pos.dy - radius * 1.2), radius * 0.5, Paint()..color = Colors.white.withOpacity(0.2));
  }

  void _drawEnhancedFrailejon(Canvas canvas, Offset base, double height, double sway) {
    // 1. Tallo grueso recubierto de hojas secas protectoras (necromasa marrón oscuro)
    final double trunkH = height * 0.65;
    final Path trunkPath = Path()
      ..moveTo(base.dx - 3.5, base.dy)
      ..lineTo(base.dx - 2.5 + sway * 0.3, base.dy - trunkH)
      ..lineTo(base.dx + 2.5 + sway * 0.3, base.dy - trunkH)
      ..lineTo(base.dx + 3.5, base.dy)
      ..close();
    canvas.drawPath(trunkPath, Paint()..color = const Color(0xFF332219));

    // Textura de hojas secas caídas pegadas al tronco
    final Paint dryLeaves = Paint()
      ..color = const Color(0xFF4A3525)
      ..strokeWidth = 1.4;
    canvas.drawLine(
      Offset(base.dx - 3, base.dy - trunkH * 0.3),
      Offset(base.dx + 3, base.dy - trunkH * 0.35),
      dryLeaves,
    );
    canvas.drawLine(
      Offset(base.dx - 3, base.dy - trunkH * 0.65),
      Offset(base.dx + 3, base.dy - trunkH * 0.70),
      dryLeaves,
    );

    // 2. Roseta apical de hojas suculentas y aterciopeladas (Espeletia)
    // Colores: verde oliva opaco, amarillo ocre/caqui aterciopelado y pelos plateados
    final Offset crownCenter = Offset(base.dx + sway, base.dy - trunkH - 2);
    final double crownR = height * 0.42;

    // Capa exterior de hojas extendidas (verde oliva opaco / caqui)
    for (int i = 0; i < 9; i++) {
      final double angle = (i * (2 * math.pi / 9)) - (math.pi / 2);
      final double leafLen = crownR * 0.95;
      final Offset leafEnd = Offset(
        crownCenter.dx + math.cos(angle) * leafLen,
        crownCenter.dy + math.sin(angle) * (leafLen * 0.75),
      );
      canvas.drawLine(
        crownCenter,
        leafEnd,
        Paint()
          ..color = const Color(0xFF6B705C) // Verde oliva opaco
          ..strokeWidth = 3.6
          ..strokeCap = StrokeCap.round,
      );
    }

    // Capa intermedia de roseta (amarillo caqui / ocre de páramo)
    for (int i = 0; i < 7; i++) {
      final double angle = (i * (2 * math.pi / 7)) + 0.3;
      final double leafLen = crownR * 0.65;
      final Offset leafEnd = Offset(
        crownCenter.dx + math.cos(angle) * leafLen,
        crownCenter.dy + math.sin(angle) * (leafLen * 0.7),
      );
      canvas.drawLine(
        crownCenter,
        leafEnd,
        Paint()
          ..color = const Color(0xFFB5A869) // Amarillo opaco / caqui
          ..strokeWidth = 3.0
          ..strokeCap = StrokeCap.round,
      );
    }

    // Corazón tierno central lanudo (vellosidad plateada protectora del frío)
    canvas.drawCircle(
      crownCenter,
      crownR * 0.32,
      Paint()..color = const Color(0xFFD8D3B8), // Caqui claro aterciopelado
    );
    canvas.drawCircle(
      crownCenter,
      crownR * 0.16,
      Paint()..color = const Color(0xFFEDE9D8),
    );
  }

  void _drawCactus(Canvas canvas, Offset pos) {
    final Paint cactus = Paint()
      ..color = const Color(0xFF689F38)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx, pos.dy - 16), cactus);
    canvas.drawLine(Offset(pos.dx - 5, pos.dy - 8), Offset(pos.dx - 5, pos.dy - 14), cactus..strokeWidth = 2.4);
    canvas.drawLine(Offset(pos.dx - 5, pos.dy - 8), Offset(pos.dx, pos.dy - 8), cactus);
    canvas.drawLine(Offset(pos.dx + 5, pos.dy - 6), Offset(pos.dx + 5, pos.dy - 12), cactus);
    canvas.drawLine(Offset(pos.dx + 5, pos.dy - 6), Offset(pos.dx, pos.dy - 6), cactus);
  }

  void _drawGoldenGrass(Canvas canvas, Offset pos, double sway) {
    final Paint grass = Paint()
      ..color = const Color(0xFFFDD835)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx - 3 + sway, pos.dy - 10), grass);
    canvas.drawLine(pos, Offset(pos.dx + 1 + sway * 1.2, pos.dy - 13), grass);
    canvas.drawLine(pos, Offset(pos.dx + 4 + sway * 0.8, pos.dy - 9), grass);
  }

  void _drawCloud(Canvas canvas, Offset pos, double size) {
    final Paint cloud = Paint()..color = Colors.white.withOpacity(0.78);
    canvas.drawCircle(pos, size * 0.45, cloud);
    canvas.drawCircle(Offset(pos.dx + size * 0.35, pos.dy), size * 0.32, cloud);
    canvas.drawCircle(Offset(pos.dx - size * 0.35, pos.dy + 2), size * 0.30, cloud);
  }

  // =========================================================================
  // FAUNA Y ANIMALES EMBLEMÁTICOS
  // =========================================================================

  void _drawOsoAnteojos(Canvas canvas, Offset pos) {
    final Paint bear = Paint()..color = const Color(0xFF1E1E1E);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx, pos.dy + 8), width: 16, height: 12), bear);
    canvas.drawCircle(pos, 8.5, bear);
    canvas.drawCircle(Offset(pos.dx - 6, pos.dy - 6), 3, bear);
    canvas.drawCircle(Offset(pos.dx + 6, pos.dy - 6), 3, bear);

    final Paint patch = Paint()..color = const Color(0xFFFFFDE7);
    canvas.drawCircle(Offset(pos.dx - 3, pos.dy - 1), 3.0, patch);
    canvas.drawCircle(Offset(pos.dx + 3, pos.dy - 1), 3.0, patch);

    canvas.drawCircle(Offset(pos.dx - 3, pos.dy - 1), 1.2, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(pos.dx + 3, pos.dy - 1), 1.2, Paint()..color = Colors.black);
  }

  void _drawCondor(Canvas canvas, Offset pos) {
    final Paint condor = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    final Path wings = Path()
      ..moveTo(pos.dx - 15, pos.dy - 4)
      ..quadraticBezierTo(pos.dx - 5, pos.dy + 4, pos.dx, pos.dy)
      ..quadraticBezierTo(pos.dx + 5, pos.dy + 4, pos.dx + 15, pos.dy - 4);
    canvas.drawPath(wings, condor);
    canvas.drawCircle(Offset(pos.dx, pos.dy), 2.2, Paint()..color = Colors.white);
  }

  void _drawRealisticSeaTurtle(Canvas canvas, Offset pos) {
    // Aleteo natatorio sincrónico y elegante (remada marina suave)
    final double strokePhase = math.sin(anim * 2 * math.pi);
    final double flipperAngle = strokePhase * 0.35; // Ángulo de batida hidrodinámico

    final Paint skin = Paint()..color = const Color(0xFF1B4332);
    final Paint skinHighlight = Paint()..color = const Color(0xFF2D6A4F);

    // 1. ALETAS TRASERAS (Timón de navegación)
    final double rearAngle = -strokePhase * 0.20;
    canvas.save();
    canvas.translate(pos.dx - 10, pos.dy - 6);
    canvas.rotate(rearAngle);
    final Path rearLeft = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(-7, -4, -10, -2)
      ..quadraticBezierTo(-6, 2, 0, 1)
      ..close();
    canvas.drawPath(rearLeft, skin);
    canvas.restore();

    canvas.save();
    canvas.translate(pos.dx - 10, pos.dy + 6);
    canvas.rotate(-rearAngle);
    final Path rearRight = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(-7, 4, -10, 2)
      ..quadraticBezierTo(-6, -2, 0, -1)
      ..close();
    canvas.drawPath(rearRight, skin);
    canvas.restore();

    // 2. ALETAS DELANTERAS (Grandes remos curvados hidrodinámicos)
    // Aleta delantera izquierda (superior)
    canvas.save();
    canvas.translate(pos.dx + 6, pos.dy - 7);
    canvas.rotate(-0.5 + flipperAngle);
    final Path flipperLeft = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(4, -12, 14, -15)
      ..quadraticBezierTo(8, -8, 2, -1)
      ..close();
    canvas.drawPath(flipperLeft, skin);
    canvas.drawPath(flipperLeft, skinHighlight..style = PaintingStyle.stroke..strokeWidth = 1.0);
    canvas.restore();

    // Aleta delantera derecha (inferior)
    canvas.save();
    canvas.translate(pos.dx + 6, pos.dy + 7);
    canvas.rotate(0.5 - flipperAngle);
    final Path flipperRight = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(4, 12, 14, 15)
      ..quadraticBezierTo(8, 8, 2, 1)
      ..close();
    canvas.drawPath(flipperRight, skin);
    canvas.drawPath(flipperRight, skinHighlight..style = PaintingStyle.stroke..strokeWidth = 1.0);
    canvas.restore();

    // 3. CAPARAZÓN HIDRODINÁMICO OVALADO (Tonos verde oliva y ámbar marino)
    final Paint shellBase = Paint()..color = const Color(0xFF2E7D5B);
    canvas.drawOval(Rect.fromCenter(center: pos, width: 25, height: 18), shellBase);

    // Escudos córneos del caparazón (Scutes)
    final Paint scutePaint = Paint()
      ..color = const Color(0xFF1B4332)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawOval(Rect.fromCenter(center: pos, width: 17, height: 11), scutePaint);
    canvas.drawOval(Rect.fromCenter(center: pos, width: 8, height: 6), scutePaint);
    canvas.drawLine(Offset(pos.dx - 8, pos.dy), Offset(pos.dx + 8, pos.dy), scutePaint);

    // Brillo sutil sobre el caparazón húmedo
    final Paint shellShine = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(pos.dx - 1, pos.dy - 1), width: 21, height: 13),
      -math.pi * 0.8,
      math.pi * 0.6,
      false,
      shellShine,
    );

    // 4. CABEZA Y CUELLO
    final double headBob = strokePhase * 1.0;
    final Offset headPos = Offset(pos.dx + 14 + headBob, pos.dy);
    canvas.drawOval(Rect.fromCenter(center: headPos, width: 8, height: 6), skin);
    // Ojos
    canvas.drawCircle(Offset(headPos.dx + 1.5, headPos.dy - 2), 1.2, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(headPos.dx + 1.5, headPos.dy + 2), 1.2, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(headPos.dx + 1.8, headPos.dy - 2.3), 0.5, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(headPos.dx + 1.8, headPos.dy + 1.7), 0.5, Paint()..color = Colors.white);
  }

  void _drawRealisticTapir(Canvas canvas, Offset pos) {
    // Danta o Tapir amazónico (Tapirus terrestris)
    // Silueta robusta, cresta sagital / crin oscura, probóscide (trompa móvil) característica
    final Paint bodyColor = Paint()..color = const Color(0xFF2E241E);
    final Paint underbelly = Paint()..color = const Color(0xFF3D322A);
    final Paint highlight = Paint()..color = const Color(0xFF4A3E35);

    // 1. Patas firmes sobre el lodo
    final Paint legPaint = Paint()
      ..color = const Color(0xFF221A15)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(pos.dx - 6, pos.dy + 4), Offset(pos.dx - 6, pos.dy + 12), legPaint);
    canvas.drawLine(Offset(pos.dx - 2, pos.dy + 4), Offset(pos.dx - 2, pos.dy + 12), legPaint);
    canvas.drawLine(Offset(pos.dx + 4, pos.dy + 4), Offset(pos.dx + 4, pos.dy + 12), legPaint);
    canvas.drawLine(Offset(pos.dx + 8, pos.dy + 4), Offset(pos.dx + 8, pos.dy + 12), legPaint);

    // 2. Cuerpo robusto piriforme
    canvas.drawOval(Rect.fromCenter(center: pos, width: 22, height: 14), bodyColor);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 2, pos.dy + 1), width: 14, height: 9), underbelly);

    // 3. Cuello robusto y cresta dorsal / crin corta
    final Path crest = Path()
      ..moveTo(pos.dx + 3, pos.dy - 6)
      ..lineTo(pos.dx + 10, pos.dy - 9)
      ..lineTo(pos.dx + 13, pos.dy - 5)
      ..close();
    canvas.drawPath(crest, Paint()..color = const Color(0xFF1B1410));

    // 4. Cabeza con trompa móvil (probóscide caída hacia el agua)
    final Offset headPos = Offset(pos.dx + 11, pos.dy - 3);
    canvas.drawOval(Rect.fromCenter(center: headPos, width: 9, height: 7), bodyColor);

    // Probóscide / trompa prensil
    final Path snout = Path()
      ..moveTo(headPos.dx + 3, headPos.dy - 2)
      ..quadraticBezierTo(headPos.dx + 7, headPos.dy + 1, headPos.dx + 7, headPos.dy + 4)
      ..lineTo(headPos.dx + 5, headPos.dy + 4)
      ..quadraticBezierTo(headPos.dx + 5, headPos.dy + 1, headPos.dx + 2, headPos.dy + 1)
      ..close();
    canvas.drawPath(snout, Paint()..color = const Color(0xFF1F1813));

    // Orejas redondeadas con punta blanca distintiva de la danta
    final Offset earPos = Offset(headPos.dx - 2, headPos.dy - 5);
    canvas.drawCircle(earPos, 2.2, Paint()..color = const Color(0xFF221A15));
    canvas.drawCircle(Offset(earPos.dx, earPos.dy - 1), 0.9, Paint()..color = const Color(0xFFE0E0E0));

    // Ojo pequeño
    canvas.drawCircle(Offset(headPos.dx + 1, headPos.dy - 1.5), 1.0, Paint()..color = Colors.black);
  }

  void _drawTapir(Canvas canvas, Offset pos) {
    _drawRealisticTapir(canvas, pos);
  }

  void _drawCrabAnimated(Canvas canvas, Offset pos) {
    final Paint crab = Paint()..color = const Color(0xFF0288D1);
    canvas.drawOval(Rect.fromCenter(center: pos, width: 16, height: 10), crab);

    // ANIMACIÓN: Tenazas subiendo y bajando alternadamente
    final double claw1 = math.sin(anim * 4 * math.pi) * 2.0;
    final double claw2 = -claw1;
    final Paint claw = Paint()..color = const Color(0xFFE53935);
    canvas.drawCircle(Offset(pos.dx - 9, pos.dy - 4 + claw1), 3.5, claw);
    canvas.drawCircle(Offset(pos.dx + 9, pos.dy - 4 + claw2), 3.5, claw);

    canvas.drawCircle(Offset(pos.dx - 3, pos.dy - 5), 1.5, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(pos.dx + 3, pos.dy - 5), 1.5, Paint()..color = Colors.black);
  }

  void _drawIguanaAnimated(Canvas canvas, Offset pos) {
    final Paint iguana = Paint()..color = const Color(0xFF7CB342);
    canvas.drawOval(Rect.fromCenter(center: pos, width: 18, height: 7), iguana);

    final Paint crest = Paint()..color = const Color(0xFF558B2F)..strokeWidth = 1.2;
    for (int i = -6; i <= 6; i += 3) {
      canvas.drawLine(Offset(pos.dx + i, pos.dy - 3), Offset(pos.dx + i, pos.dy - 6), crest);
    }

    // ANIMACIÓN: Cola ondulando
    final double tailWag = math.sin(anim * 2 * math.pi) * 2.5;
    final Paint tail = Paint()
      ..color = const Color(0xFF689F38)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx - 14, pos.dy + 3 + tailWag), tail);
  }

  void _drawChiguiro(Canvas canvas, Offset pos, {bool isSmall = false}) {
    final double s = isSmall ? 0.65 : 1.0;
    final Paint capybara = Paint()..color = const Color(0xFF795548);
    canvas.drawOval(Rect.fromCenter(center: pos, width: 22 * s, height: 13 * s), capybara);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(pos.dx + 7 * s, pos.dy - 8 * s, 9 * s, 10 * s),
        Radius.circular(3 * s),
      ),
      capybara,
    );
    canvas.drawCircle(Offset(pos.dx + 8 * s, pos.dy - 8 * s), 1.5 * s, Paint()..color = const Color(0xFF4E342E));
    canvas.drawCircle(Offset(pos.dx + 12 * s, pos.dy - 5 * s), 1.2 * s, Paint()..color = Colors.black);
  }

  void _drawButterfly(Canvas canvas, Offset pos) {
    final Paint butterfly = Paint()..color = AppColors.gold;
    canvas.drawCircle(Offset(pos.dx - 2, pos.dy - 2), 2.2, butterfly);
    canvas.drawCircle(Offset(pos.dx + 2, pos.dy - 2), 2.2, butterfly);
    canvas.drawCircle(Offset(pos.dx, pos.dy), 1.2, Paint()..color = Colors.black);
  }

  void _drawMorphoButterflyAnimated(Canvas canvas, Offset pos) {
    // ANIMACIÓN: Aleteo de mariposa azul morpho
    final double wingSpan = (math.cos(anim * 4 * math.pi).abs() * 2.2) + 0.8;
    final Paint wing = Paint()..color = const Color(0xFF00B4D8);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx - 3, pos.dy - 2), width: wingSpan * 2, height: 5), wing);
    canvas.drawOval(Rect.fromCenter(center: Offset(pos.dx + 3, pos.dy - 2), width: wingSpan * 2, height: 5), wing);
    canvas.drawCircle(Offset(pos.dx, pos.dy), 1.2, Paint()..color = Colors.black);
  }

  void _drawCorocora(Canvas canvas, Offset pos) {
    final Paint redBird = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final Path wings = Path()
      ..moveTo(pos.dx - 7, pos.dy - 2)
      ..quadraticBezierTo(pos.dx, pos.dy + 2, pos.dx + 7, pos.dy - 2);
    canvas.drawPath(wings, redBird);
  }

  void _drawHeron(Canvas canvas, Offset pos) {
    final Paint heron = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(pos.dx, pos.dy - 8), 2.5, heron);
    canvas.drawOval(Rect.fromCenter(center: pos, width: 6, height: 10), heron);
    canvas.drawLine(Offset(pos.dx + 1, pos.dy - 8), Offset(pos.dx + 6, pos.dy - 7), Paint()..color = const Color(0xFFFFB703)..strokeWidth = 1.2);
    canvas.drawLine(Offset(pos.dx, pos.dy + 4), Offset(pos.dx, pos.dy + 12), Paint()..color = const Color(0xFF455A64)..strokeWidth = 1.0);
  }

  void _drawCoralBranch(Canvas canvas, Offset pos, Color color, double sway) {
    final Paint coral = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx + sway, pos.dy - 12), coral);
    canvas.drawLine(Offset(pos.dx, pos.dy - 8), Offset(pos.dx - 6 + sway, pos.dy - 14), coral..strokeWidth = 2.2);
    canvas.drawLine(Offset(pos.dx, pos.dy - 6), Offset(pos.dx + 6 + sway, pos.dy - 12), coral..strokeWidth = 2.2);
  }

  void _drawCoralBrain(Canvas canvas, Offset pos, Color color) {
    canvas.drawCircle(pos, 8, Paint()..color = color);
    canvas.drawCircle(pos, 5, Paint()..color = Colors.white.withOpacity(0.3));
  }

  void _drawAlgae(Canvas canvas, Offset pos, double sway) {
    final Paint algae = Paint()
      ..color = const Color(0xFF00796B)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(pos, Offset(pos.dx - 2 + sway, pos.dy - 12), algae);
    canvas.drawLine(pos, Offset(pos.dx + 3 + sway, pos.dy - 10), algae);
  }

  void _drawLittleFish(Canvas canvas, Offset pos, Color color) {
    final Paint fish = Paint()..color = color;
    canvas.drawOval(Rect.fromCenter(center: pos, width: 7, height: 4), fish);
    final Path tail = Path()
      ..moveTo(pos.dx - 3, pos.dy)
      ..lineTo(pos.dx - 6, pos.dy - 2.5)
      ..lineTo(pos.dx - 6, pos.dy + 2.5)
      ..close();
    canvas.drawPath(tail, fish);
  }

  void _drawBubble(Canvas canvas, Offset pos, double radius) {
    canvas.drawCircle(pos, radius, Paint()..color = Colors.white.withOpacity(0.40));
    canvas.drawCircle(pos, radius, Paint()..color = Colors.white.withOpacity(0.70)..style = PaintingStyle.stroke..strokeWidth = 1.0);
    canvas.drawCircle(Offset(pos.dx - radius * 0.3, pos.dy - radius * 0.3), radius * 0.25, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant EnhancedIsometricIslandPainter oldDelegate) =>
      oldDelegate.ecosystem.id != ecosystem.id ||
      oldDelegate.animation != animation ||
      oldDelegate.animationValue != animationValue;
}
