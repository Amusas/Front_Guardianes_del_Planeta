import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EcosystemModel {
  final String id;
  final int? numericId;
  final String name;
  final String subtitle;
  final String description;
  final LinearGradient backgroundGradient;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isLocked;
  final double progress; // 0.0 to 1.0
  final int totalActivities;
  final int completedActivities;
  final IconData mainIcon;

  const EcosystemModel({
    required this.id,
    this.numericId,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.backgroundGradient,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isLocked,
    required this.progress,
    required this.totalActivities,
    required this.completedActivities,
    required this.mainIcon,
  });
}
