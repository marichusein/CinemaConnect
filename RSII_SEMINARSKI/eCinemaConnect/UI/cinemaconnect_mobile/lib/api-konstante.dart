// ignore: file_names
// api-konstante.dart


class ApiKonstante {
  static final String baseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    const String host = String.fromEnvironment('API_HOST', defaultValue: 'localhost');
    const String port = String.fromEnvironment('API_PORT', defaultValue: '7125');
    return 'http://$host:$port';
  }
}