import 'package:flutter/material.dart';

class ActivityOptionModel {
  final String id;
  final String text;
  final IconData icon;
  final bool isCorrect;
  final String feedback;

  const ActivityOptionModel({
    required this.id,
    required this.text,
    required this.icon,
    required this.isCorrect,
    required this.feedback,
  });
}

class ActivityQuestionModel {
  final String id;
  final int questionNumber;
  final int totalQuestions;
  final String questionTitle;
  final String scenarioTitle;
  final List<ActivityOptionModel> options;
  final String hint;

  const ActivityQuestionModel({
    required this.id,
    required this.questionNumber,
    required this.totalQuestions,
    required this.questionTitle,
    required this.scenarioTitle,
    required this.options,
    required this.hint,
  });
}
