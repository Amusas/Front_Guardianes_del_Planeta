import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Ilustración vectorial interactiva del escenario ambiental "Río contaminado",
/// mostrando agua en movimiento, peces, residuos flotantes y orillas naturales.
class EducationalIllustration extends StatelessWidget {
  final bool isCleaned;

  const EducationalIllustration({
    super.key,
    this.isCleaned = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: AppShadows.card,
        border: Border.all(
          color: isCleaned ? AppColors.emerald : AppColors.turquoiseLight,
          width: 2.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge - 2),
        child: Stack(
          children: [
            // 1. Cielo y orilla
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                ),
              ),
            ),

            // 2. Colinas de fondo
            Positioned(
              top: 15,
              left: -20,
              right: -20,
              height: 70,
              child: CustomPaint(
                painter: _HillsPainter(),
              ),
            ),

            // 3. Río cristalino / contaminado
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 110,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isCleaned
                        ? [const Color(0xFF48CAE4), const Color(0xFF0077B6)]
                        : [const Color(0xFF5A7D7C), const Color(0xFF385756)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Peces nadando
                    Positioned(
                      top: 40,
                      left: 60,
                      child: Icon(
                        Icons.phishing_rounded,
                        color: isCleaned ? AppColors.gold : AppColors.gold.withOpacity(0.5),
                        size: 28,
                      ),
                    ),
                    Positioned(
                      top: 65,
                      right: 70,
                      child: Icon(
                        Icons.phishing_rounded,
                        color: isCleaned ? AppColors.white : AppColors.white.withOpacity(0.4),
                        size: 22,
                      ),
                    ),

                    // Residuos si no ha sido limpiado
                    if (!isCleaned) ...[
                      const Positioned(
                        top: 25,
                        left: 140,
                        child: Icon(Icons.delete_outline_rounded, color: Color(0xFFE63946), size: 26),
                      ),
                      const Positioned(
                        top: 45,
                        right: 130,
                        child: Icon(Icons.shopping_bag_outlined, color: Color(0xFFFFD166), size: 24),
                      ),
                      const Positioned(
                        top: 18,
                        right: 40,
                        child: Icon(Icons.water_damage_rounded, color: Color(0xFFE63946), size: 22),
                      ),
                    ],

                    // Efectos de agua limpia si está resuelto
                    if (isCleaned) ...[
                      const Positioned(
                        top: 20,
                        left: 140,
                        child: Icon(Icons.water_drop_rounded, color: AppColors.white, size: 24),
                      ),
                      const Positioned(
                        top: 35,
                        right: 120,
                        child: Icon(Icons.auto_awesome_rounded, color: AppColors.goldLight, size: 26),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // 4. Etiqueta del escenario ambiental
            Positioned(
              top: 10,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  boxShadow: AppShadows.small,
                ),
                child: Row(
                  children: [
                    Icon(
                      isCleaned ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                      size: 16,
                      color: isCleaned ? AppColors.emerald : AppColors.errorSoft,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isCleaned ? '¡Río Protegido y Limpio!' : 'Escenario: Río Contaminado',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint1 = Paint()..color = const Color(0xFF81C784);
    final Path path1 = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.1, size.width, size.height)
      ..close();
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
