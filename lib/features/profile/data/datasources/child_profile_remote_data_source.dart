import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/logging/app_logger.dart';
import '../models/child_profile_response_model.dart';
import '../models/child_achievement_response_model.dart';

abstract class ChildProfileRemoteDataSource {
  Future<ChildProfileResponseModel> getMyProfile();
  Future<List<ChildAchievementResponseModel>> getAllAchievements();
  Future<List<ChildAchievementResponseModel>> getMyAchievements();
}

class ChildProfileRemoteDataSourceImpl implements ChildProfileRemoteDataSource {
  final ApiClient _apiClient;

  ChildProfileRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ChildProfileResponseModel> getMyProfile() async {
    try {
      AppLogger.debug('Iniciando consulta remota de perfil del niño actual.');
      final response = await _apiClient.dio.get('/api/v1/children/me');

      if (response.statusCode == 200 && response.data != null) {
        AppLogger.info('Perfil del niño recuperado exitosamente.');
        return ChildProfileResponseModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        AppLogger.warning('Respuesta inesperada al obtener perfil infantil: código ${response.statusCode}');
        throw Exception('Error al obtener perfil del niño (Código ${response.statusCode})');
      }
    } on DioException catch (e) {
      AppLogger.error('Error de red al consultar perfil del niño', e);
      final msg = e.response?.data is Map && (e.response?.data as Map)['message'] != null
          ? (e.response?.data as Map)['message'].toString()
          : 'Error de conexión con el servidor al obtener perfil infantil';
      throw Exception(msg);
    } catch (e, stack) {
      AppLogger.error('Fallo no recuperado al obtener perfil infantil', e, stack);
      rethrow;
    }
  }

  @override
  Future<List<ChildAchievementResponseModel>> getAllAchievements() async {
    try {
      AppLogger.debug('Iniciando consulta de todos los logros activos del sistema.');
      final response = await _apiClient.dio.get('/api/v1/achievements');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data as List<dynamic>
            : (response.data is Map ? [response.data] : []);
        AppLogger.info('Logros totales del sistema recuperados: ${data.length} logros.');
        return data.map((item) => ChildAchievementResponseModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        AppLogger.warning('Respuesta inesperada al obtener todos los logros: código ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      AppLogger.warning('Error al obtener todos los logros: ${e.message}');
      return [];
    } catch (e) {
      AppLogger.warning('Fallo no crítico al obtener todos los logros: $e');
      return [];
    }
  }

  @override
  Future<List<ChildAchievementResponseModel>> getMyAchievements() async {
    try {
      AppLogger.debug('Iniciando consulta remota de logros del niño actual.');
      final response = await _apiClient.dio.get('/api/v1/children/me/achievements');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data is List
            ? response.data as List<dynamic>
            : (response.data is Map ? [response.data] : []);
        AppLogger.info('Logros desbloqueados del niño recuperados: ${data.length} logros.');
        return data.map((item) => ChildAchievementResponseModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        AppLogger.warning('Respuesta inesperada al obtener logros del niño: código ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      AppLogger.warning('Error al obtener logros del niño: ${e.message}');
      return [];
    } catch (e) {
      AppLogger.warning('Fallo no crítico al obtener logros del niño: $e');
      return [];
    }
  }
}
