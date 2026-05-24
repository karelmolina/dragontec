import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/errors/exceptions.dart';

/// Entorno de ejecución (dev | prod)
const String kEnvironment = String.fromEnvironment('ENV', defaultValue: 'dev');

/// URL base de la API — resolución de prioridad:
/// 1. --dart-define=API_BASE_URL=...
/// 2. .env file (dotenv)
/// 3. Excepción si no se encuentra
abstract final class AppConstants {
  static String get apiBaseUrl {
    // 1. dart-define tiene máxima prioridad
    const dartDefineUrl = String.fromEnvironment('API_BASE_URL');
    if (dartDefineUrl.isNotEmpty) {
      return dartDefineUrl;
    }

    // 2. fallback a .env (solo si fue cargado)
    if (dotenv.isInitialized) {
      final url = dotenv.env['API_BASE_URL'];
      if (url != null && url.trim().isNotEmpty) {
        return url;
      }
    }

    throw const ConfigException(
      message:
          'API_BASE_URL no está definida. Usa --dart-define=API_BASE_URL=https://... '
          'o crea un archivo .env con API_BASE_URL.',
    );
  }

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
