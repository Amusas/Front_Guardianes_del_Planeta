import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_model.dart';
import 'package:guardianes_del_planeta/features/activity/presentation/widgets/types/ordering_activity_widget.dart';

void main() {
  late ActivityModel mockOrderingActivity;

  setUp(() {
    mockOrderingActivity = ActivityModel.fromJson({
      'id': 201,
      'lessonId': 1,
      'type': 'ORDERING',
      'title': 'El ciclo del agua',
      'configurationJson': '''
{
  "instructions": "Ordena los pasos del ciclo del agua:",
  "steps": [
    "La evaporación por el calor del sol",
    "La condensación formando nubes",
    "La precipitación en forma de lluvia"
  ],
  "correctSequence": [0, 1, 2]
}
''',
      'xpReward': 25,
      'orderIndex': 2,
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
          child: OrderingActivityWidget(
            activity: mockOrderingActivity,
            currentAnswer: currentAnswer,
            isChecked: isChecked,
            isCorrect: isCorrect,
            onAnswerSelected: onAnswerSelected,
          ),
        ),
      ),
    );
  }

  group('OrderingActivityWidget Tests', () {
    testWidgets('renders all steps with drag indicator handles and position numbers', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          currentAnswer: [0, 1, 2],
          onAnswerSelected: (_) {},
        ),
      );

      // Verify instruction
      expect(find.text('Ordena los pasos del ciclo del agua:'), findsOneWidget);
      expect(find.text('Arrastra para ordenar los pasos'), findsOneWidget);

      // Verify step texts
      expect(find.text('La evaporación por el calor del sol'), findsOneWidget);
      expect(find.text('La condensación formando nubes'), findsOneWidget);
      expect(find.text('La precipitación en forma de lluvia'), findsOneWidget);

      // Verify position numbers 1, 2, 3
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Verify drag indicators are present
      expect(find.byIcon(Icons.drag_indicator_rounded), findsNWidgets(3));
    });

    testWidgets('dragging to reorder steps triggers onAnswerSelected with new sequence', (tester) async {
      dynamic selectedAnswer;

      await tester.pumpWidget(
        createWidgetUnderTest(
          currentAnswer: [0, 1, 2],
          onAnswerSelected: (answer) {
            selectedAnswer = answer;
          },
        ),
      );

      // Drag step 1 to position 3 using the ReorderableListView drag
      final firstDragHandle = find.byIcon(Icons.drag_indicator_rounded).first;

      final start = tester.getCenter(firstDragHandle);
      final gesture = await tester.startGesture(start);
      await tester.pump(const Duration(milliseconds: 100));

      // Move downwards past the 3rd item
      await gesture.moveBy(const Offset(0, 200));
      await tester.pump(const Duration(milliseconds: 100));

      await gesture.up();
      await tester.pumpAndSettle();

      expect(selectedAnswer, isNotNull);
      expect(selectedAnswer is List<int>, isTrue);
    });

    testWidgets('renders success check icons when checked and correct', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          currentAnswer: [0, 1, 2],
          isChecked: true,
          isCorrect: true,
          onAnswerSelected: (_) {},
        ),
      );

      // Drag indicators should be replaced by status icons
      expect(find.byIcon(Icons.drag_indicator_rounded), findsNothing);
      expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(3));
    });
  });
}
