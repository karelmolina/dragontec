import 'package:dio/dio.dart';

import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/agencia_model.dart';

abstract class AgenciasRemoteDataSource {
  Future<List<AgenciaModel>> getAgencias({
    int page = 1,
    int perPage = 10,
    int? id,
    String? codigo,
    String? nombre,
  });
}

class AgenciasRemoteDataSourceImpl implements AgenciasRemoteDataSource {
  final Dio dio;

  AgenciasRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<AgenciaModel>> getAgencias({
    int page = 1,
    int perPage = 10,
    int? id,
    String? codigo,
    String? nombre,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      if (id != null) queryParameters['id'] = id;
      if (codigo != null && codigo.isNotEmpty) queryParameters['codigo'] = codigo;
      if (nombre != null && nombre.isNotEmpty) queryParameters['nombre'] = nombre;

      final response = await dio.get(
        '/agencias',
        queryParameters: queryParameters,
      );

      if (response.data == null) {
        throw const ServerException(message: 'Respuesta vacía', statusCode: 500);
      }

      final dynamic data = response.data;
      final List<dynamic> items;

      if (data is Map<String, dynamic>) {
        // La respuesta real tiene: { "agencias": { "data": [...] } }
        if (data.containsKey('agencias') &&
            data['agencias'] is Map<String, dynamic> &&
            data['agencias']['data'] is List) {
          items = data['agencias']['data'] as List;
        } else if (data.containsKey('data') && data['data'] is List) {
          items = data['data'] as List;
        } else {
          items = [];
        }
      } else if (data is List) {
        items = data;
      } else {
        items = [];
      }

      return items
          .map((e) => AgenciaModel.fromJson(e as Map<String, dynamic>))
          .toList();
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

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkException(message: message);
    }

    return ServerException(message: message, statusCode: statusCode);
  }
}
