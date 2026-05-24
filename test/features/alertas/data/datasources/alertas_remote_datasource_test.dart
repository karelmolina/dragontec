import 'package:dio/dio.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/features/alertas/data/datasources/alertas_remote_datasource.dart';
import 'package:dragontec/features/alertas/data/models/alerta_paquete_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'alertas_remote_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio mockDio;
  late AlertasRemoteDataSourceImpl dataSource;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  setUp(() {
    mockDio = MockDio();
    dataSource = AlertasRemoteDataSourceImpl(dio: mockDio);
  });

  final tDiaLlegada = DateTime(2024, 6, 15);
  final tAlertaModel = AlertaPaqueteModel(
    diaLlegada: tDiaLlegada,
    nombreCliente: 'Juan Pérez',
    trackingCourier: '1Z999AA10123456784',
    idCourier: 1,
    idAgencia: 2,
    idTipoalerta: 3,
    flete: 'Aéreo',
    cantPiezas: 5,
    descripcion: 'Electrónicos',
    instrucciones: 'Frágil',
  );

  group('createAlerta', () {
    test('debería completar exitosamente cuando la respuesta es 201', () async {
      when(mockDio.post<void>(
        any,
        data: anyNamed('data'),
      )).thenAnswer(
        (_) async => Response(
          statusCode: 201,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final call = dataSource.createAlerta(tAlertaModel);

      await expectLater(call, completes);
      verify(mockDio.post<void>(
        '/alertas-paquete',
        data: tAlertaModel.toJson(),
      )).called(1);
    });

    test('debería lanzar ValidationFailure en error 422', () async {
      when(mockDio.post<void>(
        any,
        data: anyNamed('data'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 422,
            requestOptions: RequestOptions(path: ''),
            data: <String, dynamic>{'message': 'Datos inválidos'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final call = dataSource.createAlerta(tAlertaModel);

      expect(call, throwsA(isA<ValidationException>()));
    });

    test('debería lanzar ServerException en error 5xx', () async {
      when(mockDio.post<void>(
        any,
        data: anyNamed('data'),
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

      final call = dataSource.createAlerta(tAlertaModel);

      expect(call, throwsA(isA<ServerException>()));
    });

    test('debería lanzar NetworkException en timeout', () async {
      when(mockDio.post<void>(
        any,
        data: anyNamed('data'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final call = dataSource.createAlerta(tAlertaModel);

      expect(call, throwsA(isA<NetworkException>()));
    });

    test('debería lanzar UnauthorizedException en 401', () async {
      when(mockDio.post<void>(
        any,
        data: anyNamed('data'),
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

      final call = dataSource.createAlerta(tAlertaModel);

      expect(call, throwsA(isA<UnauthorizedException>()));
    });

    test('debería lanzar UnauthorizedException en 403', () async {
      when(mockDio.post<void>(
        any,
        data: anyNamed('data'),
      )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: ''),
            data: <String, dynamic>{'message': 'Forbidden'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final call = dataSource.createAlerta(tAlertaModel);

      expect(call, throwsA(isA<UnauthorizedException>()));
    });
  });
}
