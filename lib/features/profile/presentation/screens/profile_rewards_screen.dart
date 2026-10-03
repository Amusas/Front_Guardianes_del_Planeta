import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/badge_model.dart';
import '../../data/badges_mock_data.dart';
import '../widgets/badge_card.dart';
import '../widgets/badge_detail_modal.dart';

class ProfileRewardsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ProfileRewardsScreen({super.key, required this.onBack});

  @override
  State<ProfileRewardsScreen> createState() => _ProfileRewardsScreenState();
}

class _ProfileRewardsScreenState extends State<ProfileRewardsScreen> {
  final List<BadgeModel> _badges = BadgesMockData.badges;
  BadgeModel? _selectedBadge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pastelGreenBg,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppDimensions.space12),

                  // Header con botón volver y título
                  Row(
                    children: [
                      InkWell(
                        onTap: widget.onBack,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: AppShadows.small,
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: AppColors.forestGreen),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Mi Perfil de Guardián',
                          style: AppTypography.headingMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 40), // Balance visual con el botón atrás
                    ],
                  ),

                  const SizedBox(height: AppDimensions.space20),

                  // 1. Avatar Grande con XP Progress Ring (65%)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Anillo de progreso de XP (Ring)
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: CircularProgressIndicator(
                          value: 0.65,
                          strokeWidth: 8.0,
                          backgroundColor: AppColors.lightGrey,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                          strokeCap: StrokeCap.round,
                        ),
                      ),

                      // Avatar del niño
                      Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.emerald, AppColors.forestGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: AppColors.white, width: 4),
                          boxShadow: AppShadows.card,
                        ),
                        child: const Icon(
                          Icons.face_rounded,
                          size: 68,
                          color: AppColors.white,
                        ),
                      ),

                      // Badge de porcentaje 65%
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                            border: Border.all(color: AppColors.white, width: 2),
                            boxShadow: AppShadows.small,
                          ),
                          child: const Text(
                            '65%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.darkText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.space16),

                  // Nivel y Título de aventurero
                  const Text(
                    'Nivel 5',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.forestGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Text(
                    'Explorador Curioso',
                    style: AppTypography.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1,250 / 2,000 XP para Nivel 6',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space12),

                  // Botón Personalizar avatar
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.forestGreen,
                      side: const BorderSide(color: AppColors.forestGreen, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    ),
                    icon: const Icon(Icons.palette_rounded, size: 18),
                    label: const Text(
                      'Personalizar avatar',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onPressed: () {},
                  ),

                  const SizedBox(height: AppDimensions.space24),

                  // 2. Tres Tarjetas Pequeñas de Estadísticas (Números prominentes)
                  Row(
                    children: [
                      _buildStatCard(
                        title: 'XP Total',
                        value: '1,250',
                        icon: Icons.star_rounded,
                        accentColor: AppColors.goldDark,
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      _buildStatCard(
                        title: 'Lecciones',
                        value: '24',
                        icon: Icons.menu_book_rounded,
                        accentColor: AppColors.forestGreen,
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      _buildStatCard(
                        title: 'Insignias',
                        value: '8',
                        icon: Icons.military_tech_rounded,
                        accentColor: AppColors.emerald,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.space32),

                  // 3. Grid de Insignias (2 Columnas)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mis Insignias',
                        style: AppTypography.headingLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.emerald.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        ),
                        child: const Text(
                          '4 / 6 Obtenidas',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.forestGreenDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.space16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: _badges.length,
                    itemBuilder: (context, index) {
                      final badge = _badges[index];
                      return BadgeCard(
                        badge: badge,
                        onTap: () {
                          setState(() {
                            _selectedBadge = badge;
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: AppDimensions.space40),
                ],
              ),
            ),
          ),

          // Modal de Detalle de Insignia
          if (_selectedBadge != null)
            Positioned.fill(
              child: BadgeDetailModal(
                badge: _selectedBadge!,
                onClose: () {
                  setState(() {
                    _selectedBadge = null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: accentColor),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: AppTypography.caption.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
