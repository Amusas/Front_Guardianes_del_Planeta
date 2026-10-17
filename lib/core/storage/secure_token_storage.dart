import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../logging/app_logger.dart';

class SecureTokenStorage {
  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _roleKey = 'role';

  // Fallback en memoria en caso de que Web Crypto / Storage tarde o falle
  final Map<String, String> _memoryFallback = {};

  SecureTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveSession({
    required String token,
    required String userId,
    required String username,
    required String role,
  }) async {
    _memoryFallback[_tokenKey] = token;
    _memoryFallback[_userIdKey] = userId;
    _memoryFallback[_usernameKey] = username;
    _memoryFallback[_roleKey] = role;

    try {
      await Future.wait([
        _storage.write(key: _tokenKey, value: token),
        _storage.write(key: _userIdKey, value: userId),
        _storage.write(key: _usernameKey, value: username),
        _storage.write(key: _roleKey, value: role),
      ]).timeout(const Duration(seconds: 2));
      AppLogger.debug('Sesión guardada correctamente.');
    } catch (e) {
      AppLogger.warning('No se pudo guardar la sesión en almacenamiento seguro, usando memoria: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage
          .read(key: _tokenKey)
          .timeout(const Duration(seconds: 2));
      return token ?? _memoryFallback[_tokenKey];
    } catch (e) {
      AppLogger.warning('Error al leer el token, usando memoria: $e');
      return _memoryFallback[_tokenKey];
    }
  }

  Future<Map<String, String?>> getSessionData() async {
    try {
      final results = await Future.wait([
        _storage.read(key: _tokenKey),
        _storage.read(key: _userIdKey),
        _storage.read(key: _usernameKey),
        _storage.read(key: _roleKey),
      ]).timeout(const Duration(seconds: 2));

      return {
        'token': results[0] ?? _memoryFallback[_tokenKey],
        'userId': results[1] ?? _memoryFallback[_userIdKey],
        'username': results[2] ?? _memoryFallback[_usernameKey],
        'role': results[3] ?? _memoryFallback[_roleKey],
      };
    } catch (e) {
      AppLogger.warning('Error al leer datos de sesión seguro, usando memoria: $e');
      return {
        'token': _memoryFallback[_tokenKey],
        'userId': _memoryFallback[_userIdKey],
        'username': _memoryFallback[_usernameKey],
        'role': _memoryFallback[_roleKey],
      };
    }
  }

  Future<void> clearSession() async {
    _memoryFallback.clear();
    try {
      await Future.wait([
        _storage.delete(key: _tokenKey),
        _storage.delete(key: _userIdKey),
        _storage.delete(key: _usernameKey),
        _storage.delete(key: _roleKey),
      ]).timeout(const Duration(seconds: 2));
      AppLogger.info('Sesión eliminada del almacenamiento seguro.');
    } catch (e) {
      AppLogger.warning('Error al limpiar la sesión seguro: $e');
    }
  }
}
