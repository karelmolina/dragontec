import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/tracking/domain/entities/paquete.dart';
import 'package:dragontec/features/tracking/domain/repositories/tracking_repository.dart';
import 'package:dragontec/features/tracking/domain/usecases/get_tracking_by_courier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_tracking_by_courier_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TrackingRepository>()])
void main() {
  late MockTrackingRepository mockRepository;
  late GetTrackingByCourierUseCase useCase;

  setUp(() {
    mockRepository = MockTrackingRepository();
    useCase = GetTrackingByCourierUseCase(mockRepository);
  });

  const tTrackingCourier = '1ZJ73E770323663880';
  const tPaquete = Paquete(
    tracking: tTrackingCourier,
    estado: 'En tránsito',
  );

  group('GetTrackingByCourierUseCase', () {
    test('debería retornar Right(Paquete) cuando el tracking existe', () async {
      when(mockRepository.getTracking(any))
          .thenAnswer((_) async => const Right(tPaquete));

      final result = await useCase(
        const GetTrackingByCourierParams(trackingCourier: tTrackingCourier),
      );

      expect(result, equals(const Right<Failure, Paquete>(tPaquete)));
      verify(mockRepository.getTracking(tTrackingCourier));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'debería retornar Left(TrackingNotFoundFailure) cuando el tracking no existe',
        () async {
      when(mockRepository.getTracking(any)).thenAnswer(
        (_) async => const Left(TrackingNotFoundFailure()),
      );

      final result = await useCase(
        const GetTrackingByCourierParams(trackingCourier: 'INEXISTENTE'),
      );

      expect(
        result,
        equals(const Left<Failure, Paquete>(TrackingNotFoundFailure())),
      );
      verify(mockRepository.getTracking('INEXISTENTE'));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'debería retornar Left(ServerFailure) cuando ocurre un error del servidor',
        () async {
      when(mockRepository.getTracking(any)).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Error interno')),
      );

      final result = await useCase(
        const GetTrackingByCourierParams(trackingCourier: tTrackingCourier),
      );

      expect(
        result,
        equals(const Left<Failure, Paquete>(
          ServerFailure(message: 'Error interno'),
        )),
      );
      verify(mockRepository.getTracking(tTrackingCourier));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'debería retornar Left(NetworkFailure) cuando hay error de red',
        () async {
      when(mockRepository.getTracking(any)).thenAnswer(
        (_) async => const Left(NetworkFailure(message: 'Sin conexión')),
      );

      final result = await useCase(
        const GetTrackingByCourierParams(trackingCourier: tTrackingCourier),
      );

      expect(
        result,
        equals(const Left<Failure, Paquete>(
          NetworkFailure(message: 'Sin conexión'),
        )),
      );
      verify(mockRepository.getTracking(tTrackingCourier));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
