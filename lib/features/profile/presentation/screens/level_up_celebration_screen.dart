import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/models/avatar_config.dart';
import '../widgets/child_avatar_widget.dart';

/// Pantalla y modal de celebración cuando un niño sube de nivel en "Guardianes del Planeta".
class LevelUpCelebrationScreen extends StatefulWidget {
  final int newLevel;
  final int previousLevel;
  final String childName;
  final AvatarConfig avatarConfig;
  final VoidCallback onContinue;
  final VoidCallback? onOpenProfile;

  const LevelUpCelebrationScreen({
    super.key,
    required this.newLevel,
    this.previousLevel = 1,
    this.childName = 'Guardián',
    required this.avatarConfig,
    required this.onContinue,
    this.onOpenProfile,
  });

  static Future<void> show({
    required BuildContext context,
    required int newLevel,
    int previousLevel = 1,
    String childName = 'Guardián',
    required AvatarConfig avatarConfig,
    required VoidCallback onContinue,
    VoidCallback? onOpenProfile,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack).value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
      pageBuilder: (ctx, anim1, anim2) {
        return LevelUpCelebrationScreen(
          newLevel: newLevel,
          previousLevel: previousLevel,
          childName: childName,
          avatarConfig: avatarConfig,
          onContinue: () {
            Navigator.of(ctx).pop();
            onContinue();
          },
          onOpenProfile: onOpenProfile != null
              ? () {
                  Navigator.of(ctx).pop();
                  onOpenProfile();
                }
              : null,
        );
      },
    );
  }

  @override
  State<LevelUpCelebrationScreen> createState() => _LevelUpCelebrationScreenState();
}

