import 'package:dio/dio.dart';

import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/usuario_model.dart';

abstract class UsuariosRemoteDataSource {
  Future<List<UsuarioModel>> getUsuarios({int page = 1, int perPage = 10});
  Future<UsuarioModel> createUsuario(UsuarioModel usuario);
  Future<UsuarioModel> updateUsuario(UsuarioModel usuario);
}

class UsuariosRemoteDataSourceImpl implements UsuariosRemoteDataSource {
  final Dio dio;

  UsuariosRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UsuarioModel>> getUsuarios({int page = 1, int perPage = 10}) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/usuarios',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      if (response.data == null) {
        throw const ServerException(message: 'Respuesta vacía', statusCode: 500);
      }

      final data = response.data!;
      final List<dynamic> items;

      if (data.containsKey('data') && data['data'] is List) {
        items = data['data'] as List;
      } else if (data is List) {
        items = data as List<dynamic>;
      } else {
        items = [];
      }

      return items
          .map((e) => UsuarioModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UsuarioModel> createUsuario(UsuarioModel usuario) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/usuarios',
        data: usuario.toJson(),
      );

      if (response.data == null) {
        throw const ServerException(message: 'Respuesta vacía', statusCode: 500);
      }

      return UsuarioModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UsuarioModel> updateUsuario(UsuarioModel usuario) async {
    if (usuario.id == null) {
      throw const ServerException(message: 'ID requerido para actualizar');
    }

    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/usuarios',
        data: usuario.toJson(),
      );

      if (response.data == null) {
        throw const ServerException(message: 'Respuesta vacía', statusCode: 500);
      }

      return UsuarioModel.fromJson(response.data!);
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
