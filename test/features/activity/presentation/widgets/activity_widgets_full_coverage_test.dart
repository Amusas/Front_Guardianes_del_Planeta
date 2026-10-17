import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_model.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/widgets/types/activity_widget_factory.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/widgets/types/drag_and_drop_activity_widget.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/widgets/types/generic_activity_widget.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/badge_model.dart';
import 'package:guardianes_del_planeta/features/profile/presentation/widgets/badge_detail_modal.dart';

void main() {
  group('DragAndDropActivityWidget Tests (Happy and Sad Paths)', () {
    final dragActivity = ActivityModel.fromJson({
      'id': 5,
      'lessonId': 1,
      'type': 'DRAG_AND_DROP',
      'title': 'Ubica en el hábitat',
      'configurationJson': '''
      {
        "instructions": "Ubica cada elemento en su hábitat:",
        "targets": [
          {"zone": "bosque", "name": "El Bosque"},
          {"zone": "agua", "name": "La Quebrada"}
        ],
        "elements": [
          {"id": "oso", "name": "Oso de anteojos"},
          {"id": "pez", "name": "Pez andino"}
        ],
        "correctAnswers": {"oso": "bosque", "pez": "agua"}
      }
      ''',
      'xpReward': 15,
      'orderIndex': 5,
    });

    testWidgets('Permite asignar elementos a zonas y muestra estados sin comprobar, correcto e incorrecto', (tester) async {
      dynamic selectedMap;

      // 1. Sin seleccionar
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DragAndDropActivityWidget(
                activity: dragActivity,
                currentAnswer: null,
                isChecked: false,
                isCorrect: null,
                onAnswerSelected: (val) => selectedMap = val,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Oso de anteojos'), findsOneWidget);
      await tester.tap(find.text('El Bosque').first);
      expect(selectedMap, equals({'oso': 'bosque'}));

      // 2. Seleccionado sin comprobar
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DragAndDropActivityWidget(
                activity: dragActivity,
                currentAnswer: const {'oso': 'bosque'},
                isChecked: false,
                isCorrect: null,
                onAnswerSelected: (val) => selectedMap = val,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // 3. Comprobado y Correcto (Camino Feliz)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DragAndDropActivityWidget(
                activity: dragActivity,
                currentAnswer: const {'oso': 'bosque', 'pez': 'agua'},
                isChecked: true,
                isCorrect: true,
                onAnswerSelected: (val) => selectedMap = val,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);

      // 4. Comprobado e Incorrecto (Camino Triste)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DragAndDropActivityWidget(
                activity: dragActivity,
                currentAnswer: const {'oso': 'agua'},
                isChecked: true,
                isCorrect: false,
                onAnswerSelected: (val) => selectedMap = val,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.cancel_rounded), findsWidgets);
    });
  });

  group('GenericActivityWidget & ActivityWidgetFactory Tests', () {
    final unknownWithOptions = ActivityModel.fromJson({
      'id': 9,
      'lessonId': 1,
      'type': 'OTHER_TYPE',
      'title': 'Actividad Especial',
      'configurationJson': '{"question": "Pregunta especial", "options": ["Opción 1", "Opción 2"], "correctAnswer": "Opción 1"}',
      'xpReward': 10,
      'orderIndex': 1,
    });

    final unknownWithoutOptions = ActivityModel.fromJson({
      'id': 10,
      'lessonId': 1,
      'type': 'OTHER_TYPE',
      'title': 'Lectura Especial',
      'configurationJson': '{"instructions": "Lee con atención"}',
      'xpReward': 10,
      'orderIndex': 2,
    });

    testWidgets('GenericActivityWidget renderiza opciones en estados normal, correcto, incorrecto y sin opciones', (tester) async {
      dynamic selected;

      // Con opciones - seleccionado sin comprobar
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActivityWidgetFactory(
              activity: unknownWithOptions,
              currentAnswer: 'Opción 1',
              isChecked: false,
              isCorrect: null,
              onAnswerSelected: (v) => selected = v,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Opción 2'));
      expect(selected, 'Opción 2');

      // Con opciones - comprobado correcto
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericActivityWidget(
              activity: unknownWithOptions,
              currentAnswer: 'Opción 1',
              isChecked: true,
              isCorrect: true,
              onAnswerSelected: (v) => selected = v,
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Con opciones - comprobado incorrecto
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericActivityWidget(
              activity: unknownWithOptions,
              currentAnswer: 'Opción 2',
              isChecked: true,
              isCorrect: false,
              onAnswerSelected: (v) => selected = v,
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);

      // Sin opciones - botón de confirmación
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenericActivityWidget(
              activity: unknownWithoutOptions,
              currentAnswer: null,
              isChecked: false,
              isCorrect: null,
              onAnswerSelected: (v) => selected = v,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Entendido y listo para continuar'));
      expect(selected, 'COMPLETED');
    });
  });

  group('BadgeDetailModal Widget Tests', () {
    testWidgets('Renderiza insignia desbloqueada con fecha y permite cerrar', (tester) async {
      bool closed = false;
      const badge = BadgeModel(
        id: 'FIRST_STEP',
        title: 'Primer Paso',
        description: 'Completaste tu primera actividad.',
        icon: Icons.eco_rounded,
        primaryColor: Colors.green,
        isUnlocked: true,
        xpBonus: 50,
        dateUnlocked: '16 Oct 2026',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BadgeDetailModal(
              badge: badge,
              onClose: () => closed = true,
            ),
          ),
        ),
      );

      expect(find.text('Primer Paso'), findsOneWidget);
      expect(find.text('Obtenida el 16 Oct 2026'), findsOneWidget);
      await tester.tap(find.text('¡INCREÍBLE!'));
      expect(closed, isTrue);
    });
  });
}
