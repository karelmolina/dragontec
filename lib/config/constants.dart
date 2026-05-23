import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/errors/exceptions.dart';

abstract final class AppConstants {
  static String get apiBaseUrl {
    if (!dotenv.isInitialized) {
      throw const ConfigException(
        message: 'dotenv no está inicializado. Asegúrate de llamar await dotenv.load() en main() antes de usar cualquier constante.',
      );
    }

    final url = dotenv.env['API_BASE_URL'];
    if (url == null || url.trim().isEmpty) {
      throw const ConfigException(
        message: 'API_BASE_URL no está definida o está vacía en el archivo .env',
      );
    }

    return url;
  }

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
