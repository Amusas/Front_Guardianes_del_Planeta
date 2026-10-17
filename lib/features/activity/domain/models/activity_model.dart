import 'dart:convert';
import 'package:flutter/foundation.dart';

enum ActivityType {
  multipleChoice,
  trueFalse,
  classification,
  ordering,
  dragAndDrop,
  unknown;

  static ActivityType fromString(String? typeStr) {
    switch (typeStr?.toUpperCase()) {
      case 'MULTIPLE_CHOICE':
        return ActivityType.multipleChoice;
      case 'TRUE_FALSE':
        return ActivityType.trueFalse;
      case 'CLASSIFICATION':
        return ActivityType.classification;
      case 'ORDERING':
        return ActivityType.ordering;
      case 'DRAG_AND_DROP':
        return ActivityType.dragAndDrop;
      default:
        return ActivityType.unknown;
    }
  }

  String get displayName {
    switch (this) {
      case ActivityType.multipleChoice:
        return 'Selección Múltiple';
      case ActivityType.trueFalse:
        return 'Verdadero o Falso';
      case ActivityType.classification:
        return 'Clasificación';
      case ActivityType.ordering:
        return 'Secuencia y Orden';
      case ActivityType.dragAndDrop:
        return 'Ubicar en el Ecosistema';
      case ActivityType.unknown:
        return 'Actividad';
    }
  }
}

class ActivityModel {
  final int id;
  final int lessonId;
  final ActivityType type;
  final String title;
  final String configurationJson;
  final int xpReward;
  final int orderIndex;
  final Map<String, dynamic> config;

