import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../auth/data/models/auth_models.dart';
import '../models/lesson_response_model.dart';

abstract class LessonRemoteDataSource {
  Future<List<LessonResponseModel>> getLessonsByEcosystem(int ecosystemId);
  Future<void> completeLesson(int lessonId);
  Future<List<int>> getCompletedLessonIds();
}

class LessonRemoteDataSourceImpl implements LessonRemoteDataSource {
  final ApiClient _apiClient;

  LessonRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<LessonResponseModel>> getLessonsByEcosystem(int ecosystemId) async {
    try {
      AppLogger.debug('DEBUG: Consultando lecciones para el ecosistema $ecosystemId.');
      final response = await _apiClient.dio.get('/api/v1/ecosystems/$ecosystemId/lessons');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data as List<dynamic>
            : (response.data['data'] as List<dynamic>? ?? []);

        final list = data
            .map((item) => LessonResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // Asegurar ordenamiento por orderIndex
        list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

        AppLogger.debug('DEBUG: Se recibieron ${list.length} lecciones para el ecosistema $ecosystemId.');
        return list;
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('ERROR: No fue posible cargar las lecciones del ecosistema $ecosystemId.', e);
      throw Exception('Ha ocurrido un error inesperado al cargar las lecciones de la ruta.');
    }
  }

  @override
  Future<void> completeLesson(int lessonId) async {
    try {
      AppLogger.info('INFO: Registrando completitud de lección $lessonId en el servidor.');
      final response = await _apiClient.dio.post('/api/v1/lessons/$lessonId/complete');
      if (response.statusCode != 200) {
        throw _handleError(response);
      }
      AppLogger.info('INFO: Lección $lessonId marcada como completada con éxito.');
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('ERROR: No fue posible registrar completitud de lección $lessonId.', e);
      throw Exception('Ha ocurrido un error al guardar el progreso de la lección.');
    }
  }

  @override
  Future<List<int>> getCompletedLessonIds() async {
    try {
      AppLogger.debug('DEBUG: Consultando lecciones completadas por el usuario actual.');
      final response = await _apiClient.dio.get('/api/v1/lessons/progress/me');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data as List<dynamic> : [];
        final list = data.map((item) => (item as num).toInt()).toList();
        AppLogger.debug('DEBUG: Lecciones completadas recuperadas: $list');
        return list;
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('ERROR: Falló la consulta de lecciones completadas.', e);
      return [];
    }
  }

  Exception _handleError(Response response) {
    try {
      if (response.data is Map<String, dynamic>) {
        final errorDto = ErrorResponseDto.fromJson(response.data);
        return Exception(errorDto.message);
      }
    } catch (_) {}
    return Exception('Error del servidor al obtener las lecciones. Código: ${response.statusCode}');
  }

  Exception _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      AppLogger.error('ERROR: Tiempo de espera agotado al conectar con el servidor para lecciones.', e);
      return Exception('El servidor está tardando demasiado en responder. Verifica tu conexión.');
    } else if (e.type == DioExceptionType.connectionError) {
      AppLogger.error('ERROR: No se pudo conectar con el servidor para obtener lecciones.', e);
      return Exception('No se pudo establecer conexión con el servidor.');
    } else if (e.response != null) {
      final statusCode = e.response!.statusCode;
      if (statusCode == 401) {
        AppLogger.warning('WARNING: Sesión expirada o no autorizada al consultar lecciones.');
        return Exception('Sesión expirada. Por favor, inicia sesión de nuevo.');
      } else if (statusCode == 403) {
        AppLogger.warning('WARNING: Acceso prohibido a las lecciones del ecosistema.');
        return Exception('No tienes permisos para acceder a estas lecciones.');
      } else if (statusCode == 404) {
        AppLogger.warning('WARNING: Ecosistema o lecciones no encontradas (404).');
        return Exception('No se encontraron lecciones registradas para este ecosistema.');
      }
      return _handleError(e.response!);
    }
    return Exception('Error de red al consultar lecciones: ${e.message}');
  }
}
