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
      'data': {
        'tracking': tTrackingCourier,
        'estado': 'En tránsito',
        'origen': 'Miami, FL',
        'destino': 'Ciudad de Guatemala',
        'fecha_registro': '2024-01-15T10:30:00.000',
        'fecha_estimada': '2024-01-20T14:00:00.000',
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
      expect(result.tracking, tTrackingCourier);
      expect(result.estado, 'En tránsito');
      expect(result.origen, 'Miami, FL');
      expect(result.destino, 'Ciudad de Guatemala');
    });

    test(
        'debería lanzar NotFoundException cuando la respuesta es 200 con data null',
        () async {
      when(mockDio.get<Map<String, dynamic>>(
        any,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer(
        (_) async => Response(
          data: <String, dynamic>{'data': null},
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
