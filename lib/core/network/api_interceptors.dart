import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;

  AuthInterceptor({required this.localDataSource});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await localDataSource.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    handler.next(options);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('➡️ REQUEST[${options.method}] => PATH: ${options.path}');
      debugPrint('Headers: ${options.headers}');
      if (options.data != null) debugPrint('Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '⬅️ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} | MSG: ${err.message}',
      );
    }
    handler.next(err);
  }
}
