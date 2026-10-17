import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_model.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/widgets/types/classification_activity_widget.dart';

void main() {
  late ActivityModel mockClassificationActivity;

  setUp(() {
    mockClassificationActivity = ActivityModel.fromJson({
      'id': 101,
      'lessonId': 1,
      'type': 'CLASSIFICATION',
      'title': 'Clasifica seres vivos y objetos',
      'configurationJson': '''
{
  "instructions": "Clasifica los elementos en seres vivos u objetos:",
  "categories": [
    {"id": "vivos", "name": "Seres vivos"},
    {"id": "objetos", "name": "Objetos"}
  ],
  "items": [
    {"id": "oso", "name": "Oso"},
    {"id": "llanta", "name": "Llanta"},
    {"id": "palma", "name": "Palma"}
  ],
  "correctAnswers": {
    "oso": "vivos",
    "palma": "vivos",
    "llanta": "objetos"
  }
}
''',
      'xpReward': 20,
      'orderIndex': 1,
    });
  });

  Widget createWidgetUnderTest({
    dynamic currentAnswer,
    bool isChecked = false,
    bool? isCorrect,
    required ValueChanged<dynamic> onAnswerSelected,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ClassificationActivityWidget(
            activity: mockClassificationActivity,
            currentAnswer: currentAnswer,
            isChecked: isChecked,
            isCorrect: isCorrect,
            onAnswerSelected: onAnswerSelected,
          ),
        ),
      ),
    );
  }

  group('ClassificationActivityWidget Tests', () {
    testWidgets('renders categories and small option boxes with only text', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          currentAnswer: null,
          onAnswerSelected: (_) {},
        ),
      );

      // Verify instruction
      expect(find.text('Clasifica los elementos en seres vivos u objetos:'), findsOneWidget);

      // Verify 2 category drop zones
      expect(find.text('Seres vivos'), findsOneWidget);
      expect(find.text('Objetos'), findsOneWidget);

      // Verify draggable small option boxes with text
      expect(find.text('Oso'), findsOneWidget);
      expect(find.text('Llanta'), findsOneWidget);
      expect(find.text('Palma'), findsOneWidget);

      // Counter initially 3 remaining
      expect(find.text('3 restantes'), findsOneWidget);
    });

    testWidgets('dragging option into category calls onAnswerSelected with updated map', (tester) async {
      dynamic selectedAnswer;

      await tester.pumpWidget(
        createWidgetUnderTest(
          currentAnswer: null,
          onAnswerSelected: (answer) {
            selectedAnswer = answer;
          },
        ),
      );

      // Drag 'Oso' into 'Seres vivos' category drop zone
      final itemFinder = find.text('Oso');
      final categoryFinder = find.text('Seres vivos');

      final firstLocation = tester.getCenter(itemFinder);
      final targetLocation = tester.getCenter(categoryFinder);

      final gesture = await tester.startGesture(firstLocation);
      await tester.pump(const Duration(milliseconds: 50));

      await gesture.moveTo(targetLocation);
      await tester.pump(const Duration(milliseconds: 50));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(selectedAnswer, isNotNull);
      expect(selectedAnswer is Map, isTrue);
      expect(selectedAnswer['oso'], equals('vivos'));
    });

    testWidgets('assigned items show inside category and can be removed back to pool', (tester) async {
      dynamic updatedAnswer;

      await tester.pumpWidget(
        createWidgetUnderTest(
          currentAnswer: {'oso': 'vivos', 'llanta': 'objetos'},
          onAnswerSelected: (answer) {
            updatedAnswer = answer;
          },
        ),
      );

      // Remaining in pool should be 1 ('Palma')
      expect(find.text('1 restantes'), findsOneWidget);

      // 'Oso' and 'Llanta' should be inside categories and have remove 'close' icons
      final closeIcons = find.byIcon(Icons.close_rounded);
      expect(closeIcons, findsNWidgets(2));

      // Tap on close icon for 'oso'
      await tester.tap(closeIcons.first);
      await tester.pumpAndSettle();

      expect(updatedAnswer, isNotNull);
      expect(updatedAnswer.containsKey('oso'), isFalse);
      expect(updatedAnswer['llanta'], equals('objetos'));
    });

    testWidgets('tapping an unassigned option opens quick category chooser modal', (tester) async {
      dynamic selectedAnswer;

      await tester.pumpWidget(
        createWidgetUnderTest(
          currentAnswer: null,
          onAnswerSelected: (answer) {
            selectedAnswer = answer;
          },
        ),
      );

      // Tap 'Palma'
      await tester.tap(find.text('Palma'));
      await tester.pumpAndSettle();

      // Modal bottom sheet appears with question
      expect(find.text('¿A qué categoría pertenece "Palma"?'), findsOneWidget);

      // Tap 'Seres vivos' in the modal
      final categoryButtons = find.widgetWithText(ElevatedButton, 'Seres vivos');
      expect(categoryButtons, findsOneWidget);

      await tester.tap(categoryButtons);
      await tester.pumpAndSettle();

      expect(selectedAnswer, isNotNull);
      expect(selectedAnswer['palma'], equals('vivos'));
    });
  });
}
