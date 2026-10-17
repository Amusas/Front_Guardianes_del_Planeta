class ApiConfig {
  ApiConfig._();

  static const String scheme = String.fromEnvironment(
    'API_SCHEME',
    defaultValue: 'http',
  );

  static const String host = String.fromEnvironment(
    'API_HOST',
    defaultValue: '192.168.101.7',
  );

  static const String port = String.fromEnvironment(
    'API_PORT',
    defaultValue: '8080',
  );

  static String get baseUrl => '$scheme://$host:$port';
}
