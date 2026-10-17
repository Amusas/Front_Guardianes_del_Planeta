import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:guardianes_del_planeta/features/profile/data/datasources/avatar_local_storage.dart';
import 'package:guardianes_del_planeta/features/profile/domain/models/avatar_config.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late AvatarLocalStorage avatarStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    avatarStorage = AvatarLocalStorage(storage: mockStorage);
  });

  group('AvatarLocalStorage Tests', () {
    test('loadAvatar returns defaultConfig when storage is empty', () async {
      when(() => mockStorage.read(key: 'child_avatar_10')).thenAnswer((_) async => null);

      final result = await avatarStorage.loadAvatar(10);

      expect(result.characterId, 'explorador');
      expect(result.backgroundId, 'esmeralda');
      expect(result.accessoryId, 'gorra');
      expect(result.expressionId, 'feliz');
    });

    test('loadAvatar returns stored config when present', () async {
      const storedJson = '{"characterId":"oso","backgroundId":"oceano","accessoryId":"gafas","expressionId":"audaz"}';
      when(() => mockStorage.read(key: 'child_avatar_10')).thenAnswer((_) async => storedJson);

      final result = await avatarStorage.loadAvatar(10);

      expect(result.characterId, 'oso');
      expect(result.backgroundId, 'oceano');
      expect(result.accessoryId, 'gafas');
      expect(result.expressionId, 'audaz');
    });

    test('saveAvatar writes json to secure storage under child key', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      const config = AvatarConfig(
        characterId: 'jaguar',
        backgroundId: 'solar',
        accessoryId: 'corona_solar',
        expressionId: 'sonriente',
      );

      await avatarStorage.saveAvatar(15, config);

      verify(() => mockStorage.write(
            key: 'child_avatar_15',
            value: any(that: contains('"characterId":"jaguar"'), named: 'value'),
          )).called(1);
    });
  });
}
