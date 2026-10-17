import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/avatar_config.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/widgets/avatar_customizer_modal.dart';

void main() {
  group('AvatarCustomizerModal Widget Tests', () {
    testWidgets('renders modal header, avatar preview, categories and save button', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      AvatarConfig? savedConfig;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvatarCustomizerModal(
              initialConfig: AvatarConfig.defaultConfig(),
              childLevel: 3,
              childName: 'Camila',
              onSave: (config) {
                savedConfig = config;
              },
            ),
          ),
        ),
      );

      expect(find.text('Personaliza tu Avatar'), findsOneWidget);
      expect(find.text('Camila'), findsOneWidget);
      expect(find.textContaining('Guardián'), findsWidgets);
      expect(find.textContaining('Color'), findsOneWidget);
      expect(find.textContaining('Accesorio'), findsOneWidget);
      expect(find.textContaining('Expresión'), findsOneWidget);
      expect(find.text('GUARDAR AVATAR'), findsOneWidget);
    });

    testWidgets('allows selecting character and saving new avatar config', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      AvatarConfig? savedConfig;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvatarCustomizerModal(
              initialConfig: AvatarConfig.defaultConfig(),
              childLevel: 3,
              childName: 'Camila',
              onSave: (config) {
                savedConfig = config;
              },
            ),
          ),
        ),
      );

      // Encontrar y seleccionar el Oso de Anteojos
      final bearFinder = find.text('Oso de Anteojos');
      expect(bearFinder, findsOneWidget);
      await tester.tap(bearFinder);
      await tester.pumpAndSettle();

      // Guardar avatar
      final saveButton = find.text('GUARDAR AVATAR');
      await tester.tap(saveButton);
      await tester.pump();

      expect(savedConfig, isNotNull);
      expect(savedConfig!.characterId, 'oso');
    });

    testWidgets('shows level requirement toast when clicking locked option', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvatarCustomizerModal(
              initialConfig: AvatarConfig.defaultConfig(),
              childLevel: 1, // Nivel 1 (Jaguar requiere nivel 2)
              childName: 'Mateo',
              onSave: (_) {},
            ),
          ),
        ),
      );

      final jaguarFinder = find.text('Jaguar Dorado');
      expect(jaguarFinder, findsOneWidget);
      await tester.tap(jaguarFinder);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('¡Sube al nivel 2 para desbloquear "Jaguar Dorado"!'), findsOneWidget);
    });
  });
}
