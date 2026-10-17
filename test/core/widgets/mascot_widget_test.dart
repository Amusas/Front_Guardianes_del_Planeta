import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/core/widgets/mascot_widget.dart';

void main() {
  group('MascotWidget Tests for All 7 Ecosystem Mascots', () {
    final mascots = [
      {'code': 'BOSQUE_ANDINO', 'name': 'Oso Andino'},
      {'code': 'PARAMO', 'name': 'Frailejón Guane'},
      {'code': 'OCEANO', 'name': 'Tortuga Marina'},
      {'code': 'SELVA_AMAZONICA', 'name': 'Anaconda Verde'},
      {'code': 'MANGLAR', 'name': 'Cangrejo'},
      {'code': 'BOSQUE_SECO_TROPICAL', 'name': 'Iguana Verde'},
      {'code': 'LLANOS_SABANA', 'name': 'Chigüiro'},
    ];

    for (final mascot in mascots) {
      testWidgets('renders ${mascot['name']} with smiling expression', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MascotWidget(
                ecosystemCode: mascot['code'],
                expression: MascotExpression.smiling,
                size: 100,
                isAnimated: false,
              ),
            ),
          ),
        );
        expect(find.byType(MascotWidget), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
      });

      testWidgets('renders ${mascot['name']} with happy and celebrating expression', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MascotWidget(
                ecosystemCode: mascot['code'],
                expression: MascotExpression.happy,
                size: 100,
                isAnimated: false,
              ),
            ),
          ),
        );
        expect(find.byType(MascotWidget), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
      });

      testWidgets('renders ${mascot['name']} with worried expression', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MascotWidget(
                ecosystemCode: mascot['code'],
                expression: MascotExpression.worried,
                size: 100,
                isAnimated: false,
              ),
            ),
          ),
        );
        expect(find.byType(MascotWidget), findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
      });
    }

    testWidgets('supports numeric ecosystem codes 1 through 7', (tester) async {
      for (int i = 1; i <= 7; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MascotWidget(
                ecosystemCode: '$i',
                expression: MascotExpression.smiling,
                size: 90,
                isAnimated: false,
              ),
            ),
          ),
        );
        expect(find.byType(MascotWidget), findsOneWidget);
      }
    });
  });
}
