import 'package:dio/dio.dart';

import '../../config/constants.dart';
import 'api_interceptors.dart';

class ApiClient {
  final Dio _dio;

  Dio get dio => _dio;

  ApiClient({
    required AuthInterceptor authInterceptor,
    required LoggingInterceptor loggingInterceptor,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
            receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(authInterceptor);
    _dio.interceptors.add(loggingInterceptor);
  }
}
