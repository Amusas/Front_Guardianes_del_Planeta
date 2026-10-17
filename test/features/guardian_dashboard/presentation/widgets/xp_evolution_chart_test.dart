import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/domain/entities/guardian_child_dashboard_entity.dart';
import 'package:guardianes_del_planeta/features/guardian_dashboard/presentation/widgets/xp_evolution_chart.dart';

void main() {
  group('XpEvolutionChart Tests', () {
    final fixedToday = DateTime(2026, 10, 16);

    testWidgets('renders 5 consecutive days centered on referenceDate (2 before, today, 2 after)', (tester) async {
      final items = [
        XpHistoryItem(
          id: 1,
          amount: 20,
          type: 'ACTIVITY',
          description: 'Actividad 1',
          createdAt: DateTime(2026, 10, 15, 10, 0),
        ),
        XpHistoryItem(
          id: 2,
          amount: 10,
          type: 'ACTIVITY',
          description: 'Actividad 2',
          createdAt: DateTime(2026, 10, 15, 11, 0),
        ),
        XpHistoryItem(
          id: 3,
          amount: 25,
          type: 'BONUS',
          description: 'Racha',
          createdAt: DateTime(2026, 10, 16, 9, 30),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: XpEvolutionChart(
              xpHistory: items,
              referenceDate: fixedToday,
            ),
          ),
        ),
      );

      // Verify the 5 day labels: 14/10, 15/10, 16/10, 17/10, 18/10
      expect(find.text('14/10'), findsOneWidget);
      expect(find.text('15/10'), findsOneWidget);
      expect(find.text('16/10'), findsOneWidget);
      expect(find.text('17/10'), findsOneWidget);
      expect(find.text('18/10'), findsOneWidget);

      // Verify "Hoy" indicator is rendered for 16/10
      expect(find.text('Hoy'), findsOneWidget);

      // Verify aggregated XP totals per day
      // 15/10 should aggregate 20 + 10 = +30
      expect(find.text('+30'), findsOneWidget);

      // 16/10 should show +25
      expect(find.text('+25'), findsOneWidget);

      // 14/10, 17/10, 18/10 should show 0 (3 occurrences of '0')
      expect(find.text('0'), findsNWidgets(3));
    });

    testWidgets('renders properly with empty xpHistory showing 0 for all 5 days', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: XpEvolutionChart(
              xpHistory: const [],
              referenceDate: fixedToday,
            ),
          ),
        ),
      );

      expect(find.text('14/10'), findsOneWidget);
      expect(find.text('15/10'), findsOneWidget);
      expect(find.text('16/10'), findsOneWidget);
      expect(find.text('17/10'), findsOneWidget);
      expect(find.text('18/10'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(5));
      expect(find.text('Aún no hay transacciones de XP registradas.'), findsOneWidget);
    });
  });
}
