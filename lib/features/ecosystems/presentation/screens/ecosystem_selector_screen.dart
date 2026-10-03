import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/xp_bar.dart';
import '../../domain/models/ecosystem_model.dart';
import '../../data/ecosystem_mock_data.dart';
import '../widgets/ecosystem_carousel_card.dart';

class EcosystemSelectorScreen extends StatefulWidget {
  final Function(EcosystemModel) onExploreEcosystem;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenParentDashboard;

  const EcosystemSelectorScreen({
    super.key,
    required this.onExploreEcosystem,
    required this.onOpenProfile,
    required this.onOpenParentDashboard,
  });

  @override
  State<EcosystemSelectorScreen> createState() => _EcosystemSelectorScreenState();
}

class _EcosystemSelectorScreenState extends State<EcosystemSelectorScreen> {
  late PageController _pageController;
  final List<EcosystemModel> _ecosystems = EcosystemMockData.ecosystems;
  int _currentIndex = 1; // 1 = Bosque Andino (inicialmente activo)

  @override
  void initState() {
    super.initState();
    // viewportFraction 0.82 para mostrar parcialmente las islas laterales
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.82,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeEco = _ecosystems[_currentIndex];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: activeEco.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Header Flotante Superior
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FloatingGameHeader(
                        childName: 'Andrés',
                        level: 5,
                        currentXp: 1250,
                        targetXp: 2000,
                        onProfileTap: widget.onOpenProfile,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space8),
                    // Botón para acceder al Panel Familiar de Padres
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        boxShadow: const [
                          BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3)),
                        ],
                        border: Border.all(color: AppColors.pastelGreen, width: 1.5),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.family_restroom_rounded, color: AppColors.forestGreen),
                        tooltip: 'Panel Familiar (Padres)',
                        onPressed: widget.onOpenParentDashboard,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.space8),

              // Título de bienvenida
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
                child: Text(
                  '¿Qué mundo exploraremos hoy?',
                  style: AppTypography.headingLarge.copyWith(
                    color: AppColors.forestGreenDark,
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.8),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // 2. Carrusel Horizontal con Snap Scroll
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _ecosystems.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final eco = _ecosystems[index];
                    final isSelected = index == _currentIndex;

                    return EcosystemCarouselCard(
                      ecosystem: eco,
                      isSelected: isSelected,
                      onTap: () {
                        if (!isSelected) {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                          );
                        }
                      },
                    );
                  },
                ),
              ),

              // Indicador de Puntos (Dots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _ecosystems.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentIndex ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentIndex
                          ? activeEco.primaryColor
                          : AppColors.darkGrey.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.space16),

              // 3. Botón Principal: EXPLORAR (Grande, Redondeado, con icono de brújula)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space32,
                  vertical: AppDimensions.space16,
                ),
                child: AppButton(
                  label: activeEco.isLocked ? 'BLOQUEADO' : 'EXPLORAR',
                  icon: activeEco.isLocked ? Icons.lock_rounded : Icons.explore_rounded,
                  variant: activeEco.isLocked ? AppButtonVariant.outline : AppButtonVariant.primary,
                  onPressed: activeEco.isLocked
                      ? null
                      : () => widget.onExploreEcosystem(activeEco),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
