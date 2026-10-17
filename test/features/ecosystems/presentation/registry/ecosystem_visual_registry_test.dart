import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/entities/ecosystem.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/entities/ecosystem_codes.dart';
import 'package:guardianes_del_planeta/features/ecosystems/presentation/registry/ecosystem_visual_registry.dart';

void main() {
  group('EcosystemVisualRegistry & Codes Tests', () {
    test('EcosystemCodes has exactly all 7 official codes', () {
      expect(EcosystemCodes.allCodes, containsAll([
        'BOSQUE_ANDINO',
        'PARAMO',
        'OCEANO',
        'SELVA_AMAZONICA',
        'MANGLAR',
        'BOSQUE_SECO_TROPICAL',
        'LLANOS_SABANA',
      ]));
      expect(EcosystemCodes.allCodes.length, 7);
    });

    test('EcosystemCodes display names match requirements', () {
      expect(EcosystemCodes.getDisplayName('BOSQUE_ANDINO'), 'Bosque Andino');
      expect(EcosystemCodes.getDisplayName('PARAMO'), 'Páramo');
      expect(EcosystemCodes.getDisplayName('OCEANO'), 'Océano');
      expect(EcosystemCodes.getDisplayName('SELVA_AMAZONICA'), 'Selva Amazónica');
      expect(EcosystemCodes.getDisplayName('MANGLAR'), 'Manglar');
      expect(EcosystemCodes.getDisplayName('BOSQUE_SECO_TROPICAL'), 'Bosque Seco Tropical');
      expect(EcosystemCodes.getDisplayName('LLANOS_SABANA'), 'Llanos y Sabana');
    });

    test('Resolves distinct visual data for all 7 official codes', () {
      for (final code in EcosystemCodes.allCodes) {
        final visual = EcosystemVisualRegistry.getVisualData(code);
        expect(visual.backgroundGradient, isNotNull);
        expect(visual.primaryColor, isNotNull);
        expect(visual.secondaryColor, isNotNull);
        expect(visual.mainIcon, isNotNull);
        expect(visual.defaultSubtitle, isNotEmpty);
      }
    });

    test('Gracefully falls back for unknown ecosystem code without error', () {
      final fallback = EcosystemVisualRegistry.getVisualData('GALAPAGOS_VOLCAN');
      expect(fallback, isNotNull);
      expect(fallback.defaultSubtitle, 'Ecosistema de Colombia');
    });

    test('toUiModel generates EcosystemModel correctly', () {
      const entity = Ecosystem(
        id: 1,
        code: 'BOSQUE_ANDINO',
        name: 'Bosque Andino',
        description: 'Biodiversidad andina.',
        isActive: true,
      );

      final model = EcosystemVisualRegistry.toUiModel(entity, isLocked: false, progress: 0.5);

      expect(model.id, 'bosque_andino');
      expect(model.name, 'Bosque Andino');
      expect(model.description, 'Biodiversidad andina.');
      expect(model.isLocked, isFalse);
      expect(model.progress, 0.5);
      expect(model.completedActivities, 5);
    });
  });
}
