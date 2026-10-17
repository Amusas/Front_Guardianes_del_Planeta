import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyChildrenWidget extends StatelessWidget {
  final VoidCallback onCreateChild;

  const EmptyChildrenWidget({super.key, required this.onCreateChild});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.forestGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.family_restroom_rounded,
                size: 64,
                color: AppColors.forestGreen,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Bienvenido al Panel del Acudiente!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Aún no tienes ningún perfil infantil asociado. Crea una cuenta para que tu niño o niña comience a aprender sobre ecosistemas y registrar su progreso.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onCreateChild,
              icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.white),
              label: const Text(
                'Crear Perfil Infantil',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestGreen,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
