import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../auth/data/models/auth_models.dart';
import '../../domain/models/activity_model.dart';
import '../../domain/models/activity_attempt_model.dart';

abstract class ActivityRemoteDataSource {
  Future<List<ActivityModel>> getActivitiesByLessonId(int lessonId);
  Future<ActivityAttemptResponseModel> submitAttempt(int activityId, Map<String, dynamic> payload);
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final ApiClient _apiClient;

  ActivityRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<ActivityModel>> getActivitiesByLessonId(int lessonId) async {
    try {
      AppLogger.debug('DEBUG: Consultando actividades para la lección $lessonId en GET /api/v1/lessons/$lessonId/activities');
      final response = await _apiClient.dio.get('/api/v1/lessons/$lessonId/activities');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data as List<dynamic>
            : (response.data['data'] as List<dynamic>? ?? []);

        final list = data
            .map((item) => ActivityModel.fromJson(item as Map<String, dynamic>))
            .toList();

        list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
        AppLogger.debug('DEBUG: Se recibieron ${list.length} actividades remotas para la lección $lessonId.');

        if (list.isEmpty) {
          AppLogger.debug('DEBUG: Backend devolvió lista vacía, usando actividades educativas de respaldo para lección $lessonId.');
          return _getFallbackActivities(lessonId);
        }

        return list;
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      AppLogger.warning('WARN: Error de red o servidor al consultar actividades (${e.message}). Activando respaldo educativo.');
      return _getFallbackActivities(lessonId);
    } catch (e) {
      AppLogger.error('ERROR: Error inesperado al cargar actividades de la lección $lessonId.', e);
      return _getFallbackActivities(lessonId);
    }
  }

  @override
  Future<ActivityAttemptResponseModel> submitAttempt(int activityId, Map<String, dynamic> payload) async {
    try {
      AppLogger.info('INFO: Enviando intento de actividad $activityId a POST /api/v1/activities/$activityId/attempts con payload: $payload');
      final response = await _apiClient.dio.post(
        '/api/v1/activities/$activityId/attempts',
        data: {
          'response': payload,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : (response.data['data'] as Map<String, dynamic>? ?? {});
        AppLogger.info('INFO: Intento registrado exitosamente. isCorrect: ${data['isCorrect']}, xpAwarded: ${data['xpAwarded']}');
        return ActivityAttemptResponseModel.fromJson(data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      AppLogger.warning('WARN: Fallo de red en intento de actividad ($activityId): ${e.message}.');
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('ERROR: Error al enviar intento de actividad $activityId.', e);
      rethrow;
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return Exception('No se pudo conectar con el servidor.');
    }
    if (e.response != null) {
      return _handleError(e.response!);
    }
    return Exception(e.message ?? 'Error de red inesperado.');
  }

  Exception _handleError(Response response) {
    try {
      if (response.data is Map<String, dynamic>) {
        final errorDto = ErrorResponseDto.fromJson(response.data);
        return Exception(errorDto.message);
      }
    } catch (_) {}
    return Exception('Error del servidor al obtener las actividades. Código: ${response.statusCode}');
  }

  List<ActivityModel> _getFallbackActivities(int lessonId) {
    return [
      // 1. MULTIPLE_CHOICE
      ActivityModel.fromJson({
        'id': 1,
        'lessonId': lessonId,
        'type': 'MULTIPLE_CHOICE',
        'title': '¿Dónde vive el oso de anteojos?',
        'configurationJson': '''
{
  "question": "¿Dónde vive el oso de anteojos?",
  "options": ["En el desierto caliente", "En el bosque andino y de niebla", "En el fondo del mar"],
  "correctAnswer": "En el bosque andino y de niebla",
  "correctOption": 1,
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 1,
      }),

      // 2. TRUE_FALSE
      ActivityModel.fromJson({
        'id': 2,
        'lessonId': lessonId,
        'type': 'TRUE_FALSE',
        'title': 'El bosque andino es hogar de muchos animales',
        'configurationJson': '''
{
  "statement": "El bosque andino es hogar de muchos animales, aves e insectos.",
  "options": ["Verdadero", "Falso"],
  "correctAnswer": "Verdadero",
  "correctOption": 0,
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 2,
      }),

      // 3. CLASSIFICATION
      ActivityModel.fromJson({
        'id': 3,
        'lessonId': lessonId,
        'type': 'CLASSIFICATION',
        'title': '¿Quiénes viven en el bosque?',
        'configurationJson': '''
{
  "instructions": "Separa los seres vivos del bosque de los objetos que no son vivos:",
  "categories": [
    {"id": "vivos", "name": "Seres vivos del bosque"},
    {"id": "no_vivos", "name": "Objetos no vivos"}
  ],
  "items": [
    {"id": "oso", "name": "Oso de anteojos"},
    {"id": "palma", "name": "Palma de cera"},
    {"id": "botella", "name": "Botella plástica"},
    {"id": "llanta", "name": "Llanta vieja"}
  ],
  "correctAnswers": {
    "oso": "vivos",
    "palma": "vivos",
    "botella": "no_vivos",
    "llanta": "no_vivos"
  },
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 3,
      }),

      // 4. ORDERING
      ActivityModel.fromJson({
        'id': 4,
        'lessonId': lessonId,
        'type': 'ORDERING',
        'title': 'El camino del agua',
        'configurationJson': '''
{
  "instructions": "Organiza los tres pasos sobre cómo el agua de la lluvia llega a una quebrada:",
  "steps": [
    "La lluvia cae sobre las hojas y el musgo",
    "El agua se infiltra y viaja por el suelo",
    "El agua brota limpia en la quebrada"
  ],
  "correctSequence": [0, 1, 2],
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 4,
      }),

      // 5. DRAG_AND_DROP
      ActivityModel.fromJson({
        'id': 5,
        'lessonId': lessonId,
        'type': 'DRAG_AND_DROP',
        'title': 'Construye tu bosque andino',
        'configurationJson': '''
{
  "instructions": "Ubica cada elemento en su lugar correcto dentro del hábitat:",
  "targets": [
    {"zone": "bosque", "name": "El Bosque"},
    {"zone": "agua", "name": "La Quebrada"},
    {"zone": "rama", "name": "Las Ramas"}
  ],
  "elements": [
    {"id": "arbol", "name": "Árbol nativo"},
    {"id": "pez", "name": "Pez de montaña"},
    {"id": "ave", "name": "Pájaro andino"}
  ],
  "correctAnswers": {
    "arbol": "bosque",
    "pez": "agua",
    "ave": "rama"
  },
  "difficulty": "Muy fácil"
}''',
        'xpReward': 10,
        'orderIndex': 5,
      }),
    ];
  }
}
