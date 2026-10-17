import 'package:flutter/material.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/models/lesson_node_model.dart';
import '../models/lesson_response_model.dart';

class LessonMapper {
  LessonMapper._();

  static const List<double> _snakeOffsets = [
    -0.15,
    0.35,
    -0.30,
    0.20,
    -0.25,
    0.30,
    0.00,
    -0.20,
    0.25,
    -0.35,
  ];

  /// Convierte un DTO de respuesta a la Entidad de Dominio
  static Lesson toDomain(LessonResponseModel model) {
    return Lesson(
      id: model.id,
      ecosystemId: model.ecosystemId,
      title: model.title,
      content: model.content,
      orderIndex: model.orderIndex,
      xpReward: model.xpReward,
      isActive: model.isActive,
    );
  }

  /// Convierte una lista de DTOs a lista de Entidades de Dominio
  static List<Lesson> toDomainList(List<LessonResponseModel> dtos) {
    return dtos.map(toDomain).toList();
  }

  /// Determina el icono temático para una lección según su título o contenido
  static IconData resolveIcon(String title, String content, bool isLast) {
    if (isLast) return Icons.emoji_events_rounded;
    final lower = '${title.toLowerCase()} ${content.toLowerCase()}';
    if (lower.contains('árbol') || lower.contains('bosque') || lower.contains('planta')) {
      return Icons.park_rounded;
    }
    if (lower.contains('agua') || lower.contains('río') || lower.contains('rio') || lower.contains('ciclo')) {
      return Icons.water_drop_rounded;
    }
    if (lower.contains('hoja') || lower.contains('flora') || lower.contains('vegetac')) {
      return Icons.energy_savings_leaf_rounded;
    }
    if (lower.contains('animal') || lower.contains('fauna') || lower.contains('oso') || lower.contains('ave')) {
      return Icons.pets_rounded;
    }
    if (lower.contains('recicla') || lower.contains('residuo') || lower.contains('limpieza')) {
      return Icons.recycling_rounded;
    }
    if (lower.contains('océano') || lower.contains('oceano') || lower.contains('mar') || lower.contains('olas')) {
      return Icons.waves_rounded;
    }
    if (lower.contains('sol') || lower.contains('clima') || lower.contains('energía')) {
      return Icons.wb_sunny_rounded;
    }
    return Icons.eco_rounded;
  }

  /// Convierte una lista ordenada de [Lesson] a la lista visual [LessonNodeModel]
  /// con camino sinuoso y estados secuenciales.
  static List<LessonNodeModel> toNodeList(
    List<Lesson> lessons, {
    int completedCount = 0,
    Set<int>? completedLessonIds,
  }) {
    final List<LessonNodeModel> nodes = [];
    final completedSet = completedLessonIds ?? {};
    int firstActiveIndex = -1;

    for (int i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      final isLast = i == lessons.length - 1;

      // Calcular desplazamiento horizontal sinusoidal para el mapa serpenteante
      final offsetIndex = (lesson.orderIndex > 0 ? lesson.orderIndex - 1 : i) % _snakeOffsets.length;
      final xOffset = _snakeOffsets[offsetIndex];

      // Determinar estado gamificado
      LessonNodeState state;
      if (completedSet.isNotEmpty) {
        if (completedSet.contains(lesson.id)) {
          state = LessonNodeState.completed;
        } else if (firstActiveIndex == -1) {
          firstActiveIndex = i;
          state = LessonNodeState.active;
        } else {
          state = LessonNodeState.locked;
        }
      } else {
        if (i < completedCount) {
          state = LessonNodeState.completed;
        } else if (i == completedCount) {
          state = LessonNodeState.active;
        } else {
          state = LessonNodeState.locked;
        }
      }

      nodes.add(
        LessonNodeModel(
          id: lesson.id,
          title: lesson.title,
          description: lesson.content,
          state: state,
          icon: resolveIcon(lesson.title, lesson.content, isLast),
          xpReward: lesson.xpReward,
          xOffsetFraction: xOffset,
        ),
      );
    }

    return nodes;
  }
}
