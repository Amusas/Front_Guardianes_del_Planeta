import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/main.dart';
import 'package:guardianes_del_planeta/core/widgets/xp_bar.dart';

void main() {
  testWidgets('Carga inicial de Guardianes del Planeta renderiza el selector de ecosistemas', (WidgetTester tester) async {
    await tester.pumpWidget(const GuardianesDelPlanetaApp());
    await tester.pumpAndSettle();

    // Debe mostrar la bienvenida y el ecosistema principal Bosque Andino
    expect(find.text('¿Qué mundo exploraremos hoy?'), findsOneWidget);
    expect(find.text('Bosque Andino'), findsOneWidget);
    expect(find.text('EXPLORAR'), findsOneWidget);
  });

  testWidgets('XpBarWidget renderiza correctamente los valores de XP', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: XpBarWidget(currentXp: 1250, targetXp: 2000, showProgressText: true),
        ),
      ),
    );

    expect(find.text('1250 / 2000 XP'), findsOneWidget);
  });
}
