import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/xp_bar.dart';
import '../../domain/models/ecosystem_model.dart';
import '../../domain/entities/ecosystem.dart';
import '../../../exploration/presentation/controllers/lesson_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../profile/presentation/controllers/child_profile_controller.dart';
import '../controllers/ecosystem_controller.dart';
import '../registry/ecosystem_visual_registry.dart';
import '../widgets/ecosystem_carousel_card.dart';

class EcosystemSelectorScreen extends StatefulWidget {
  final Function(EcosystemModel) onExploreEcosystem;
  final VoidCallback onOpenProfile;
  final VoidCallback? onOpenParentDashboard;
  final VoidCallback? onLogout;
  final int? initialEcosystemId;
  final String? initialEcosystemCode;
  final ValueChanged<EcosystemModel>? onEcosystemChanged;

  const EcosystemSelectorScreen({
    super.key,
    required this.onExploreEcosystem,
    required this.onOpenProfile,
    this.onOpenParentDashboard,
    this.onLogout,
    this.initialEcosystemId,
    this.initialEcosystemCode,
    this.onEcosystemChanged,
  });

  @override
  State<EcosystemSelectorScreen> createState() => _EcosystemSelectorScreenState();
}

class _EcosystemSelectorScreenState extends State<EcosystemSelectorScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _hasSyncedInitialPage = false;

  int _resolveTargetIndex(List<Ecosystem> ecosystems, EcosystemController controller) {
    if (widget.initialEcosystemId != null) {
      final idx = ecosystems.indexWhere((e) => e.id == widget.initialEcosystemId);
      if (idx != -1) return idx;
    }
    if (widget.initialEcosystemCode != null) {
      final code = widget.initialEcosystemCode!.toUpperCase();
      final idx = ecosystems.indexWhere((e) => e.code.toUpperCase() == code);
      if (idx != -1) return idx;
    }
    final controllerIdx = controller.state.selectedIndex;
    if (controllerIdx >= 0 && controllerIdx < ecosystems.length) {
      return controllerIdx;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    try {
      final controller = context.read<EcosystemController>();
      final ecosystems = controller.state.ecosystems;
      if (ecosystems.isNotEmpty) {
        _currentIndex = _resolveTargetIndex(ecosystems, controller);
        _hasSyncedInitialPage = true;
      }
    } catch (_) {}

    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.82,
    );

    // Cargar ecosistemas y progreso de lecciones al entrar en la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<EcosystemController>().loadEcosystems();
        try {
          context.read<LessonController>().loadUserProgress();
        } catch (_) {}
        try {
          context.read<ChildProfileController>().loadProfile();
        } catch (_) {}
      }
    });
  }

  @override
  void didUpdateWidget(covariant EcosystemSelectorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.initialEcosystemId != null && widget.initialEcosystemId != oldWidget.initialEcosystemId) ||
        (widget.initialEcosystemCode != null && widget.initialEcosystemCode != oldWidget.initialEcosystemCode)) {
      try {
        final controller = context.read<EcosystemController>();
        final ecosystems = controller.state.ecosystems;
        if (ecosystems.isNotEmpty) {
          final targetIndex = _resolveTargetIndex(ecosystems, controller);
          if (targetIndex != _currentIndex) {
            setState(() {
              _currentIndex = targetIndex;
            });
            if (_pageController.hasClients) {
              _pageController.jumpToPage(targetIndex);
            }
          }
        }
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<EcosystemController>();
    final state = controller.state;
    LessonController? lessonController;
    try {
      lessonController = context.watch<LessonController>();
    } catch (_) {
      lessonController = null;
    }

    // Estado 1: Cargando
    if (state.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.pastelGreenBg,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const Spacer(),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.forestGreen),
                strokeWidth: 4,
              ),
              const SizedBox(height: AppDimensions.space16),
              Text(
                'Cargando mundos de Guardianes...',
                style: AppTypography.subheading.copyWith(color: AppColors.forestGreen),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    }

    // Estado 2: Error
    if (state.isError) {
      return Scaffold(
        backgroundColor: AppColors.pastelGreenBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space24),
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.space24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                    boxShadow: const [
                      BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_off_rounded, size: 64, color: AppColors.coral),
                      const SizedBox(height: AppDimensions.space16),
                      Text(
                        '¡Ups! No pudimos conectar con los ecosistemas',
                        style: AppTypography.headingMedium.copyWith(color: AppColors.darkText),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.space8),
                      Text(
                        state.errorMessage ?? 'Ocurrió un error inesperado al conectar con el servidor.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.darkGrey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.space24),
                      AppButton(
                        label: 'REINTENTAR',
                        icon: Icons.refresh_rounded,
                        onPressed: () => controller.loadEcosystems(forceRefresh: true),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
    }

    // Estado 3: Lista Vacía
    if (state.isEmpty || state.ecosystems.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.pastelGreenBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.space24),
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.space24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.nature_people_rounded, size: 64, color: AppColors.mediumGrey),
                      const SizedBox(height: AppDimensions.space16),
                      Text(
                        'Aún no hay ecosistemas disponibles',
                        style: AppTypography.headingMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.space8),
                      Text(
                        'Pronto nuevos mundos estarán listos para ser explorados.',
                        style: AppTypography.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.space24),
                      AppButton(
                        label: 'ACTUALIZAR',
                        icon: Icons.refresh_rounded,
                        onPressed: () => controller.loadEcosystems(forceRefresh: true),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
    }

    // Estado 4: Éxito con resultados reales
    final ecosystems = state.ecosystems;
    if (!_hasSyncedInitialPage && ecosystems.isNotEmpty) {
      _hasSyncedInitialPage = true;
      final targetIndex = _resolveTargetIndex(ecosystems, controller);
      if (targetIndex != _currentIndex) {
        _currentIndex = targetIndex;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _pageController.hasClients) {
            _pageController.jumpToPage(targetIndex);
          }
        });
      }
    }

    if (_currentIndex >= ecosystems.length) {
      _currentIndex = 0;
    }

    if (lessonController != null) {
      for (final eco in ecosystems) {
        if (eco.isActive) {
          lessonController.preloadLessonsForEcosystem(eco.id);
        }
      }
    }

    final currentEcosystem = ecosystems[_currentIndex];
    final currentProgress = lessonController?.getProgressForEcosystem(currentEcosystem.id) ?? 0.0;
    final activeEco = EcosystemVisualRegistry.toUiModel(
      currentEcosystem,
      isLocked: !currentEcosystem.isActive,
      progress: currentProgress,
    );

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
              _buildHeader(),

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
                  itemCount: ecosystems.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    controller.selectIndex(index);
                    if (widget.onEcosystemChanged != null && index >= 0 && index < ecosystems.length) {
                      final ecoEntity = ecosystems[index];
                      final ecoProgress = lessonController?.getProgressForEcosystem(ecoEntity.id) ?? 0.0;
                      final ecoModel = EcosystemVisualRegistry.toUiModel(
                        ecoEntity,
                        isLocked: !ecoEntity.isActive,
                        progress: ecoProgress,
                      );
                      widget.onEcosystemChanged!(ecoModel);
                    }
                  },
                  itemBuilder: (context, index) {
                    final ecoEntity = ecosystems[index];
                    final ecoProgress = lessonController?.getProgressForEcosystem(ecoEntity.id) ?? 0.0;
                    final ecoModel = EcosystemVisualRegistry.toUiModel(
                      ecoEntity,
                      isLocked: !ecoEntity.isActive,
                      progress: ecoProgress,
                    );
                    final isSelected = index == _currentIndex;

                    return EcosystemCarouselCard(
                      ecosystem: ecoModel,
                      isSelected: isSelected,
                      onTap: () {
                        if (!isSelected) {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                          );
                        } else {
                          if (!ecoModel.isLocked) {
                            widget.onExploreEcosystem(ecoModel);
                          }
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
                  ecosystems.length,
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

              // 3. Botón Principal: EXPLORAR
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space32,
                  vertical: AppDimensions.space16,
                ),
                child: AppButton(
                  label: activeEco.isLocked ? 'BLOQUEADO' : 'EXPLORAR',
                  icon: activeEco.isLocked ? Icons.lock_rounded : Icons.explore_rounded,
                  variant: activeEco.isLocked ? AppButtonVariant.outline : AppButtonVariant.primary,
                  customColor: activeEco.primaryColor,
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

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Cerrar sesión?'),
        content: const Text('¿Deseas salir de tu aventura de Guardián? Tu progreso quedará guardado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Seguir jugando', style: TextStyle(color: AppColors.darkGrey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coral,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (widget.onLogout != null) {
                widget.onLogout!();
              } else {
                try {
                  await context.read<AuthController>().logout();
                } catch (_) {}
              }
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    ChildProfileController? childProfile;
    try {
      childProfile = context.watch<ChildProfileController>();
    } catch (_) {
      childProfile = null;
    }

    final childName = childProfile?.childName ?? 'Explorador';
    final level = childProfile?.levelNumber ?? 1;
    final currentXp = childProfile?.totalXp ?? 0;
    final targetXp = childProfile?.nextLevelRequiredXp ?? 500;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: Row(
        children: [
          Expanded(
            child: FloatingGameHeader(
              childName: childName,
              level: level,
              currentXp: currentXp,
              targetXp: targetXp,
              avatarConfig: childProfile?.avatarConfig,
              onProfileTap: widget.onOpenProfile,
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              boxShadow: const [
                BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 3)),
              ],
              border: Border.all(color: AppColors.coral.withOpacity(0.2), width: 1.5),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout_rounded, color: AppColors.coral),
              tooltip: 'Cerrar sesión',
              onPressed: () => _confirmLogout(context),
            ),
          ),
        ],
      ),
    );
  }
}
