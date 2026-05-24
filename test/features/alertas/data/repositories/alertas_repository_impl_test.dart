import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/alertas/data/datasources/alertas_remote_datasource.dart';
import 'package:dragontec/features/alertas/data/models/alerta_paquete_model.dart';
import 'package:dragontec/features/alertas/data/repositories/alertas_repository_impl.dart';
import 'package:dragontec/features/alertas/domain/entities/alerta_paquete.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'alertas_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AlertasRemoteDataSource>()])
void main() {
  late MockAlertasRemoteDataSource mockRemoteDataSource;
  late AlertasRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAlertasRemoteDataSource();
    repository = AlertasRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  final tDiaLlegada = DateTime(2024, 6, 15);
  final tAlerta = AlertaPaquete(
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
    test('debería retornar Right(void) cuando el datasource completa exitosamente',
        () async {
      when(mockRemoteDataSource.createAlerta(any))
          .thenAnswer((_) async => Future.value());

      final result = await repository.createAlerta(tAlerta);

      expect(result, equals(const Right<Failure, void>(null)));
      verify(mockRemoteDataSource.createAlerta(any));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('debería retornar Left(ValidationFailure) cuando ocurre ValidationException',
        () async {
      when(mockRemoteDataSource.createAlerta(any)).thenThrow(
        const ValidationException(message: 'Datos inválidos'),
      );

      final result = await repository.createAlerta(tAlerta);

      expect(
        result,
        equals(const Left<Failure, void>(
          ValidationFailure(message: 'Datos inválidos'),
        )),
      );
      verify(mockRemoteDataSource.createAlerta(any));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('debería retornar Left(ServerFailure) cuando ocurre ServerException',
        () async {
      when(mockRemoteDataSource.createAlerta(any)).thenThrow(
        const ServerException(message: 'Error del servidor', statusCode: 500),
      );

      final result = await repository.createAlerta(tAlerta);

      expect(
        result,
        equals(const Left<Failure, void>(
          ServerFailure(message: 'Error del servidor'),
        )),
      );
      verify(mockRemoteDataSource.createAlerta(any));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('debería retornar Left(NetworkFailure) cuando ocurre NetworkException',
        () async {
      when(mockRemoteDataSource.createAlerta(any)).thenThrow(
        const NetworkException(message: 'Sin conexión'),
      );

      final result = await repository.createAlerta(tAlerta);

      expect(
        result,
        equals(const Left<Failure, void>(
          NetworkFailure(message: 'Sin conexión'),
        )),
      );
      verify(mockRemoteDataSource.createAlerta(any));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('debería retornar Left(UnauthorizedFailure) cuando ocurre UnauthorizedException',
        () async {
      when(mockRemoteDataSource.createAlerta(any)).thenThrow(
        const UnauthorizedException(message: 'Token inválido'),
      );

      final result = await repository.createAlerta(tAlerta);

      expect(
        result,
        equals(const Left<Failure, void>(
          UnauthorizedFailure(message: 'Token inválido'),
        )),
      );
      verify(mockRemoteDataSource.createAlerta(any));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('debería retornar Left(ServerFailure) para excepciones desconocidas',
        () async {
      when(mockRemoteDataSource.createAlerta(any))
          .thenThrow(Exception('Error inesperado'));

      final result = await repository.createAlerta(tAlerta);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Error inesperado'));
        },
        (_) => fail('debería ser Left'),
      );
      verify(mockRemoteDataSource.createAlerta(any));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
