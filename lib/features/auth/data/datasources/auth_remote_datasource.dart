import 'package:dio/dio.dart';

import '../../../../config/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);
  Future<void> logout();
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '${AppConstants.apiBaseUrl}/login',
        data: request.toJson(),
      );

      if (response.data == null) {
        throw const ServerException(
          message: 'Respuesta vacía del servidor',
          statusCode: 500,
        );
      }

      final loginResponse = LoginResponse.fromJson(response.data!);

      if (!loginResponse.success || loginResponse.token == null) {
        throw ServerException(
          message: loginResponse.message ?? 'Error de autenticación',
          statusCode: response.statusCode,
        );
      }

      return loginResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '${AppConstants.apiBaseUrl}/logout',
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return;
      }

      throw ServerException(
        message: response.data?['message'] ?? 'Error al cerrar sesión',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '${AppConstants.apiBaseUrl}/me',
      );

      if (response.data == null) {
        throw const ServerException(
          message: 'Respuesta vacía del servidor',
          statusCode: 500,
        );
      }

      return UserModel.fromJson(response.data!);
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
