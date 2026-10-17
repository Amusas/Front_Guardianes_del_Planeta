import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/secure_token_storage.dart';
import '../logging/app_logger.dart';

class ApiClient {
  final Dio _dio;
  final SecureTokenStorage _tokenStorage;

  ApiClient({SecureTokenStorage? tokenStorage, Dio? dioOverride})
      : _tokenStorage = tokenStorage ?? SecureTokenStorage(),
        _dio = dioOverride ??
            Dio(BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              headers: {
                'Content-Type': 'application/json',
              },
            )) {
    _dio.interceptors.add(_AuthInterceptor(_tokenStorage));
    _dio.interceptors.add(LogInterceptor(
      request: false,
      requestHeader: false,
      responseHeader: false,
      responseBody: false,
      error: true,
      logPrint: (obj) => AppLogger.debug(obj.toString()),
    ));
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final SecureTokenStorage _storage;

  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip adding token for login and register endpoints
    if (options.path.contains('/auth/v1/login') || options.path.contains('/auth/v1/user')) {
      return handler.next(options);
    }

    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/v1/login')) {
      AppLogger.warning('Token invalidado o expirado (401).');
      // Podr\u00eda despachar un evento para cerrar sesi\u00f3n
    }
    return handler.next(err);
  }
}
