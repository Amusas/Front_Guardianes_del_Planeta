import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_dimensions.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.pastelGreenBg,
      primaryColor: AppColors.forestGreen,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.forestGreen,
        onPrimary: AppColors.white,
        secondary: AppColors.emerald,
        onSecondary: AppColors.white,
        tertiary: AppColors.gold,
        onTertiary: AppColors.darkText,
        error: AppColors.errorSoft,
        onError: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.darkText,
      ),
      fontFamily: 'Nunito',
      textTheme: const TextTheme(
        displayLarge: AppTypography.displayLarge,
        displayMedium: AppTypography.displayMedium,
        headlineLarge: AppTypography.headingLarge,
        headlineMedium: AppTypography.headingMedium,
        titleLarge: AppTypography.subheading,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        labelLarge: AppTypography.caption,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusCard)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: AppColors.mediumGrey.withOpacity(0.55),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forestGreen,
          foregroundColor: AppColors.white,
          minimumSize: const Size(64, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          ),
          elevation: 0,
          textStyle: AppTypography.buttonText,
        ),
      ),
    );
  }
}
