import 'package:flutter/material.dart';

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final bool isUnlocked;
  final String? dateUnlocked;
  final int xpBonus;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.isUnlocked,
    this.dateUnlocked,
    this.xpBonus = 100,
  });
}
