import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/avatar_config.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/widgets/child_avatar_widget.dart';

void main() {
  group('ChildAvatarWidget Tests', () {
    testWidgets('renders default avatar with specified size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChildAvatarWidget(
              config: AvatarConfig.defaultConfig(),
              size: 80,
            ),
          ),
        ),
      );

      expect(find.byType(ChildAvatarWidget), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders Andean bear avatar with solar crown and glasses', (tester) async {
      const config = AvatarConfig(
        characterId: 'oso',
        backgroundId: 'solar',
        accessoryId: 'corona_solar',
        expressionId: 'audaz',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChildAvatarWidget(
              config: config,
              size: 104,
            ),
          ),
        ),
      );

      expect(find.byType(ChildAvatarWidget), findsOneWidget);
    });

    testWidgets('renders jaguar with leaf crown and ocean background', (tester) async {
      const config = AvatarConfig(
        characterId: 'jaguar',
        backgroundId: 'oceano',
        accessoryId: 'corona_hojas',
        expressionId: 'feliz',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChildAvatarWidget(
              config: config,
              size: 120,
            ),
          ),
        ),
      );

      expect(find.byType(ChildAvatarWidget), findsOneWidget);
    });
  });
}
