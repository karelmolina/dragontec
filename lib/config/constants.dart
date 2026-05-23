import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppConstants {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://qa.horus-logistic.com/api';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
