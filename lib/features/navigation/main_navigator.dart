import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../ecosystems/domain/models/ecosystem_model.dart';
import '../ecosystems/presentation/screens/ecosystem_selector_screen.dart';
import '../exploration/presentation/screens/exploration_route_screen.dart';
import '../exploration/presentation/controllers/lesson_controller.dart';
import '../activity/presentation/screens/interactive_activity_screen.dart';
import '../exploration/domain/models/lesson_node_model.dart';
import '../profile/presentation/screens/profile_rewards_screen.dart';
import '../profile/presentation/controllers/child_profile_controller.dart';
import '../profile/presentation/screens/level_up_celebration_screen.dart';
import '../profile/domain/models/avatar_config.dart';

enum ActiveAppScreen {
  ecosystems,
  explorationRoute,
  interactiveActivity,
  profileRewards,
  levelUpCelebration,
}

/// Controlador de navegación interactivo para "Guardianes del Planeta".
/// Permite el flujo natural del juego infantil y selector de pantallas para pruebas.
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  ActiveAppScreen _currentScreen = ActiveAppScreen.ecosystems;
  EcosystemModel? _selectedEcosystem;
  LessonNodeModel? _selectedLessonNode;

  void _navigateTo(VoidCallback update) {
    if (mounted) {
      setState(update);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case ActiveAppScreen.ecosystems:
        return EcosystemSelectorScreen(
          key: const ValueKey('screen_ecosystems'),
          initialEcosystemId: _selectedEcosystem?.numericId,
          initialEcosystemCode: _selectedEcosystem?.id,
          onEcosystemChanged: (eco) {
            _selectedEcosystem = eco;
          },
          onExploreEcosystem: (eco) {
            _navigateTo(() {
              _selectedEcosystem = eco;
              _currentScreen = ActiveAppScreen.explorationRoute;
            });
          },
          onOpenProfile: () {
            _navigateTo(() {
              _currentScreen = ActiveAppScreen.profileRewards;
            });
          },
        );

      case ActiveAppScreen.explorationRoute:
        return ExplorationRouteScreen(
          key: const ValueKey('screen_exploration'),
          ecosystem: _selectedEcosystem,
          onBackToEcosystems: () {
            _navigateTo(() {
              _currentScreen = ActiveAppScreen.ecosystems;
            });
          },
          onStartActivity: (node) {
            _navigateTo(() {
              _selectedLessonNode = node;
              _currentScreen = ActiveAppScreen.interactiveActivity;
            });
          },
        );

      case ActiveAppScreen.interactiveActivity:
        return InteractiveActivityScreen(
          key: ValueKey('screen_activity_${_selectedLessonNode?.id ?? "default"}'),
          ecosystem: _selectedEcosystem,
          lesson: _selectedLessonNode,
          lessonId: _selectedLessonNode?.id,
          onClose: () {
            _navigateTo(() {
              _currentScreen = ActiveAppScreen.explorationRoute;
            });
          },
          onActivityComplete: () {
            if (_selectedLessonNode != null) {
              context.read<LessonController>().completeLesson(_selectedLessonNode!.id);
            }
            try {
              context.read<ChildProfileController>().loadProfile(forceRefresh: true);
            } catch (_) {}
            _navigateTo(() {
              _currentScreen = ActiveAppScreen.explorationRoute;
            });
          },
        );

      case ActiveAppScreen.profileRewards:
        return ProfileRewardsScreen(
          key: const ValueKey('screen_profile'),
          onBack: () {
            _navigateTo(() {
              _currentScreen = ActiveAppScreen.ecosystems;
            });
          },
        );

      case ActiveAppScreen.levelUpCelebration:
        ChildProfileController? childProfile;
        try {
          childProfile = context.watch<ChildProfileController>();
        } catch (_) {}
        final currentLvl = childProfile?.levelNumber ?? 1;
        final nextLvl = currentLvl < 6 ? currentLvl + 1 : 2;

        return LevelUpCelebrationScreen(
          key: const ValueKey('screen_level_up'),
          newLevel: nextLvl,
          previousLevel: currentLvl,
          childName: childProfile?.childName ?? 'Explorador',
          avatarConfig: childProfile?.avatarConfig ?? AvatarConfig.defaultConfig(),
          onContinue: () {
            _navigateTo(() {
              _currentScreen = ActiveAppScreen.ecosystems;
            });
          },
          onOpenProfile: () {
            _navigateTo(() {
              _currentScreen = ActiveAppScreen.profileRewards;
            });
          },
        );
    }
  }
}
