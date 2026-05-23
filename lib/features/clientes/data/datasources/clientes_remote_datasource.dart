import 'package:dio/dio.dart';

import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/cliente_model.dart';

abstract class ClientesRemoteDataSource {
  Future<ClienteModel> registrarCliente({
    required String nombre,
    required String usuario,
    required String clave,
    required String claveConfirmacion,
    String? correo,
  });

  Future<void> asignarAgencia({required int idAgencia});
}

class ClientesRemoteDataSourceImpl implements ClientesRemoteDataSource {
  final Dio dio;

  ClientesRemoteDataSourceImpl({required this.dio});

  @override
  Future<ClienteModel> registrarCliente({
    required String nombre,
    required String usuario,
    required String clave,
    required String claveConfirmacion,
    String? correo,
  }) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '${AppConstants.apiBaseUrl}/clientes/registro',
        data: {
          'nombre': nombre,
          'usuario': usuario,
          'clave': clave,
          'clave_confirmation': claveConfirmacion,
          'correo': correo,
        }..removeWhere((_, v) => v == null),
      );

      if (response.data == null) {
        throw const ServerException(message: 'Respuesta vacía', statusCode: 500);
      }

      return ClienteModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> asignarAgencia({required int idAgencia}) async {
    try {
      final response = await dio.put<Map<String, dynamic>>(
        '${AppConstants.apiBaseUrl}/clientes/agencia',
        data: {'id_agencia': idAgencia},
      );

      if (response.data == null) {
        throw const ServerException(message: 'Respuesta vacía', statusCode: 500);
      }
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
