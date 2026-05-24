import 'package:dio/dio.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/features/clientes/data/datasources/clientes_remote_datasource.dart';
import 'package:dragontec/features/clientes/data/models/cliente_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clientes_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late ClientesRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = ClientesRemoteDataSourceImpl(dio: mockDio);
  });

  group('registrarCliente', () {
    const tNombre = 'Juan Pérez';
    const tUsuario = 'juanp';
    const tClave = 'Clave12345';
    const tClaveConfirmacion = 'Clave12345';
    const tCorreo = 'juan@example.com';

    final tResponseData = <String, dynamic>{
      'id': 1,
      'nombre': tNombre,
      'usuario': tUsuario,
      'correo': tCorreo,
    };

    test('debería retornar ClienteModel cuando el registro es exitoso', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.registrarCliente(
        nombre: tNombre,
        usuario: tUsuario,
        clave: tClave,
        claveConfirmacion: tClaveConfirmacion,
        correo: tCorreo,
      );

      expect(result, isA<ClienteModel>());
      expect(result.nombre, tNombre);
      expect(result.usuario, tUsuario);
    });

    test('debería lanzar ServerException cuando hay error 422', () async {
      when(mockDio.post<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 422,
            data: {'message': 'El usuario ya existe'},
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      final call = dataSource.registrarCliente(
        nombre: tNombre,
        usuario: tUsuario,
        clave: tClave,
        claveConfirmacion: tClaveConfirmacion,
      );

      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('asignarAgencia', () {
    const tIdAgencia = 186;

    test('debería completar exitosamente', () async {
      when(mockDio.put<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => Response(
          data: {'message': 'Agencia asignada'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      await dataSource.asignarAgencia(idAgencia: tIdAgencia);

      verify(mockDio.put<Map<String, dynamic>>(
        any,
        data: {'id_agencia': tIdAgencia},
      )).called(1);
    });

    test('debería lanzar UnauthorizedException en 401', () async {
      when(mockDio.put<Map<String, dynamic>>(
        any,
        data: anyNamed('data'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      final call = dataSource.asignarAgencia(idAgencia: tIdAgencia);

      expect(call, throwsA(isA<UnauthorizedException>()));
    });
  });
}
