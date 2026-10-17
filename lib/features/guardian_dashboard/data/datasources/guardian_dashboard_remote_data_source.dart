import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/logging/app_logger.dart';
import '../models/child_profile_model.dart';
import '../models/guardian_child_dashboard_model.dart';
import '../models/register_child_request_model.dart';

abstract class GuardianDashboardRemoteDataSource {
  Future<List<ChildProfileModel>> getChildren();
  Future<ChildProfileModel> registerChild(RegisterChildRequestModel request);
  Future<GuardianChildDashboardModel> getChildDashboard(int childId);
}

class GuardianDashboardRemoteDataSourceImpl implements GuardianDashboardRemoteDataSource {
  final ApiClient _apiClient;

  GuardianDashboardRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<ChildProfileModel>> getChildren() async {
    try {
      AppLogger.debug('Iniciando consulta remota de niños asociados al acudiente.');
      final response = await _apiClient.dio.get('/api/v1/guardians/me/children');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        AppLogger.info('Consulta completada: se obtuvieron ${data.length} perfiles infantiles.');
        return data.map((item) => ChildProfileModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        AppLogger.warning('Respuesta inesperada al obtener niños: código ${response.statusCode}');
        throw Exception('Error al obtener la lista de niños (Código ${response.statusCode})');
      }
    } on DioException catch (e) {
      _handleDioError(e, 'Error de red al consultar niños asociados');
      rethrow;
    } catch (e, stack) {
      AppLogger.error('Fallo no recuperado al obtener perfiles infantiles', e, stack);
      rethrow;
    }
  }

  @override
  Future<ChildProfileModel> registerChild(RegisterChildRequestModel request) async {
    try {
      AppLogger.debug('Iniciando registro remoto de cuenta infantil: ${request.username}');
      final response = await _apiClient.dio.post(
        '/api/v1/guardians/me/children',
        data: request.toJson(),
      );

      if (response.statusCode == 201) {
        AppLogger.info('Cuenta infantil registrada y asociada exitosamente con ID ${(response.data as Map)['id']}');
        return ChildProfileModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        AppLogger.warning('Respuesta inesperada al registrar niño: código ${response.statusCode}');
        throw Exception('No se pudo registrar la cuenta infantil (Código ${response.statusCode})');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        AppLogger.warning('Nombre de usuario infantil duplicado: ${request.username}');
        throw Exception('El nombre de usuario "${request.username}" ya está registrado. Por favor elige otro.');
      }
      _handleDioError(e, 'Error al registrar la cuenta infantil');
      rethrow;
    } catch (e, stack) {
      AppLogger.error('Fallo no recuperado al crear cuenta infantil', e, stack);
      rethrow;
    }
  }

  @override
  Future<GuardianChildDashboardModel> getChildDashboard(int childId) async {
    try {
      AppLogger.debug('Iniciando consulta remota del dashboard para el niño ID $childId');
      final response = await _apiClient.dio.get('/api/v1/guardians/me/children/$childId/dashboard');

      if (response.statusCode == 200) {
        AppLogger.info('Dashboard del niño ID $childId recuperado satisfactoriamente');
        return GuardianChildDashboardModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        AppLogger.warning('Respuesta inesperada al obtener dashboard: código ${response.statusCode}');
        throw Exception('No se pudo cargar el dashboard del niño (Código ${response.statusCode})');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        AppLogger.warning('Acceso denegado (403): el niño ID $childId no pertenece a este acudiente');
        throw Exception('No tienes autorización para ver las métricas de este perfil.');
      } else if (e.response?.statusCode == 404) {
        AppLogger.warning('Perfil infantil no encontrado (404) para ID $childId');
        throw Exception('El perfil infantil solicitado no fue encontrado.');
      }
      _handleDioError(e, 'Error al consultar las métricas del niño');
      rethrow;
    } catch (e, stack) {
      AppLogger.error('Fallo no recuperado al consultar dashboard del niño ID $childId', e, stack);
      rethrow;
    }
  }

  void _handleDioError(DioException e, String contextMessage) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      AppLogger.warning('$contextMessage: Tiempo de espera agotado. Verifica tu conexión.');
      throw Exception('Tiempo de espera agotado al conectar con el servidor.');
    } else if (e.type == DioExceptionType.connectionError) {
      AppLogger.warning('$contextMessage: No se pudo conectar con el servidor.');
      throw Exception('No se pudo establecer conexión con el servidor. Verifica que esté activo.');
    } else if (e.response?.statusCode == 401) {
      AppLogger.warning('$contextMessage: Sesión no autorizada o token expirado (401).');
      throw Exception('Tu sesión ha expirado o no es válida. Inicia sesión nuevamente.');
    } else {
      final serverMessage = (e.response?.data is Map)
          ? (e.response?.data['message'] as String?)
          : null;
      AppLogger.warning('$contextMessage: ${serverMessage ?? e.message}');
      throw Exception(serverMessage ?? 'Error en la comunicación con el servidor.');
    }
  }
}
