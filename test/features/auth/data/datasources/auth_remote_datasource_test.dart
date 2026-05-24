import 'package:dio/dio.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dragontec/features/auth/data/models/login_request.dart';
import 'package:dragontec/features/auth/data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late AuthRemoteDataSourceImpl dataSource;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthRemoteDataSourceImpl(dio: mockDio);
  });

  group('login', () {
    final tLoginRequest = LoginRequest(
      usuario: 'test',
      clave: 'pass',
      deviceName: 'dragontec_mobile',
    );

    test('debería retornar LoginResponse cuando login es exitoso', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => Response(
          data: {
            'success': true,
            'token': '25|abc123',
            'message': 'Login exitoso',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.login(tLoginRequest);

      expect(result.success, isTrue);
      expect(result.token, '25|abc123');
    });

    test('debería lanzar ServerException cuando success es false', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => Response(
          data: {
            'success': false,
            'message': 'Credenciales inválidas',
          },
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.login(tLoginRequest);

      expect(call, throwsA(isA<ServerException>()));
    });

    test('debería lanzar ServerException cuando token es null', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => Response(
          data: {
            'success': true,
            'message': 'OK',
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.login(tLoginRequest);

      expect(call, throwsA(isA<ServerException>()));
    });

    test('debería lanzar UnauthorizedException en 401', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
            data: {'message': 'No autorizado'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final call = dataSource.login(tLoginRequest);

      expect(call, throwsA(isA<UnauthorizedException>()));
    });

    test('debería lanzar NetworkException en timeout', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final call = dataSource.login(tLoginRequest);

      expect(call, throwsA(isA<NetworkException>()));
    });
  });

  group('logout', () {
    test('debería completar exitosamente', () async {
      when(mockDio.post<Map<String, dynamic>>(any))
          .thenAnswer(
        (_) async => Response(
          data: {'message': 'Logout exitoso'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await dataSource.logout();

      verify(mockDio.post<Map<String, dynamic>>('/logout')).called(1);
    });

    test('debería lanzar ServerException en error 5xx', () async {
      when(mockDio.post<Map<String, dynamic>>(any))
          .thenAnswer(
        (_) async => Response(
          data: {'message': 'Error'},
          statusCode: 500,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.logout();

      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('getMe', () {
    final tUserJson = {
      'id': 1,
      'nombre': 'Test',
      'usuario': 'test',
      'rol': 1,
      'status': 1,
    };

    test('debería retornar UserModel cuando respuesta es exitosa', () async {
      when(mockDio.get<Map<String, dynamic>>(any))
          .thenAnswer(
        (_) async => Response(
          data: {'user': tUserJson},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getMe();

      expect(result, isA<UserModel>());
      expect(result.id, 1);
      expect(result.nombre, 'Test');
    });

    test('debería lanzar ServerException cuando user es null', () async {
      when(mockDio.get<Map<String, dynamic>>(any))
          .thenAnswer(
        (_) async => Response(
          data: {'user': null},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.getMe();

      expect(call, throwsA(isA<ServerException>()));
    });

    test('debería lanzar UnauthorizedException en 401', () async {
      when(mockDio.get<Map<String, dynamic>>(any))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final call = dataSource.getMe();

      expect(call, throwsA(isA<UnauthorizedException>()));
    });
  });
}
