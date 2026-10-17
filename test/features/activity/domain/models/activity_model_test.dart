import 'package:flutter_test/flutter_test.dart';
import 'package:guardianes_del_planeta/features/activity/domain/models/activity_model.dart';

void main() {
  group('ActivityModel & ActivityType Tests', () {
    test('ActivityType.fromString maps all 5 backend types and unknown', () {
      expect(ActivityType.fromString('MULTIPLE_CHOICE'), ActivityType.multipleChoice);
      expect(ActivityType.fromString('TRUE_FALSE'), ActivityType.trueFalse);
      expect(ActivityType.fromString('CLASSIFICATION'), ActivityType.classification);
      expect(ActivityType.fromString('ORDERING'), ActivityType.ordering);
      expect(ActivityType.fromString('DRAG_AND_DROP'), ActivityType.dragAndDrop);
      expect(ActivityType.fromString('IDENTIFICATION'), ActivityType.unknown);
      expect(ActivityType.fromString('SOMETHING_NEW'), ActivityType.unknown);
      expect(ActivityType.fromString(null), ActivityType.unknown);
    });

    test('Multiple Choice Activity parsing and evaluation', () {
      final activity = ActivityModel.fromJson({
        'id': 1,
        'lessonId': 10,
        'type': 'MULTIPLE_CHOICE',
        'title': '¿Dónde vive el oso?',
        'configurationJson': '{"question":"¿Dónde vive el oso?","options":["Desierto","Bosque","Mar"],"correctOption":1,"correctAnswer":"Bosque"}',
        'xpReward': 25,
        'orderIndex': 1,
      });

      expect(activity.id, 1);
      expect(activity.lessonId, 10);
      expect(activity.type, ActivityType.multipleChoice);
      expect(activity.stringOptions, ['Desierto', 'Bosque', 'Mar']);
      expect(activity.evaluateAnswer(1), isTrue);
      expect(activity.evaluateAnswer(0), isFalse);
      expect(activity.evaluateAnswer('Bosque'), isTrue);
      expect(activity.evaluateAnswer('Desierto'), isFalse);
    });

    test('True False Activity parsing and evaluation', () {
      final activity = ActivityModel.fromJson({
        'id': 2,
        'lessonId': 10,
        'type': 'TRUE_FALSE',
        'title': 'El bosque es hogar de muchos animales',
        'configurationJson': '{"statement":"El bosque es hogar de muchos animales.","options":["Verdadero","Falso"],"correctOption":0,"correctAnswer":"Verdadero"}',
        'xpReward': 10,
        'orderIndex': 2,
      });

      expect(activity.type, ActivityType.trueFalse);
      expect(activity.evaluateAnswer(0), isTrue);
      expect(activity.evaluateAnswer(1), isFalse);
      expect(activity.evaluateAnswer('Verdadero'), isTrue);
      expect(activity.evaluateAnswer('Falso'), isFalse);
    });

    test('Classification Activity parsing and evaluation', () {
      final activity = ActivityModel.fromJson({
        'id': 4,
        'lessonId': 10,
        'type': 'CLASSIFICATION',
        'title': 'Clasifica seres vivos y objetos',
        'configurationJson': '{"categories":[{"id":"vivos","name":"Vivos"},{"id":"no_vivos","name":"No vivos"}],"items":[{"id":"oso","name":"Oso"},{"id":"botella","name":"Botella"}],"correctAnswers":{"oso":"vivos","botella":"no_vivos"}}',
        'xpReward': 10,
        'orderIndex': 4,
      });

      expect(activity.type, ActivityType.classification);
      expect(activity.classificationCategories.length, 2);
      expect(activity.classificationItems.length, 2);
      expect(activity.evaluateAnswer({'oso': 'vivos', 'botella': 'no_vivos'}), isTrue);
      expect(activity.evaluateAnswer({'oso': 'no_vivos', 'botella': 'no_vivos'}), isFalse);
    });

    test('Ordering Activity parsing and evaluation', () {
      final activity = ActivityModel.fromJson({
        'id': 5,
        'lessonId': 10,
        'type': 'ORDERING',
        'title': 'El camino del agua',
        'configurationJson': '{"steps":["Paso 1","Paso 2","Paso 3"],"correctSequence":[0,1,2]}',
        'xpReward': 10,
        'orderIndex': 5,
      });

      expect(activity.type, ActivityType.ordering);
      expect(activity.orderingSteps.length, 3);
      expect(activity.evaluateAnswer([0, 1, 2]), isTrue);
      expect(activity.evaluateAnswer([2, 1, 0]), isFalse);
    });

    test('Drag and Drop Activity parsing and evaluation', () {
      final activity = ActivityModel.fromJson({
        'id': 6,
        'lessonId': 10,
        'type': 'DRAG_AND_DROP',
        'title': 'Ubica en el hábitat',
        'configurationJson': '{"targets":[{"zone":"bosque","name":"Bosque"}],"elements":[{"id":"arbol","name":"Árbol"}],"correctAnswers":{"arbol":"bosque"}}',
        'xpReward': 10,
        'orderIndex': 6,
      });

      expect(activity.type, ActivityType.dragAndDrop);
      expect(activity.evaluateAnswer({'arbol': 'bosque'}), isTrue);
      expect(activity.evaluateAnswer({'arbol': 'mar'}), isFalse);
    });
  });
}
