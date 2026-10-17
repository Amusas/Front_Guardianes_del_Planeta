import 'package:flutter/material.dart';

/// Sistema de colores oficial de "Guardianes del Planeta".
/// Estilo: Playful Environmental Adventure UI.
class AppColors {
  AppColors._();

  // --- Colores Principales del Ecosistema ---
  // Verde Bosque: color principal asociado al progreso, naturaleza y Bosque Andino
  static const Color forestGreen = Color(0xFF2D6A4F);
  static const Color forestGreenDark = Color(0xFF1B4332);
  static const Color forestGreenLight = Color(0xFF40916C);

  // Verde Esmeralda: para elementos destacados, aciertos y estados positivos
  static const Color emerald = Color(0xFF52B788);
  static const Color emeraldLight = Color(0xFF74C69D);

  // Verde Pastel: fondos secundarios y tarjetas suaves
  static const Color pastelGreen = Color(0xFFD8F3DC);
  static const Color pastelGreenBg = Color(0xFFF2FBF5);

  // Amarillo / Dorado: XP, recompensas, logros, insignias y elementos desbloqueados
  static const Color gold = Color(0xFFFFB703);
  static const Color goldLight = Color(0xFFFFD166);
  static const Color goldDark = Color(0xFFFB8500);

  // Azul Turquesa: Agua, océano, ríos y actividades de conservación
  static const Color turquoise = Color(0xFF2A9D8F);
  static const Color turquoiseLight = Color(0xFF48CAE4);
  static const Color turquoiseDark = Color(0xFF0077B6);

  // Páramo: Niebla, vegetación andina, musgos y rocas opacas
  static const Color paramoMoss = Color(0xFF4A5D4E);
  static const Color paramoGrey = Color(0xFF6B705C);
  static const Color paramoFog = Color(0xFFCFD6D3);
  static const Color iceBlue = Color(0xFFA8DADC);
  static const Color iceBlueLight = Color(0xFFE2F3F5);
  static const Color bluishGrey = Color(0xFF4A5D4E);
  static const Color paramoDark = Color(0xFF2E3D32);

  // Coral: complementario para el ecosistema oceánico
  static const Color coral = Color(0xFFE76F51);
  static const Color coralLight = Color(0xFFF4A261);

  // Colores de Sendero y Tierra
  static const Color pathSand = Color(0xFFF9DC5C);
  static const Color pathEarth = Color(0xFFE9C46A);
  static const Color pathBorder = Color(0xFFD4A373);

  // Neutros
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8FAFC);
  static const Color lightGrey = Color(0xFFF1F5F9);
  static const Color mediumGrey = Color(0xFF94A3B8);
  static const Color darkGrey = Color(0xFF475569);
  static const Color darkText = Color(0xFF0F172A);

  // Estados
  static const Color success = Color(0xFF2EC4B6);
  static const Color errorSoft = Color(0xFFE63946);
  static const Color warning = Color(0xFFFF9F1C);
  static const Color locked = Color(0xFFCBD5E1);

  // Gradientes de Ecosistemas
  static const LinearGradient forestGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
  );

  static const LinearGradient paramoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE4E9E6), Color(0xFFCCD5D0), Color(0xFFAFBDB5)],
  );

  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)],
  );

  static const LinearGradient goldRewardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFE082), Color(0xFFFFB703), Color(0xFFFB8500)],
  );
}
