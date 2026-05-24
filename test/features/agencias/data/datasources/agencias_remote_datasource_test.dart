import 'package:dio/dio.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/features/agencias/data/datasources/agencias_remote_datasource.dart';
import 'package:dragontec/features/agencias/data/models/agencia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'agencias_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late AgenciasRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = AgenciasRemoteDataSourceImpl(dio: mockDio);
  });

  group('getAgencias', () {
    final tResponseData = <String, dynamic>{
      'success': true,
      'agencias': {
        'data': [
          {
            'id': 1,
            'codigo': 'AG001',
            'nombre': 'Agencia Central',
            'representante': 'Juan Pérez',
            'correo': 'juan@agencia.com',
            'direccion': 'Av. Principal 123',
            'telefono': '555-0100',
            'status': 1,
            'logo': 'uploads/logo.png',
            'consignatario': {
              'id': 2,
              'nombre': 'Grupo Garza',
            },
          },
        ],
        'current_page': 1,
        'per_page': 10,
        'total': 1,
        'last_page': 1,
      },
    };

    test('debería retornar lista de AgenciaModel cuando es exitoso', () async {
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getAgencias();

      expect(result, isA<List<AgenciaModel>>());
      expect(result.length, 1);
      expect(result.first.nombre, 'Agencia Central');
    });

    test('debería manejar respuesta como lista plana', () async {
      when(mockDio.get(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer(
        (_) async => Response(
          data: tResponseData['agencias']['data'] as List<dynamic>,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getAgencias();

      expect(result, isA<List<AgenciaModel>>());
      expect(result.length, 1);
    });

    test('debería extraer campos nuevos correctamente', () async {
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getAgencias();

      expect(result.first.representante, 'Juan Pérez');
      expect(result.first.correo, 'juan@agencia.com');
      expect(result.first.logo, 'uploads/logo.png');
      expect(result.first.consignatarioNombre, 'Grupo Garza');
    });

    test('debería lanzar NetworkException en timeout', () async {
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final call = dataSource.getAgencias();

      expect(call, throwsA(isA<NetworkException>()));
    });
  });
}
