import 'package:flutter/material.dart';

/// Sombras suaves para "Guardianes del Planeta".
/// Sombra con blur alto, baja opacidad y desplazamiento sutil.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x0F1B4332), // 6% opacidad con tinte verde bosque
      blurRadius: 10,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x140F172A), // 8% opacidad
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x0A0F172A), // 4% opacidad difusa
      blurRadius: 28,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(
      color: Color(0x2E2D6A4F), // 18% opacidad de verde bosque
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> goldGlow = [
    BoxShadow(
      color: Color(0x40FFB703),
      blurRadius: 20,
      spreadRadius: 2,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> floatingIsland = [
    BoxShadow(
      color: Color(0x261B4332),
      blurRadius: 36,
      spreadRadius: 4,
      offset: Offset(0, 18),
    ),
  ];
}
