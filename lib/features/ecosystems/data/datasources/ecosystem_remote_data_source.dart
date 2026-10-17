import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../auth/data/models/auth_models.dart';
import '../models/ecosystem_response_model.dart';

abstract class EcosystemRemoteDataSource {
  Future<List<EcosystemResponseModel>> getActiveEcosystems();
  Future<EcosystemResponseModel> getEcosystemById(int ecosystemId);
  Future<EcosystemResponseModel> getEcosystemByCode(String code);
}

class EcosystemRemoteDataSourceImpl implements EcosystemRemoteDataSource {
  final ApiClient _apiClient;

  EcosystemRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<EcosystemResponseModel>> getActiveEcosystems() async {
    try {
      AppLogger.debug('DEBUG: Iniciando consulta de ecosistemas.');
      final response = await _apiClient.dio.get('/api/v1/ecosystems');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List
            ? response.data as List<dynamic>
            : (response.data['data'] as List<dynamic>? ?? []);
        final list = data
            .map((item) => EcosystemResponseModel.fromJson(item as Map<String, dynamic>))
            .toList();
        AppLogger.debug('DEBUG: Cantidad de ecosistemas recibidos: ${list.length}.');
        return list;
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('ERROR: No fue posible cargar los ecosistemas desde el servidor.', e);
      throw Exception('Ha ocurrido un error inesperado al cargar los ecosistemas.');
    }
  }

  @override
  Future<EcosystemResponseModel> getEcosystemById(int ecosystemId) async {
    try {
      AppLogger.debug('DEBUG: Consultando ecosistema con ID $ecosystemId.');
      final response = await _apiClient.dio.get('/api/v1/ecosystems/$ecosystemId');

      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : (response.data['data'] as Map<String, dynamic>);
        return EcosystemResponseModel.fromJson(data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('ERROR: No fue posible cargar el ecosistema $ecosystemId.', e);
      throw Exception('Ha ocurrido un error inesperado al obtener el ecosistema.');
    }
  }

  @override
  Future<EcosystemResponseModel> getEcosystemByCode(String code) async {
    try {
      AppLogger.debug('DEBUG: Consultando ecosistema con código $code.');
      final response = await _apiClient.dio.get('/api/v1/ecosystems/code/$code');

      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : (response.data['data'] as Map<String, dynamic>);
        return EcosystemResponseModel.fromJson(data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('ERROR: No fue posible cargar el ecosistema por código $code.', e);
      throw Exception('Ha ocurrido un error inesperado al obtener el ecosistema.');
    }
  }

  Exception _handleError(Response response) {
    try {
      if (response.data is Map<String, dynamic>) {
        final errorDto = ErrorResponseDto.fromJson(response.data);
        return Exception(errorDto.message);
      }
    } catch (_) {}
    return Exception('Error inesperado del servidor. Código: ${response.statusCode}');
  }

  Exception _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Exception('Tiempo de conexión agotado. Revisa tu internet.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Error de conexión. No se pudo contactar al servidor.');
    }
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        return Exception('Sesión expirada o no autorizada. Por favor inicia sesión nuevamente.');
      }
      if (statusCode == 403) {
        return Exception('No tienes permisos suficientes para acceder a este contenido.');
      }
      if (statusCode == 404) {
        return Exception('El ecosistema solicitado no fue encontrado.');
      }
      return _handleError(e.response!);
    }
    return Exception('Error de red desconocido.');
  }
}
