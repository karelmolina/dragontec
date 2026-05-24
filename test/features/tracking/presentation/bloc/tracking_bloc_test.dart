import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/tracking/domain/entities/paquete.dart';
import 'package:dragontec/features/tracking/domain/usecases/get_tracking_by_courier.dart';
import 'package:dragontec/features/tracking/presentation/bloc/tracking_bloc.dart';
import 'package:dragontec/features/tracking/presentation/bloc/tracking_event.dart';
import 'package:dragontec/features/tracking/presentation/bloc/tracking_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tracking_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetTrackingByCourierUseCase>()])
void main() {
  late MockGetTrackingByCourierUseCase mockUseCase;
  late TrackingBloc bloc;

  setUp(() {
    mockUseCase = MockGetTrackingByCourierUseCase();
    bloc = TrackingBloc(getTrackingByCourierUseCase: mockUseCase);
  });

  const tTrackingCourier = '1ZJ73E770323663880';
  const tPaquete = Paquete(
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
    colorEstado: 'bg-primary',
    cantPieza: 1,
  );

  group('TrackingBloc', () {
    test('debería emitir TrackingInitial como estado inicial', () {
      expect(bloc.state, equals(const TrackingInitial()));
    });

    blocTest<TrackingBloc, TrackingState>(
      'debería emitir [TrackingLoading, TrackingLoaded] cuando la búsqueda es exitosa',
      build: () {
        when(mockUseCase(any))
            .thenAnswer((_) async => const Right(tPaquete));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SearchTracking(trackingCourier: tTrackingCourier),
      ),
      expect: () => [
        const TrackingLoading(),
        const TrackingLoaded(paquete: tPaquete),
      ],
      verify: (_) {
        verify(mockUseCase.call(captureAny)).called(1);
      },
    );

    blocTest<TrackingBloc, TrackingState>(
      'debería emitir [TrackingLoading, TrackingNotFound] cuando el tracking no existe',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => const Left(TrackingNotFoundFailure()),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SearchTracking(trackingCourier: 'INEXISTENTE'),
      ),
      expect: () => [
        const TrackingLoading(),
        const TrackingNotFound(),
      ],
    );

    blocTest<TrackingBloc, TrackingState>(
      'debería emitir [TrackingLoading, TrackingError] cuando ocurre un error del servidor',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Error interno')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SearchTracking(trackingCourier: tTrackingCourier),
      ),
      expect: () => [
        const TrackingLoading(),
        const TrackingError(message: 'Error interno'),
      ],
    );

    blocTest<TrackingBloc, TrackingState>(
      'debería emitir [TrackingLoading, TrackingError] cuando hay error de red',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => const Left(NetworkFailure(message: 'Sin conexión')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SearchTracking(trackingCourier: tTrackingCourier),
      ),
      expect: () => [
        const TrackingLoading(),
        const TrackingError(message: 'Sin conexión'),
      ],
    );

    blocTest<TrackingBloc, TrackingState>(
      'debería emitir [TrackingLoading, TrackingError] con mensaje de sesión expirada en UnauthorizedFailure',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => const Left(UnauthorizedFailure()),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const SearchTracking(trackingCourier: tTrackingCourier),
      ),
      expect: () => [
        const TrackingLoading(),
        const TrackingError(
          message: 'Sesión expirada. Por favor inicie sesión nuevamente.',
        ),
      ],
    );
  });
}
