import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/avatar_config.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/avatar_catalog.dart';

void main() {
  group('AvatarConfig Tests', () {
    test('defaultConfig provides default explorer setup', () {
      final config = AvatarConfig.defaultConfig();
      expect(config.characterId, 'explorador');
      expect(config.backgroundId, 'esmeralda');
      expect(config.accessoryId, 'gorra');
      expect(config.expressionId, 'feliz');
    });

    test('toJson and fromJson serialize and deserialize correctly', () {
      const config = AvatarConfig(
        characterId: 'oso',
        backgroundId: 'solar',
        accessoryId: 'gafas',
        expressionId: 'audaz',
      );

      final json = config.toJson();
      final restored = AvatarConfig.fromJson(json);

      expect(restored.characterId, 'oso');
      expect(restored.backgroundId, 'solar');
      expect(restored.accessoryId, 'gafas');
      expect(restored.expressionId, 'audaz');
      expect(restored, equals(config));
    });

    test('copyWith updates specified fields only', () {
      final initial = AvatarConfig.defaultConfig();
      final updated = initial.copyWith(
        characterId: 'jaguar',
        accessoryId: 'corona_solar',
      );

      expect(updated.characterId, 'jaguar');
      expect(updated.backgroundId, 'esmeralda');
      expect(updated.accessoryId, 'corona_solar');
      expect(updated.expressionId, 'feliz');
    });
  });

  group('AvatarCatalog Tests', () {
    test('has valid character list with Andean bear and jaguar', () {
      expect(AvatarCatalog.characters.isNotEmpty, isTrue);
      expect(AvatarCatalog.characters.any((c) => c.id == 'oso'), isTrue);
      expect(AvatarCatalog.characters.any((c) => c.id == 'explorador'), isTrue);
      expect(AvatarCatalog.characters.any((c) => c.id == 'jaguar'), isTrue);
    });

    test('has valid accessories matching seeder rewards', () {
      expect(AvatarCatalog.accessories.any((a) => a.visualKey == 'ITEM_EXPLORER_CAP'), isTrue);
      expect(AvatarCatalog.accessories.any((a) => a.visualKey == 'ITEM_SUN_CROWN'), isTrue);
    });

    test('has valid backgrounds and expressions', () {
      expect(AvatarCatalog.backgrounds.isNotEmpty, isTrue);
      expect(AvatarCatalog.expressions.isNotEmpty, isTrue);
    });
  });
}
