import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/avatar_config.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/screens/level_up_celebration_screen.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/widgets/child_avatar_widget.dart';

void main() {
  group('LevelUpCelebrationScreen Widget Tests', () {
    testWidgets('renders celebratory title, level transition, rank card and rewards', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      bool continued = false;

      await tester.pumpWidget(
        MaterialApp(
          home: LevelUpCelebrationScreen(
            newLevel: 2,
            previousLevel: 1,
            childName: 'Samuel',
            avatarConfig: AvatarConfig.defaultConfig(),
            onContinue: () {
              continued = true;
            },
          ),
        ),
      );

      // Título festivo
      expect(find.text('¡SUBISTE DE NIVEL!'), findsOneWidget);
      expect(find.text('¡NUEVO RANGO ALCANZADO!'), findsOneWidget);

      // Transición de nivel
      expect(find.text('Nivel 1'), findsOneWidget);
      expect(find.text('Nivel 2'), findsOneWidget);

      // Rango ecológico
      expect(find.text('Explorador del Agua'), findsOneWidget);
      expect(find.textContaining('Marco de Agua Pura'), findsOneWidget);
      expect(find.text('+100 XP'), findsOneWidget);

      // Avatar del niño renderizado
      expect(find.byType(ChildAvatarWidget), findsOneWidget);

      // Botón continuar
      final continueButton = find.text('¡CONTINUAR LA AVENTURA!');
      expect(continueButton, findsOneWidget);
      await tester.tap(continueButton);
      await tester.pump();

      expect(continued, isTrue);
    });

    testWidgets('renders Level 3 Guardián de los Mares with reef lore', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: LevelUpCelebrationScreen(
            newLevel: 3,
            previousLevel: 2,
            childName: 'Valeria',
            avatarConfig: const AvatarConfig(
              characterId: 'oso',
              backgroundId: 'solar',
              accessoryId: 'gafas',
              expressionId: 'audaz',
            ),
            onContinue: () {},
          ),
        ),
      );

      expect(find.text('Guardián de los Mares'), findsOneWidget);
      expect(find.textContaining('Avatar Guardián del Mar'), findsOneWidget);
      expect(find.textContaining('arrecifes de coral'), findsOneWidget);
    });
  });
}
