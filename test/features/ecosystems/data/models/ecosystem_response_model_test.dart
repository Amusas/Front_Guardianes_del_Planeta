import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/ecosystems/data/models/ecosystem_response_model.dart';
import 'package:guardianes_del_planeta/features/ecosystems/data/mappers/ecosystem_mapper.dart';
import 'package:guardianes_del_planeta/features/ecosystems/domain/entities/ecosystem.dart';

void main() {
  group('EcosystemResponseModel & Mapper Tests', () {
    test('fromJson parses full JSON correctly', () {
      final json = {
        'id': 1,
        'code': 'BOSQUE_ANDINO',
        'name': 'Bosque Andino',
        'description': 'Un ecosistema de montaña con gran biodiversidad.',
        'requiredLevelId': 1,
        'mascotKey': 'oso_anteojos',
        'isActive': true,
      };

      final model = EcosystemResponseModel.fromJson(json);

      expect(model.id, 1);
      expect(model.code, 'BOSQUE_ANDINO');
      expect(model.name, 'Bosque Andino');
      expect(model.description, 'Un ecosistema de montaña con gran biodiversidad.');
      expect(model.requiredLevelId, 1);
      expect(model.mascotKey, 'oso_anteojos');
      expect(model.isActive, isTrue);
    });

    test('fromJson handles null optional fields gracefully', () {
      final json = {
        'id': 2,
        'code': 'PARAMO',
        'name': 'Páramo',
        'description': 'Tierra de niebla.',
      };

      final model = EcosystemResponseModel.fromJson(json);

      expect(model.id, 2);
      expect(model.code, 'PARAMO');
      expect(model.requiredLevelId, isNull);
      expect(model.mascotKey, isNull);
      expect(model.isActive, isTrue);
    });

    test('toJson serializes correctly', () {
      const model = EcosystemResponseModel(
        id: 3,
        code: 'OCEANO',
        name: 'Océano',
        description: 'Mundo marino.',
        isActive: false,
      );

      final json = model.toJson();

      expect(json['id'], 3);
      expect(json['code'], 'OCEANO');
      expect(json['isActive'], isFalse);
    });

    test('EcosystemMapper converts model to domain entity', () {
      const model = EcosystemResponseModel(
        id: 1,
        code: 'BOSQUE_ANDINO',
        name: 'Bosque Andino',
        description: 'Montañas y vida.',
        requiredLevelId: 2,
        mascotKey: 'oso_anteojos',
        isActive: true,
      );

      final entity = EcosystemMapper.toEntity(model);

      expect(entity, isA<Ecosystem>());
      expect(entity.id, 1);
      expect(entity.code, 'BOSQUE_ANDINO');
      expect(entity.name, 'Bosque Andino');
      expect(entity.description, 'Montañas y vida.');
      expect(entity.requiredLevelId, 2);
      expect(entity.mascotKey, 'oso_anteojos');
      expect(entity.isActive, isTrue);
    });

    test('EcosystemMapper converts list of models', () {
      final models = [
        const EcosystemResponseModel(id: 1, code: 'PARAMO', name: 'Páramo', description: 'd1'),
        const EcosystemResponseModel(id: 2, code: 'OCEANO', name: 'Océano', description: 'd2'),
      ];

      final entities = EcosystemMapper.toEntityList(models);

      expect(entities.length, 2);
      expect(entities[0].code, 'PARAMO');
      expect(entities[1].code, 'OCEANO');
    });
  });
}
