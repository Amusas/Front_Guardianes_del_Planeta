import 'package:flutter/material.dart';
import '../../../guardian_dashboard/presentation/screens/guardian_dashboard_screen.dart';

class ParentDashboardScreen extends StatelessWidget {
  final VoidCallback onBackToChildExperience;

  const ParentDashboardScreen({
    super.key,
    required this.onBackToChildExperience,
  });

  @override
  Widget build(BuildContext context) {
    return GuardianDashboardScreen(
      onBackToChildExperience: onBackToChildExperience,
    );
  }
}
