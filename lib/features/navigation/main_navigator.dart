import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../ecosystems/domain/models/ecosystem_model.dart';
import '../ecosystems/presentation/screens/ecosystem_selector_screen.dart';
import '../exploration/presentation/screens/exploration_route_screen.dart';
import '../activity/presentation/screens/interactive_activity_screen.dart';
import '../profile/presentation/screens/profile_rewards_screen.dart';
import '../parent_dashboard/presentation/screens/parent_dashboard_screen.dart';

enum ActiveAppScreen {
  ecosystems,
  explorationRoute,
  interactiveActivity,
  profileRewards,
  parentDashboard,
}

/// Controlador de navegación interactivo para "Guardianes del Planeta".
/// Permite tanto el flujo natural de juego gamificado como la selección directa
/// de las 5 pantallas para revisión y pruebas de UI/UX.
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  ActiveAppScreen _currentScreen = ActiveAppScreen.ecosystems;
  EcosystemModel? _selectedEcosystem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pantalla actual activa con animación de transición fluida
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _buildCurrentScreen(),
          ),

          // Barra flotante rápida de inspección de pantallas (para pruebas y prototipado)
          Positioned(
            bottom: 12,
            right: 12,
            child: _buildQuickScreenSwitcher(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case ActiveAppScreen.ecosystems:
        return EcosystemSelectorScreen(
          key: const ValueKey('screen_ecosystems'),
          onExploreEcosystem: (eco) {
            setState(() {
              _selectedEcosystem = eco;
              _currentScreen = ActiveAppScreen.explorationRoute;
            });
          },
          onOpenProfile: () {
            setState(() {
              _currentScreen = ActiveAppScreen.profileRewards;
            });
          },
          onOpenParentDashboard: () {
            setState(() {
              _currentScreen = ActiveAppScreen.parentDashboard;
            });
          },
        );

      case ActiveAppScreen.explorationRoute:
        return ExplorationRouteScreen(
          key: const ValueKey('screen_exploration'),
          onBackToEcosystems: () {
            setState(() {
              _currentScreen = ActiveAppScreen.ecosystems;
            });
          },
          onStartActivity: (node) {
            setState(() {
              _currentScreen = ActiveAppScreen.interactiveActivity;
            });
          },
        );

      case ActiveAppScreen.interactiveActivity:
        return InteractiveActivityScreen(
          key: const ValueKey('screen_activity'),
          onClose: () {
            setState(() {
              _currentScreen = ActiveAppScreen.explorationRoute;
            });
          },
          onActivityComplete: () {
            setState(() {
              _currentScreen = ActiveAppScreen.profileRewards;
            });
          },
        );

      case ActiveAppScreen.profileRewards:
        return ProfileRewardsScreen(
          key: const ValueKey('screen_profile'),
          onBack: () {
            setState(() {
              _currentScreen = ActiveAppScreen.ecosystems;
            });
          },
        );

      case ActiveAppScreen.parentDashboard:
        return ParentDashboardScreen(
          key: const ValueKey('screen_parents'),
          onBackToChildExperience: () {
            setState(() {
              _currentScreen = ActiveAppScreen.ecosystems;
            });
          },
        );
    }
  }

  Widget _buildQuickScreenSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkText.withOpacity(0.85),
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _switcherIcon(ActiveAppScreen.ecosystems, Icons.public_rounded, 'Ecosistemas'),
          _switcherIcon(ActiveAppScreen.explorationRoute, Icons.map_rounded, 'Ruta'),
          _switcherIcon(ActiveAppScreen.interactiveActivity, Icons.quiz_rounded, 'Actividad'),
          _switcherIcon(ActiveAppScreen.profileRewards, Icons.emoji_events_rounded, 'Perfil'),
          _switcherIcon(ActiveAppScreen.parentDashboard, Icons.family_restroom_rounded, 'Padres'),
        ],
      ),
    );
  }

  Widget _switcherIcon(ActiveAppScreen screen, IconData icon, String tooltip) {
    final bool isSelected = _currentScreen == screen;

    return IconButton(
      visualDensity: VisualDensity.compact,
      tooltip: tooltip,
      icon: Icon(
        icon,
        size: 20,
        color: isSelected ? AppColors.gold : AppColors.white.withOpacity(0.65),
      ),
      onPressed: () {
        setState(() {
          _currentScreen = screen;
        });
      },
    );
  }
}
