import 'package:flutter/material.dart';

class ChildProfileModel {
  final String id;
  final String name;
  final int age;
  final int level;

  const ChildProfileModel({
    required this.id,
    required this.name,
    required this.age,
    required this.level,
  });
}

class RecentActivityItem {
  final String timestamp;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String badgeText;

  const RecentActivityItem({
    required this.timestamp,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.badgeText,
  });
}
