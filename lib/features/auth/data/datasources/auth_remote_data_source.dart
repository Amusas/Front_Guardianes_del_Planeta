import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/auth_models.dart';
import '../../../../core/logging/app_logger.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<UserResponseDto> registerGuardian(UserRegisterRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/v1/user',
        data: request.toJson(),
      );
      if (response.statusCode == 201) {
        return UserResponseDto.fromJson(response.data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Error inesperado durante registro', e);
      throw Exception('Ha ocurrido un error inesperado al registrar.');
    }
  }

  Future<AuthResponseDto> login(UserLoginRequest request) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/v1/login',
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        return AuthResponseDto.fromJson(response.data);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      AppLogger.error('Error inesperado durante login', e);
      throw Exception('Ha ocurrido un error inesperado al iniciar sesi\u00f3n.');
    }
  }

  Exception _handleError(Response response) {
    try {
      if (response.data is Map<String, dynamic>) {
        final errorDto = ErrorResponseDto.fromJson(response.data);
        return Exception(errorDto.message);
      }
    } catch (_) {}
    return Exception('Error inesperado del servidor. C\u00f3digo: ${response.statusCode}');
  }

  Exception _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      return Exception('Tiempo de conexi\u00f3n agotado. Revisa tu internet.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return Exception('Error de conexi\u00f3n. No se pudo contactar al servidor.');
    }
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        return Exception('Credenciales incorrectas.');
      }
      if (e.response?.statusCode == 409) {
        return Exception('El nombre de usuario ya existe.');
      }
      return _handleError(e.response!);
    }
    return Exception('Error de red desconocido.');
  }
}