  const ActivityModel({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.title,
    required this.configurationJson,
    required this.xpReward,
    required this.orderIndex,
    required this.config,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString();
    final rawConfig = json['configurationJson'] ?? json['config'] ?? json['configuration'];

    String configRaw = '{}';
    Map<String, dynamic> parsedConfig = {};

    try {
      if (rawConfig is Map) {
        parsedConfig = Map<String, dynamic>.from(rawConfig);
        configRaw = jsonEncode(parsedConfig);
      } else if (rawConfig is String && rawConfig.trim().isNotEmpty) {
        configRaw = rawConfig;
        dynamic decoded = jsonDecode(rawConfig);
        if (decoded is String) {
          decoded = jsonDecode(decoded);
        }
        if (decoded is Map) {
          parsedConfig = Map<String, dynamic>.from(decoded);
        }
      }
    } catch (e) {
      debugPrint('Error parsing activity configuration: $e');
    }

    return ActivityModel(
      id: (json['id'] is num) ? (json['id'] as num).toInt() : 0,
      lessonId: (json['lessonId'] is num) ? (json['lessonId'] as num).toInt() : 0,
      type: ActivityType.fromString(rawType),
      title: json['title']?.toString() ?? '',
      configurationJson: configRaw,
      xpReward: (json['xpReward'] is num) ? (json['xpReward'] as num).toInt() : 10,
      orderIndex: (json['orderIndex'] is num) ? (json['orderIndex'] as num).toInt() : 1,
      config: parsedConfig,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lessonId': lessonId,
    'type': type.name,
    'title': title,
    'configurationJson': configurationJson,
    'xpReward': xpReward,
    'orderIndex': orderIndex,
  };

  /// Pregunta, enunciado o instrucción principal
  String get questionOrInstruction {
    if (config.containsKey('question') && config['question'] != null) {
      return config['question'].toString();
    }
    if (config.containsKey('statement') && config['statement'] != null) {
      return config['statement'].toString();
    }
    if (config.containsKey('prompt') && config['prompt'] != null) {
      return config['prompt'].toString();
    }
    if (config.containsKey('instructions') && config['instructions'] != null) {
      return config['instructions'].toString();
    }
    if (config.containsKey('instruction') && config['instruction'] != null) {
      return config['instruction'].toString();
    }
    if (title.isNotEmpty) {
      return title;
    }
    return 'Completa la actividad ambiental';
  }

  /// Pista o sugerencia educativa si existe
  String get hint {
    if (config.containsKey('hint') && config['hint'] != null) {
      return config['hint'].toString();
    }
    if (config.containsKey('difficulty') && config['difficulty'] != null) {
      return 'Nivel: ${config['difficulty']}. Observa con atención cada detalle.';
    }
    return 'Tómate tu tiempo y piensa en lo aprendido durante la exploración.';
  }

  /// Opciones en formato String para MULTIPLE_CHOICE o TRUE_FALSE
  List<String> get stringOptions {
    if (config.containsKey('options') && config['options'] is List) {
      return (config['options'] as List).map((e) {
        if (e is Map && e.containsKey('name')) {
          return e['name'].toString();
        }
        if (e is Map && e.containsKey('text')) {
          return e['text'].toString();
        }
        return e.toString();
      }).toList();
    }
    if (type == ActivityType.trueFalse) {
      return const ['Verdadero', 'Falso'];
    }
    return const [];
  }

  /// Categorías para CLASSIFICATION
  List<Map<String, String>> get classificationCategories {
    if (config.containsKey('categories') && config['categories'] is List) {
      final list = config['categories'] as List;
      return list.map((e) {
        if (e is Map) {
          return {
            'id': e['id']?.toString() ?? '',
            'name': e['name']?.toString() ?? '',
          };
        }
        return {'id': e.toString(), 'name': e.toString()};
      }).toList();
    }
    return const [];
  }

  /// Ítems para CLASSIFICATION
  List<Map<String, String>> get classificationItems {
    if (config.containsKey('items') && config['items'] is List) {
      final list = config['items'] as List;
      return list.map((e) {
        if (e is Map) {
          return {
            'id': e['id']?.toString() ?? '',
            'name': e['name']?.toString() ?? '',
          };
        }
        return {'id': e.toString(), 'name': e.toString()};
      }).toList();
    }
    return const [];
  }

  /// Respuestas correctas esperadas para CLASSIFICATION
  Map<String, String> get classificationCorrectAnswers {
    if (config.containsKey('correctAnswers') && config['correctAnswers'] is Map) {
      final map = config['correctAnswers'] as Map;
      return map.map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return const {};
  }

  /// Pasos para ORDERING
  List<String> get orderingSteps {
    if (config.containsKey('steps') && config['steps'] is List) {
      return (config['steps'] as List).map((e) => e.toString()).toList();
    }
    return const [];
  }

  /// Secuencia correcta de índices para ORDERING
  List<int> get orderingCorrectSequence {
    if (config.containsKey('correctSequence') && config['correctSequence'] is List) {
      return (config['correctSequence'] as List)
          .map((e) => (e is num) ? e.toInt() : int.tryParse(e.toString()) ?? 0)
          .toList();
    }
    return List.generate(orderingSteps.length, (i) => i);
  }

  /// Zonas destino para DRAG_AND_DROP
  List<Map<String, String>> get dragTargets {
    if (config.containsKey('targets') && config['targets'] is List) {
      final list = config['targets'] as List;
      return list.map((e) {
        if (e is Map) {
          return {
            'zone': e['zone']?.toString() ?? '',
            'name': e['name']?.toString() ?? '',
          };
        }
        return {'zone': e.toString(), 'name': e.toString()};
      }).toList();
    }
    return const [];
  }

  /// Elementos para DRAG_AND_DROP
  List<Map<String, String>> get dragElements {
    if (config.containsKey('elements') && config['elements'] is List) {
      final list = config['elements'] as List;
      return list.map((e) {
        if (e is Map) {
          return {
            'id': e['id']?.toString() ?? '',
            'name': e['name']?.toString() ?? '',
          };
        }
        return {'id': e.toString(), 'name': e.toString()};
      }).toList();
    }
    return const [];
  }

  /// Mapeo correcto para DRAG_AND_DROP: {elementId: zoneId}
  Map<String, String> get dragCorrectAnswers {
    if (config.containsKey('correctAnswers') && config['correctAnswers'] is Map) {
      final map = config['correctAnswers'] as Map;
      return map.map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return const {};
  }

  /// Evalúa localmente si una respuesta dada es correcta
  bool evaluateAnswer(dynamic answer) {
    if (answer == null) return false;

    switch (type) {
      case ActivityType.multipleChoice:
      case ActivityType.trueFalse:
        // Puede venir como index (int) o texto (String)
        if (answer is int) {
          if (config.containsKey('correctOption')) {
            final correctOption = config['correctOption'];
            return (correctOption is num && correctOption.toInt() == answer);
          }
          if (config.containsKey('correctAnswer')) {
            final options = stringOptions;
            if (answer >= 0 && answer < options.length) {
              return options[answer].trim().toLowerCase() ==
                  config['correctAnswer'].toString().trim().toLowerCase();
            }
          }
        } else if (answer is String) {
          if (config.containsKey('correctAnswer')) {
            return config['correctAnswer'].toString().trim().toLowerCase() ==
                answer.trim().toLowerCase();
          }
          if (config.containsKey('correctOption')) {
            final options = stringOptions;
            final correctIdx = (config['correctOption'] as num).toInt();
            if (correctIdx >= 0 && correctIdx < options.length) {
              return options[correctIdx].trim().toLowerCase() ==
                  answer.trim().toLowerCase();
            }
          }
        }
        return false;

      case ActivityType.classification:
        if (answer is Map) {
          final expected = classificationCorrectAnswers;
          if (expected.isEmpty) return true;
          for (final entry in expected.entries) {
            if (answer[entry.key]?.toString().toLowerCase() !=
                entry.value.toLowerCase()) {
              return false;
            }
          }
          return true;
        }
        return false;

      case ActivityType.ordering:
        if (answer is List<int>) {
          final expected = orderingCorrectSequence;
          if (answer.length != expected.length) return false;
          for (int i = 0; i < answer.length; i++) {
            if (answer[i] != expected[i]) return false;
          }
          return true;
        }
        return false;

      case ActivityType.dragAndDrop:
        if (answer is Map) {
          final expected = dragCorrectAnswers;
          if (expected.isEmpty) return true;
          for (final entry in expected.entries) {
            if (answer[entry.key]?.toString().toLowerCase() !=
                entry.value.toLowerCase()) {
              return false;
            }
          }
          return true;
        }
        return false;

      case ActivityType.unknown:
        return true;
    }
  }

  /// Construye el mapa de respuesta JSON exactamente como lo espera ActivityEvaluator.java en el backend
  Map<String, dynamic> buildBackendAttemptPayload(dynamic answer) {
    switch (type) {
      case ActivityType.multipleChoice:
      case ActivityType.trueFalse:
        String textAnswer = '';
        int optionIndex = 0;
        if (answer is int) {
          optionIndex = answer;
          final opts = stringOptions;
          if (answer >= 0 && answer < opts.length) {
            textAnswer = opts[answer];
          }
        } else if (answer is String) {
          textAnswer = answer;
          final opts = stringOptions;
          final idx = opts.indexOf(answer);
          optionIndex = idx >= 0 ? idx : 0;
        }
        return {
          'answer': textAnswer,
          'option': optionIndex,
        };

      case ActivityType.ordering:
        List<int> sequence = [];
        if (answer is List<int>) {
          sequence = answer;
        } else if (answer is List) {
          sequence = answer.map((e) => (e is num) ? e.toInt() : int.tryParse(e.toString()) ?? 0).toList();
        }
        return {
          'sequence': sequence,
        };

      case ActivityType.classification:
      case ActivityType.dragAndDrop:
        Map<String, String> answersMap = {};
        if (answer is Map) {
          answersMap = answer.map((k, v) => MapEntry(k.toString(), v.toString()));
        }
        return {
          'answers': answersMap,
        };

      case ActivityType.unknown:
        return {
          'answer': answer?.toString() ?? 'COMPLETED',
        };
    }
  }
}

