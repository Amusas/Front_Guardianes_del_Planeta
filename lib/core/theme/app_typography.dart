import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tipografía amigable, redondeada y de alta legibilidad para "Guardianes del Planeta".
class AppTypography {
  AppTypography._();

  // Display: 28-34 px (Títulos de impacto, pantallas principales)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.darkText,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    color: AppColors.darkText,
    height: 1.25,
  );

  // Heading: 22-26 px (Encabezados de sección, nombres de ecosistemas)
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.darkText,
    height: 1.3,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: AppColors.darkText,
    height: 1.3,
  );

  // Subheading: 18-20 px (Subtítulos, títulos de tarjetas)
  static const TextStyle subheading = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    height: 1.35,
  );

  // Body: 15-17 px (Textos informativos, preguntas, descripciones)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.darkText,
    height: 1.4,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGrey,
    height: 1.45,
  );

  // Caption: 12-14 px (Labels, tooltips, metadatos)
  static const TextStyle caption = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    color: AppColors.mediumGrey,
    height: 1.3,
  );

  // Estilos especiales para gamificación: Números de XP y puntuación con gran impacto visual
  static const TextStyle xpCounter = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.w900,
    color: AppColors.goldDark,
    letterSpacing: 0.5,
  );

  static const TextStyle xpReward = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w900,
    color: AppColors.gold,
    shadows: [
      Shadow(
        color: Color(0x33000000),
        offset: Offset(0, 3),
        blurRadius: 6,
      ),
    ],
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    color: AppColors.white,
  );
}
