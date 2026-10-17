import 'package:flutter/material.dart';
import '../../../domain/models/activity_model.dart';
import 'multiple_choice_activity_widget.dart';
import 'true_false_activity_widget.dart';
import 'classification_activity_widget.dart';
import 'ordering_activity_widget.dart';
import 'drag_and_drop_activity_widget.dart';
import 'generic_activity_widget.dart';

class ActivityWidgetFactory extends StatelessWidget {
  final ActivityModel activity;
  final dynamic currentAnswer;
  final bool isChecked;
  final bool? isCorrect;
  final ValueChanged<dynamic> onAnswerSelected;

  const ActivityWidgetFactory({
    super.key,
    required this.activity,
    required this.currentAnswer,
    required this.isChecked,
    required this.isCorrect,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    switch (activity.type) {
      case ActivityType.multipleChoice:
        return MultipleChoiceActivityWidget(
          activity: activity,
          currentAnswer: currentAnswer,
          isChecked: isChecked,
          isCorrect: isCorrect,
          onAnswerSelected: onAnswerSelected,
        );

      case ActivityType.trueFalse:
        return TrueFalseActivityWidget(
          activity: activity,
          currentAnswer: currentAnswer,
          isChecked: isChecked,
          isCorrect: isCorrect,
          onAnswerSelected: onAnswerSelected,
        );

      case ActivityType.classification:
        return ClassificationActivityWidget(
          activity: activity,
          currentAnswer: currentAnswer,
          isChecked: isChecked,
          isCorrect: isCorrect,
          onAnswerSelected: onAnswerSelected,
        );

      case ActivityType.ordering:
        return OrderingActivityWidget(
          activity: activity,
          currentAnswer: currentAnswer,
          isChecked: isChecked,
          isCorrect: isCorrect,
          onAnswerSelected: onAnswerSelected,
        );

      case ActivityType.dragAndDrop:
        return DragAndDropActivityWidget(
          activity: activity,
          currentAnswer: currentAnswer,
          isChecked: isChecked,
          isCorrect: isCorrect,
          onAnswerSelected: onAnswerSelected,
        );

      case ActivityType.unknown:
        return GenericActivityWidget(
          activity: activity,
          currentAnswer: currentAnswer,
          isChecked: isChecked,
          isCorrect: isCorrect,
          onAnswerSelected: onAnswerSelected,
        );
    }
  }
}
