import 'package:dio/dio.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:dragontec/features/tracking/data/models/paquete_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tracking_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late TrackingRemoteDataSourceImpl dataSource;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  setUp(() {
    mockDio = MockDio();
    dataSource = TrackingRemoteDataSourceImpl(dio: mockDio);
  });

  const tTrackingCourier = '1ZJ73E770323663880';

  group('getTracking', () {
    final tResponseData = <String, dynamic>{
      'success': true,
      'paquete': {
        'id': 1113124,
        'tracking': 'PKGNI00000000000117077',
        'estado': 'Recibido en Warehouse',
        'id_estado': 1,
        'fecha': '2026-05-14T21:57:10.000000Z',
        'agencia': 'PZ',
        'agencia_code': 'NIPZEXP',
        'id_agencia': 80,
        'tracking_courier': tTrackingCourier,
        'peso': 5,
        'flete': 'Aereo',
        'id_courier': 13,
        'nombre_courier': 'Otro',
        'nombre_manejo': 'General',
        'id_tipo_manejo': 1,
        'nombre_recepcion': 'Courier',
        'id_tipo_recepcion': 1,
        'nombre_ubicacion': 'Almacen Warehouse NW',
        'id_ubicacion': 1,
        'cant_pieza': 1,
        'cliente_paquete': null,
        'descripcion': 'ACCESORIO DE TELEFONO',
        'id_tipo_bulto': 1,
        'nombre_bulto': 'Cajas',
        'consignatario': 'Grupo Garza',
        'nombre_pais': 'Nicaragua',
        'nombre_ciudad': 'Managua',
        'nombre_region': 'Managua',
        'fecha_almacen': '2026-05-14 17:57:10',
        'fecha_consolidado': null,
        'fecha_despacho_destino': null,
        'fecha_desconsolidado': null,
        'fecha_entregado_agencia': null,
        'fecha_recibido_destino': null,
        'id_pais': 1,
        'id_ciudad': 1,
        'id_region': 1,
        'codigo_consignatario': 'NIADRJ',
        'id_consignatario': 2,
        'usuario_almacen': 'dayron505',
        'usuario_consolidado': null,
        'usuario_desconsolidado': null,
        'usuario_despacho_destino': null,
        'usuario_entregado_agencia': null,
        'usuario_recibido_destino': null,
        'color_estado': 'bg-primary',
        'prefijo': 'NI',
        'dimx': 0,
        'dimy': 0,
        'dimz': 0,
        'dim_total': 0,
        'foto': null,
      },
      'estados': {
        '2': 'Consolidado',
        '5': 'Desconsolidado',
        '3': 'Despachado a Destino',
        '6': 'Entregado a Agencia',
        '7': 'Paquete Extraviado',
        '4': 'Recibido en Destino',
        '1': 'Recibido en Warehouse',
      },
    };

    test('debería retornar PaqueteModel cuando la respuesta es 200 con datos',
        () async {
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

      final result = await dataSource.getTracking(tTrackingCourier);

      expect(result, isA<PaqueteModel>());
      expect(result.tracking, 'PKGNI00000000000117077');
      expect(result.estado, 'Recibido en Warehouse');
      expect(result.trackingCourier, tTrackingCourier);
      expect(result.agencia, 'PZ');
      expect(result.peso, 5);
      expect(result.descripcion, 'ACCESORIO DE TELEFONO');
      expect(result.consignatario, 'Grupo Garza');
    });

    test(
        'debería lanzar NotFoundException cuando la respuesta es 200 con paquete null',
        () async {
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer(
        (_) async => Response(
          data: <String, dynamic>{'success': true, 'paquete': null},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.getTracking(tTrackingCourier);

      expect(call, throwsA(isA<NotFoundException>()));
    });

    test('debería lanzar NotFoundException cuando la respuesta es 404',
        () async {
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
            data: <String, dynamic>{'message': 'Paquete no encontrado'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final call = dataSource.getTracking(tTrackingCourier);

      expect(call, throwsA(isA<NotFoundException>()));
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

      final call = dataSource.getTracking(tTrackingCourier);

      expect(call, throwsA(isA<NetworkException>()));
    });

    test('debería lanzar ServerException en error 5xx', () async {
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
            data: <String, dynamic>{'message': 'Error interno'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final call = dataSource.getTracking(tTrackingCourier);

      expect(call, throwsA(isA<ServerException>()));
    });

    test('debería lanzar UnauthorizedException en 401', () async {
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: ''),
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final call = dataSource.getTracking(tTrackingCourier);

      expect(call, throwsA(isA<UnauthorizedException>()));
    });
  });
}
