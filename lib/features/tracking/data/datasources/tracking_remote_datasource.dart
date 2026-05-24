import 'package:dio/dio.dart';

import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/paquete_model.dart';

abstract class TrackingRemoteDataSource {
  Future<PaqueteModel> getTracking(String trackingCourier);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final Dio dio;

  TrackingRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaqueteModel> getTracking(String trackingCourier) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/paquetes/tracking',
        queryParameters: <String, dynamic>{
          'tracking_courier': trackingCourier,
        },
      );

      if (response.data == null) {
        throw const ServerException(message: 'Respuesta vacía', statusCode: 500);
      }

      final data = response.data!;
      final dynamic packageData = data['paquete'];

      if (packageData == null) {
        throw const NotFoundException(message: 'Paquete no encontrado');
      }

      return PaqueteModel.fromJson(packageData as Map<String, dynamic>);
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

    if (statusCode == 404) {
      return NotFoundException(message: message);
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkException(message: message);
    }

    return ServerException(message: message, statusCode: statusCode);
  }
}
