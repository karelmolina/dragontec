import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/alerta_paquete_model.dart';

abstract class AlertasRemoteDataSource {
  Future<void> createAlerta(AlertaPaqueteModel alerta);
}

class AlertasRemoteDataSourceImpl implements AlertasRemoteDataSource {
  final Dio dio;

  AlertasRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> createAlerta(AlertaPaqueteModel alerta) async {
    try {
      await dio.post<void>(
        '/alertas-paquete',
        data: alerta.toJson(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    final message = (data is Map<String, dynamic> ? data['message'] : null) ??
        e.message ??
        'Error de red';

    if (statusCode == 401 || statusCode == 403) {
      return UnauthorizedException(message: message);
    }

    if (statusCode == 422) {
      return ValidationException(message: message);
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkException(message: message);
    }

    return ServerException(message: message, statusCode: statusCode);
  }
}