class _LevelUpCelebrationScreenState extends State<LevelUpCelebrationScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late Animation<double> _glowAnimation;
  late Animation<double> _floatAnimation;

  static final List<_CelebrationParticle> _particles = List.generate(30, (i) {
    final colors = [
      AppColors.gold,
      AppColors.emerald,
      const Color(0xFF4FC3F7),
      const Color(0xFFFF8A80),
      Colors.white.withOpacity(0.85),
    ];
    return _CelebrationParticle(
      xRatio: ((i * 0.17 + 0.05) % 0.9) + 0.05,
      yRatio: (i / 30.0),
      size: 2.5 + (i % 4) * 1.2,
      speed: 0.5 + (i % 3) * 0.2, // Flotación muy suave y lenta
      swayFactor: 8.0 + (i % 5) * 3.0,
      phase: i * 0.7,
      color: colors[i % colors.length],
      isStar: i % 3 == 0,
    );
  });

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _glowAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  static const Map<int, String> _levelRanks = {
    1: 'Semilla Guardiana',
    2: 'Explorador del Agua',
    3: 'Guardián de los Mares',
    4: 'Protector de la Selva',
    5: 'Defensor del Planeta',
    6: 'Maestro Guardián',
  };

  static const Map<int, String> _levelLore = {
    1: 'Has dado tus primeros pasos sembrando conciencia ambiental.',
    2: '¡Proteges ríos, páramos y cuencas hídricas de toda Colombia!',
    3: '¡Los arrecifes de coral y especies marinas cuentan con tu sabiduría!',
    4: '¡Custodias las selvas amazónicas, su flora y fauna silvestre!',
    5: '¡Eres un referente máximo en la preservación de nuestro planeta!',
    6: '¡Honor supremo! Eres una leyenda viviente de la conservación planetaria.',
  };

  static const Map<int, String> _levelRewardItem = {
    1: 'Gorra de Explorador',
    2: 'Marco de Agua Pura + Corona de Hojas',
    3: 'Avatar Guardián del Mar + Gafas de Aventura',
    4: 'Fondo Selva Profunda + Bufanda Andina',
    5: 'Corona Solar Radiante',
    6: 'Medalla de Honor Planetario',
  };

  @override
  Widget build(BuildContext context) {
    final rankTitle = _levelRanks[widget.newLevel] ?? 'Gran Guardián';
    final rankLore = _levelLore[widget.newLevel] ?? 'Tu valentía inspira a proteger el equilibrio del mundo.';
    final rewardItem = _levelRewardItem[widget.newLevel] ?? 'Recompensa Exclusiva';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo decorativo con estrellas y partículas festivas lentas y relajantes
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                painter: _ConfettiParticlesPainter(
                  animationProgress: _particleController.value,
                  particles: _particles,
                ),
              );
            },
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space24,
                  vertical: AppDimensions.space20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Badge superior
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withOpacity(0.5),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.stars_rounded, color: AppColors.darkText, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '¡NUEVO RANGO ALCANZADO!',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppColors.darkText,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space16),

                    // Título principal con impacto festivo
                    const Text(
                      '¡SUBISTE DE NIVEL!',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(color: Color(0x99000000), offset: Offset(0, 4), blurRadius: 10),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppDimensions.space8),

                    // Indicador de transición de nivel: Nv. X ➔ Nv. Y
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        border: Border.all(color: AppColors.white.withOpacity(0.4), width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Nivel ${widget.previousLevel}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white.withOpacity(0.8),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(Icons.arrow_forward_rounded, color: AppColors.gold, size: 18),
                          ),
                          Text(
                            'Nivel ${widget.newLevel}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space24),

                    // Avatar animado con halo solar radiante
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Resplandor exterior pulsante
                              Container(
                                width: 150 * _glowAnimation.value,
                                height: 150 * _glowAnimation.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gold.withOpacity(0.4),
                                      blurRadius: 35,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),

                              // Anillo decorativo dorado
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.gold, width: 4),
                                ),
                              ),

                              // Avatar personalizado del niño
                              ChildAvatarWidget(
                                config: widget.avatarConfig,
                                size: 124,
                                borderWidth: 4,
                                borderColor: AppColors.white,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppDimensions.space24),

                    // Tarjeta de Rango Guardián
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.space20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                        boxShadow: AppShadows.card,
                        border: Border.all(color: AppColors.gold, width: 2),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.military_tech_rounded, color: AppColors.gold, size: 28),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  rankTitle,
                                  style: AppTypography.headingLarge.copyWith(
                                    color: AppColors.forestGreenDark,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            rankLore,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.darkGrey,
                              height: 1.35,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1, color: AppColors.pastelGreen),
                          const SizedBox(height: 14),

                          // Fila de recompensas desbloqueadas
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF8E1),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.gold, width: 1),
                                ),
                                child: const Icon(Icons.card_giftcard_rounded, color: AppColors.goldDark, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '¡Nuevo Elemento Desbloqueado!',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.emerald,
                                      ),
                                    ),
                                    Text(
                                      rewardItem,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.darkText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.pastelGreenBg,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.star_rounded, size: 14, color: AppColors.goldDark),
                                    SizedBox(width: 4),
                                    Text(
                                      '+100 XP',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                        color: AppColors.forestGreenDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimensions.space24),

                    // Botón principal continuar
                    AppButton(
                      label: '¡CONTINUAR LA AVENTURA!',
                      icon: Icons.rocket_launch_rounded,
                      onPressed: widget.onContinue,
                    ),

                    if (widget.onOpenProfile != null) ...[
                      const SizedBox(height: AppDimensions.space12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.white,
                          side: const BorderSide(color: AppColors.white, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        icon: const Icon(Icons.palette_rounded, size: 18),
                        label: const Text(
                          'Personalizar mi nuevo avatar',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        onPressed: widget.onOpenProfile,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modelo de partícula celebratoria pre-calculada para movimiento armónico y suave
class _CelebrationParticle {
  final double xRatio;
  final double yRatio;
  final double size;
  final double speed;
  final double swayFactor;
  final double phase;
  final Color color;
  final bool isStar;

  const _CelebrationParticle({
    required this.xRatio,
    required this.yRatio,
    required this.size,
    required this.speed,
    required this.swayFactor,
    required this.phase,
    required this.color,
    required this.isStar,
  });
}

/// Pintor para confeti y estrellas flotantes con animación pausada y placentera a la vista
class _ConfettiParticlesPainter extends CustomPainter {
  final double animationProgress;
  final List<_CelebrationParticle> particles;

  _ConfettiParticlesPainter({
    required this.animationProgress,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final double progress = (animationProgress * p.speed + p.yRatio) % 1.0;
      final double y = progress * size.height;
      final double x = (p.xRatio * size.width + math.sin(progress * 2 * math.pi + p.phase) * p.swayFactor)
          .clamp(8.0, size.width - 8.0);

      final paint = Paint()..color = p.color;
      if (p.isStar) {
        _drawStar(canvas, Offset(x, y), p.size * 1.5, paint);
      } else {
        canvas.drawCircle(Offset(x, y), p.size, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - size)
      ..lineTo(center.dx + size * 0.3, center.dy - size * 0.3)
      ..lineTo(center.dx + size, center.dy)
      ..lineTo(center.dx + size * 0.3, center.dy + size * 0.3)
      ..lineTo(center.dx, center.dy + size)
      ..lineTo(center.dx - size * 0.3, center.dy + size * 0.3)
      ..lineTo(center.dx - size, center.dy)
      ..lineTo(center.dx - size * 0.3, center.dy - size * 0.3)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiParticlesPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress;
}
