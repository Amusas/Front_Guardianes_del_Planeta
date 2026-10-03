import 'package:flutter/material.dart';

/// Dimensiones y espaciados basados en múltiplos de 4 / 8 / 12 / 16 / 24 / 32 / 40 px.
class AppDimensions {
  AppDimensions._();

  // Spacings
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;

  // Border Radii (20-28 px según especificación)
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusCard = 24.0;
  static const double radiusLarge = 28.0;
  static const double radiusPill = 999.0;

  static const BorderRadius borderRadiusCard = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius borderRadiusLarge = BorderRadius.all(Radius.circular(radiusLarge));
  static const BorderRadius borderRadiusPill = BorderRadius.all(Radius.circular(radiusPill));

  // Touch Targets (Mínimo 44 - 48 px para accesibilidad infantil)
  static const double minTouchTarget = 48.0;
  static const double buttonHeight = 56.0;

  // Canvas / Mockup size
  static const double mockupWidth = 390.0;
  static const double mockupHeight = 844.0;
}
