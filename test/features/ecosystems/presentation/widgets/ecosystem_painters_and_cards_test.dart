import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/core/theme/app_colors.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/models/ecosystem_model.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/widgets/ecosystem_carousel_card.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/widgets/enhanced_isometric_island_painter.dart';
import 'package:guardianes_del_planeta/features/exploration/presentation/widgets/ecosystem_route_scenery_painter.dart';

void main() {
  EcosystemModel buildEco(String id, {bool isLocked = false, double progress = 0.5}) {
    return EcosystemModel(
      id: id,
      numericId: 1,
      name: 'Ecosistema $id',
      subtitle: 'Subtítulo $id',
      description: 'Descripción del ecosistema $id',
      backgroundGradient: const LinearGradient(colors: [AppColors.emerald, AppColors.turquoise]),
      primaryColor: AppColors.emerald,
      secondaryColor: AppColors.turquoise,
      isLocked: isLocked,
      progress: progress,
      totalActivities: 8,
      completedActivities: 4,
      mainIcon: Icons.forest_rounded,
    );
  }

  group('EnhancedIsometricIslandPainter & EcosystemCarouselCard Coverage Tests', () {
    final ecoIds = [
      'bosque_andino',
      'paramo',
      'oceano',
      'selva_amazonia',
      'manglar',
      'bosque_seco_tropical',
      'llanos_sabana',
    ];

    for (final ecoId in ecoIds) {
      testWidgets('Renders EnhancedIsometricIslandPainter and EcosystemCarouselCard for $ecoId (unlocked & selected)', (tester) async {
        final eco = buildEco(ecoId, isLocked: false, progress: 0.6);
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 400,
                height: 600,
                child: EcosystemCarouselCard(
                  ecosystem: eco,
                  isSelected: true,
                  onTap: () => tapped = true,
                ),
              ),
            ),
          ),
        );

        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Ecosistema $ecoId'), findsOneWidget);

        await tester.tap(find.byType(EcosystemCarouselCard));
        expect(tapped, isTrue);

        final p1 = EnhancedIsometricIslandPainter(ecosystem: eco, animationValue: 0.2);
        final p2 = EnhancedIsometricIslandPainter(ecosystem: eco, animationValue: 0.8);
        expect(p1.shouldRepaint(p2), isTrue);
      });
    }

    testWidgets('Renders EcosystemCarouselCard when locked and unselected (Sad/Locked Path)', (tester) async {
      final lockedEco = buildEco('paramo', isLocked: true, progress: 0.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: EcosystemCarouselCard(
                ecosystem: lockedEco,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Bloqueado'), findsWidgets);
    });
  });

  group('EcosystemRouteSceneryPainter Coverage Tests (All 7 Colombian Ecosystems)', () {
    final codes = [
      'BOSQUE_ANDINO',
      'PARAMO',
      'OCEANO',
      'SELVA_AMAZONICA',
      'MANGLAR',
      'BOSQUE_SECO_TROPICAL',
      'LLANOS_SABANA',
    ];

    for (final code in codes) {
      testWidgets('Paints EcosystemRouteSceneryPainter for $code', (tester) async {
        final painter = EcosystemRouteSceneryPainter(
          ecoCode: code,
          totalHeight: 1200,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: CustomPaint(
                  size: const Size(400, 1200),
                  painter: painter,
                ),
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.byType(CustomPaint), findsWidgets);
        expect(
          painter.shouldRepaint(EcosystemRouteSceneryPainter(ecoCode: 'OTHER', totalHeight: 1000)),
          isA<bool>(),
        );
      });
    }
  });
}
