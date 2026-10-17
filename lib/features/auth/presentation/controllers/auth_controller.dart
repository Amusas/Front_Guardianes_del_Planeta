import 'package:flutter/material.dart';
import '../../../../core/storage/secure_token_storage.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/auth_models.dart';

enum AuthState {
  initial,
  authenticated,
  unauthenticated,
}

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;
  final SecureTokenStorage _tokenStorage;

  AuthState _authState = AuthState.initial;
  AuthState get authState => _authState;

  UserRole? _userRole;
  UserRole? get userRole => _userRole;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthController({
    required AuthRepository repository,
    required SecureTokenStorage tokenStorage,
  })  : _repository = repository,
        _tokenStorage = tokenStorage;

  Future<void> checkSession() async {
    try {
      String? token;
      String? roleStr;
      try {
        final sessionData = await _tokenStorage.getSessionData().timeout(
          const Duration(seconds: 2),
          onTimeout: () => {},
        );
        token = sessionData['token'];
        roleStr = sessionData['role'];
      } catch (_) {
        token = await _tokenStorage.getToken().timeout(
          const Duration(seconds: 2),
          onTimeout: () => null,
        );
      }

      token ??= await _tokenStorage.getToken().timeout(
        const Duration(seconds: 2),
        onTimeout: () => null,
      );

      if (token != null && token.isNotEmpty) {
        if (roleStr != null) {
          _userRole = UserRole.values.firstWhere(
            (e) => e.name == roleStr,
            orElse: () => UserRole.CHILD,
          );
        } else {
          _userRole = UserRole.CHILD;
        }
        _authState = AuthState.authenticated;
        AppLogger.info('Sesión restaurada con éxito. Rol: ${_userRole?.name}');
      } else {
        _userRole = null;
        _authState = AuthState.unauthenticated;
        AppLogger.debug('No hay sesión activa.');
      }
    } catch (e) {
      _userRole = null;
      _authState = AuthState.unauthenticated;
      AppLogger.error('Error verificando sesión', e);
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();
    try {
      AppLogger.debug('Iniciando solicitud de autenticación.');
      final response = await _repository.login(username, password);

      _userRole = response.role;

      await _tokenStorage.saveSession(
        token: response.token,
        userId: response.userId.toString(),
        username: response.username,
        role: response.role.name,
      );

      _authState = AuthState.authenticated;
      AppLogger.info('Inicio de sesión completado correctamente. Rol: ${response.role.name}');
      _setLoading(false);
      return true;
    } catch (e) {
      AppLogger.warning('Error en login: $e');
      _errorMessage = _cleanExceptionMessage(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerAndLogin(String username, String password) async {
    _setLoading(true);
    _clearError();
    try {
      AppLogger.debug('Iniciando registro de acudiente.');
      await _repository.registerGuardian(username, password);
      AppLogger.info('Registro de acudiente completado.');
      
      // Auto login
      final loginSuccess = await login(username, password);
      return loginSuccess;
    } catch (e) {
      AppLogger.warning('Error en registro: $e');
      _errorMessage = _cleanExceptionMessage(e);
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    AppLogger.info('Cerrando sesión...');
    await _tokenStorage.clearSession();
    _userRole = null;
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _cleanExceptionMessage(dynamic e) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) {
      return msg.substring('Exception: '.length);
    }
    return msg;
  }
}
