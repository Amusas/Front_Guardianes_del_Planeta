import 'package:flutter/material.dart';
import '../domain/models/lesson_node_model.dart';

class ExplorationMockData {
  static final List<LessonNodeModel> bosqueAndinoNodes = [
    const LessonNodeModel(
      id: 1,
      title: 'Los habitantes del bosque',
      description: 'Conoce los insectos y plantas del dosel andino.',
      state: LessonNodeState.completed,
      icon: Icons.park_rounded,
      xOffsetFraction: -0.15,
    ),
    const LessonNodeModel(
      id: 2,
      title: 'El ciclo del agua',
      description: 'Aprende cómo las nubes y bosques alimentan los ríos.',
      state: LessonNodeState.completed,
      icon: Icons.water_drop_rounded,
      xOffsetFraction: 0.35,
    ),
    const LessonNodeModel(
      id: 3,
      title: 'Guardianes de los árboles',
      description: 'Protege las palmas de cera de la deforestación.',
      state: LessonNodeState.completed,
      icon: Icons.energy_savings_leaf_rounded,
      xOffsetFraction: -0.30,
    ),
    const LessonNodeModel(
      id: 4,
      title: 'Animales de los Andes',
      description: 'Rastrea las huellas del oso de anteojos y el cóndor.',
      state: LessonNodeState.active, // Nodo activo con pulso verde brillante
      icon: Icons.pets_rounded,
      xOffsetFraction: 0.20,
    ),
    const LessonNodeModel(
      id: 5,
      title: 'Reciclaje responsable',
      description: 'Clasifica los residuos y limpia los senderos naturales.',
      state: LessonNodeState.locked,
      icon: Icons.recycling_rounded,
      xOffsetFraction: -0.25,
    ),
    const LessonNodeModel(
      id: 6,
      title: 'Cuidemos los ríos',
      description: 'Evita la contaminación y salva la fauna acuática.',
      state: LessonNodeState.locked,
      icon: Icons.waves_rounded,
      xOffsetFraction: 0.30,
    ),
    const LessonNodeModel(
      id: 7,
      title: 'Reto final del Bosque Andino',
      description: 'Demuestra todo tu conocimiento para ser Guardián Mayor.',
      state: LessonNodeState.locked,
      icon: Icons.emoji_events_rounded,
      xOffsetFraction: 0.0,
    ),
  ];
}
