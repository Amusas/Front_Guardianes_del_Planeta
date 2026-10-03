import 'package:flutter/material.dart';

enum LessonNodeState { completed, active, locked }

class LessonNodeModel {
  final int id;
  final String title;
  final String description;
  final LessonNodeState state;
  final IconData icon;
  final int xpReward;
  final double xOffsetFraction; // -0.5 (izquierda) a 0.5 (derecha) para el camino sinuoso

  const LessonNodeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.state,
    required this.icon,
    this.xpReward = 50,
    required this.xOffsetFraction,
  });
}
