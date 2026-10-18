class ApiConfig {
  ApiConfig._();

  static const String scheme = String.fromEnvironment(
    'API_SCHEME',
    defaultValue: 'http',
  );

  static const String host = String.fromEnvironment(
    'API_HOST',
    defaultValue: '18.116.100.164',
  );

  static const String port = String.fromEnvironment(
    'API_PORT',
    defaultValue: '8080',
  );

  static String get baseUrl => '$scheme://$host:$port';
}
