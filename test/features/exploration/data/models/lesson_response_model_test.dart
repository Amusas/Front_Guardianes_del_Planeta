import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/exploration/data/models/lesson_response_model.dart';
import 'package:guardianes_del_planeta/features/exploration/data/mappers/lesson_mapper.dart';
import 'package:guardianes_del_planeta/features/exploration/domain/models/lesson_node_model.dart';

void main() {
  group('LessonResponseModel Tests', () {
    test('fromJson correctly parses complete JSON', () {
      final json = {
        'id': 1,
        'ecosystemId': 2,
        'title': 'Introducción al Reciclaje',
        'content': 'En esta lección aprenderemos sobre la clasificación de residuos.',
        'orderIndex': 1,
        'xpReward': 50,
        'isActive': true,
      };

      final model = LessonResponseModel.fromJson(json);

      expect(model.id, 1);
      expect(model.ecosystemId, 2);
      expect(model.title, 'Introducción al Reciclaje');
      expect(model.content, 'En esta lección aprenderemos sobre la clasificación de residuos.');
      expect(model.orderIndex, 1);
      expect(model.xpReward, 50);
      expect(model.isActive, true);
    });

    test('toJson produces valid map matching backend contract', () {
      const model = LessonResponseModel(
        id: 10,
        ecosystemId: 3,
        title: 'Guardianes del Agua',
        content: 'Cuida los ríos y océanos.',
        orderIndex: 2,
        xpReward: 100,
        isActive: true,
      );

      final json = model.toJson();

      expect(json['id'], 10);
      expect(json['ecosystemId'], 3);
      expect(json['title'], 'Guardianes del Agua');
      expect(json['orderIndex'], 2);
      expect(json['xpReward'], 100);
      expect(json['isActive'], true);
    });
  });

  group('LessonMapper Tests', () {
    test('toDomain maps DTO to Lesson entity accurately', () {
      const dto = LessonResponseModel(
        id: 5,
        ecosystemId: 1,
        title: 'Flora Andina',
        content: 'Plantas nativas de alta montaña.',
        orderIndex: 1,
        xpReward: 60,
        isActive: true,
      );

      final entity = LessonMapper.toDomain(dto);

      expect(entity.id, dto.id);
      expect(entity.ecosystemId, dto.ecosystemId);
      expect(entity.title, dto.title);
      expect(entity.content, dto.content);
      expect(entity.orderIndex, dto.orderIndex);
      expect(entity.xpReward, dto.xpReward);
      expect(entity.isActive, dto.isActive);
    });

    test('toNodeList transforms lessons to LessonNodeModel with snake offsets and states', () {
      final lessons = [
        const LessonResponseModel(
          id: 1,
          ecosystemId: 1,
          title: 'Lección 1',
          content: 'Contenido 1',
          orderIndex: 1,
          xpReward: 50,
          isActive: true,
        ),
        const LessonResponseModel(
          id: 2,
          ecosystemId: 1,
          title: 'Lección 2',
          content: 'Contenido 2',
          orderIndex: 2,
          xpReward: 50,
          isActive: true,
        ),
        const LessonResponseModel(
          id: 3,
          ecosystemId: 1,
          title: 'Reto Final',
          content: 'Contenido 3',
          orderIndex: 3,
          xpReward: 100,
          isActive: true,
        ),
      ].map(LessonMapper.toDomain).toList();

      final nodes = LessonMapper.toNodeList(lessons, completedCount: 1);

      expect(nodes.length, 3);
      // Nodo 0 debe estar completado
      expect(nodes[0].state, LessonNodeState.completed);
      // Nodo 1 debe estar activo
      expect(nodes[1].state, LessonNodeState.active);
      // Nodo 2 debe estar bloqueado
      expect(nodes[2].state, LessonNodeState.locked);

      // Desplazamiento xOffsetFraction no debe ser nulo
      expect(nodes[0].xOffsetFraction, isNotNull);
      expect(nodes[1].xOffsetFraction, isNotNull);
    });
  });
}
