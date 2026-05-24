import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:dragontec/features/tracking/data/models/paquete_model.dart';
import 'package:dragontec/features/tracking/data/repositories/tracking_repository_impl.dart';
import 'package:dragontec/features/tracking/domain/entities/paquete.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tracking_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TrackingRemoteDataSource>()])
void main() {
  late MockTrackingRemoteDataSource mockRemoteDataSource;
  late TrackingRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockTrackingRemoteDataSource();
    repository = TrackingRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tTrackingCourier = '1ZJ73E770323663880';
  const tPaqueteModel = PaqueteModel(
    tracking: 'PKGNI00000000000117077',
    estado: 'Recibido en Warehouse',
    trackingCourier: tTrackingCourier,
    agencia: 'PZ',
    peso: 5,
    flete: 'Aereo',
    descripcion: 'ACCESORIO DE TELEFONO',
    consignatario: 'Grupo Garza',
    nombreCiudad: 'Managua',
    nombrePais: 'Nicaragua',
    fechaAlmacen: '2026-05-14 17:57:10',
    colorEstado: 'bg-primary',
    cantPieza: 1,
  );
  final tPaquete = tPaqueteModel.toEntity();

  group('getTracking', () {
    test('debería retornar Right(Paquete) cuando el datasource retorna datos',
        () async {
      when(mockRemoteDataSource.getTracking(any))
          .thenAnswer((_) async => tPaqueteModel);

      final result = await repository.getTracking(tTrackingCourier);

      expect(result, equals(Right<Failure, Paquete>(tPaquete)));
      verify(mockRemoteDataSource.getTracking(tTrackingCourier));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'debería retornar Left(TrackingNotFoundFailure) cuando ocurre NotFoundException',
        () async {
      when(mockRemoteDataSource.getTracking(any))
          .thenThrow(const NotFoundException(message: 'Paquete no encontrado'));

      final result = await repository.getTracking(tTrackingCourier);

      expect(
        result,
        equals(const Left<Failure, Paquete>(
          TrackingNotFoundFailure(message: 'Paquete no encontrado'),
        )),
      );
      verify(mockRemoteDataSource.getTracking(tTrackingCourier));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'debería retornar Left(ServerFailure) cuando ocurre ServerException',
        () async {
      when(mockRemoteDataSource.getTracking(any)).thenThrow(
        const ServerException(message: 'Error del servidor', statusCode: 500),
      );

      final result = await repository.getTracking(tTrackingCourier);

      expect(
        result,
        equals(const Left<Failure, Paquete>(
          ServerFailure(message: 'Error del servidor'),
        )),
      );
      verify(mockRemoteDataSource.getTracking(tTrackingCourier));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'debería retornar Left(NetworkFailure) cuando ocurre NetworkException',
        () async {
      when(mockRemoteDataSource.getTracking(any)).thenThrow(
        const NetworkException(message: 'Sin conexión'),
      );

      final result = await repository.getTracking(tTrackingCourier);

      expect(
        result,
        equals(const Left<Failure, Paquete>(
          NetworkFailure(message: 'Sin conexión'),
        )),
      );
      verify(mockRemoteDataSource.getTracking(tTrackingCourier));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'debería retornar Left(UnauthorizedFailure) cuando ocurre UnauthorizedException',
        () async {
      when(mockRemoteDataSource.getTracking(any)).thenThrow(
        const UnauthorizedException(message: 'Token inválido'),
      );

      final result = await repository.getTracking(tTrackingCourier);

      expect(
        result,
        equals(const Left<Failure, Paquete>(
          UnauthorizedFailure(message: 'Token inválido'),
        )),
      );
      verify(mockRemoteDataSource.getTracking(tTrackingCourier));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('debería retornar Left(ServerFailure) para excepciones desconocidas',
        () async {
      when(mockRemoteDataSource.getTracking(any))
          .thenThrow(Exception('Error inesperado'));

      final result = await repository.getTracking(tTrackingCourier);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Error inesperado'));
        },
        (_) => fail('debería ser Left'),
      );
      verify(mockRemoteDataSource.getTracking(tTrackingCourier));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
