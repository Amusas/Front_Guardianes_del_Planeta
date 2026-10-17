import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/ecosystem.dart';
import '../../domain/entities/ecosystem_codes.dart';
import '../../domain/models/ecosystem_model.dart';

class EcosystemVisualData {
  final LinearGradient backgroundGradient;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData mainIcon;
  final String defaultSubtitle;
  final String mascotName;

  const EcosystemVisualData({
    required this.backgroundGradient,
    required this.primaryColor,
    required this.secondaryColor,
    required this.mainIcon,
    required this.defaultSubtitle,
    required this.mascotName,
  });
}

class EcosystemVisualRegistry {
  EcosystemVisualRegistry._();

  static const EcosystemVisualData _bosqueAndino = EcosystemVisualData(
    backgroundGradient: AppColors.forestGradient,
    primaryColor: AppColors.forestGreen,
    secondaryColor: AppColors.emerald,
    mainIcon: Icons.forest_rounded,
    defaultSubtitle: 'El hogar del oso de anteojos',
    mascotName: 'Oso de anteojos',
  );

  static const EcosystemVisualData _paramo = EcosystemVisualData(
    backgroundGradient: AppColors.paramoGradient,
    primaryColor: AppColors.paramoMoss,
    secondaryColor: AppColors.paramoGrey,
    mainIcon: Icons.cloud_queue_rounded,
    defaultSubtitle: 'Tierra de niebla y frailejones',
    mascotName: 'Frailejón Guane',
  );

  static const EcosystemVisualData _oceano = EcosystemVisualData(
    backgroundGradient: AppColors.oceanGradient,
    primaryColor: AppColors.turquoiseDark,
    secondaryColor: AppColors.turquoise,
    mainIcon: Icons.waves_rounded,
    defaultSubtitle: 'Arrecifes y gigantes marinos',
    mascotName: 'Tortuga marina',
  );

  static const EcosystemVisualData _selvaAmazonica = EcosystemVisualData(
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE8F8F5), Color(0xFFD1F2EB), Color(0xFFA3E4D7)],
    ),
    primaryColor: Color(0xFF117A65),
    secondaryColor: Color(0xFF1ABC9C),
    mainIcon: Icons.park_rounded,
    defaultSubtitle: 'El pulmón verde del mundo',
    mascotName: 'Anaconda verde',
  );

  static const EcosystemVisualData _manglar = EcosystemVisualData(
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB), Color(0xFF80CBC4)],
    ),
    primaryColor: Color(0xFF00695C),
    secondaryColor: Color(0xFF26A69A),
    mainIcon: Icons.water_rounded,
    defaultSubtitle: 'Raíces que abrazan el mar y la tierra',
    mascotName: 'Cangrejo',
  );

  static const EcosystemVisualData _bosqueSecoTropical = EcosystemVisualData(
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3), Color(0xFFFFE082)],
    ),
    primaryColor: Color(0xFFD35400),
    secondaryColor: Color(0xFFE67E22),
    mainIcon: Icons.wb_sunny_rounded,
    defaultSubtitle: 'Resistencia y sol en tierra cálida',
    mascotName: 'Iguana verde',
  );

  static const EcosystemVisualData _llanosSabana = EcosystemVisualData(
    backgroundGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFEF9E7), Color(0xFFFCF3CF), Color(0xFFF9E79F)],
    ),
    primaryColor: Color(0xFFB7950B),
    secondaryColor: Color(0xFFF1C40F),
    mainIcon: Icons.grass_rounded,
    defaultSubtitle: 'Horizontes infinitos y fauna llanera',
    mascotName: 'Chigüiro',
  );

  static const EcosystemVisualData _fallback = EcosystemVisualData(
    backgroundGradient: AppColors.forestGradient,
    primaryColor: AppColors.forestGreen,
    secondaryColor: AppColors.emerald,
    mainIcon: Icons.nature_people_rounded,
    defaultSubtitle: 'Ecosistema de Colombia',
    mascotName: 'Guardián',
  );

  static EcosystemVisualData getVisualData(String code) {
    final normalized = code.trim().toUpperCase();
    AppLogger.debug('DEBUG: Código visual resuelto para: $normalized.');

    switch (normalized) {
      case EcosystemCodes.bosqueAndino:
      case 'BOSQUE_01':
      case 'BOSQUE_ANDINO':
        return _bosqueAndino;
      case EcosystemCodes.paramo:
      case 'PARAMO_01':
        return _paramo;
      case EcosystemCodes.oceano:
      case 'OCEANO_01':
        return _oceano;
      case EcosystemCodes.selvaAmazonica:
        return _selvaAmazonica;
      case EcosystemCodes.manglar:
        return _manglar;
      case EcosystemCodes.bosqueSecoTropical:
        return _bosqueSecoTropical;
      case EcosystemCodes.llanosSabana:
        return _llanosSabana;
      default:
        AppLogger.warning('WARNING: No existe un recurso visual registrado para el código recibido: $code.');
        return _fallback;
    }
  }

  static String _cleanDescription(String rawDescription) {
    if (rawDescription.isEmpty) return rawDescription;
    final cleaned = rawDescription
        .replaceAll(RegExp(r'\.?\s*(Criterio de desbloqueo|Nivel requerido|Requiere nivel)[^.]*(\.|$)', caseSensitive: false), '')
        .trim();
    if (cleaned.isNotEmpty && !cleaned.endsWith('.')) {
      return '$cleaned.';
    }
    return cleaned;
  }

  /// Mapea una entidad del dominio [Ecosystem] al modelo visual [EcosystemModel]
  static EcosystemModel toUiModel(Ecosystem ecosystem, {bool isLocked = false, double progress = 0.0}) {
    final visual = getVisualData(ecosystem.code);
    return EcosystemModel(
      id: ecosystem.code.toLowerCase(),
      numericId: ecosystem.id,
      name: ecosystem.name.isNotEmpty ? ecosystem.name : EcosystemCodes.getDisplayName(ecosystem.code),
      subtitle: visual.defaultSubtitle,
      description: _cleanDescription(ecosystem.description),
      backgroundGradient: visual.backgroundGradient,
      primaryColor: visual.primaryColor,
      secondaryColor: visual.secondaryColor,
      isLocked: isLocked,
      progress: progress,
      totalActivities: 10,
      completedActivities: (10 * progress).round(),
      mainIcon: visual.mainIcon,
    );
  }
}
