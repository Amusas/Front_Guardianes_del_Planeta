import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isUnauthorized;

  const DashboardErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.isUnauthorized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isUnauthorized
                    ? AppColors.gold.withOpacity(0.15)
                    : AppColors.errorSoft.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnauthorized ? Icons.lock_clock_rounded : Icons.cloud_off_rounded,
                size: 56,
                color: isUnauthorized ? AppColors.goldDark : AppColors.errorSoft,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isUnauthorized ? 'Sesión no autorizada o expirada' : 'Error al cargar los datos',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, color: AppColors.white),
              label: const Text(
                'Reintentar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestGreen,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
