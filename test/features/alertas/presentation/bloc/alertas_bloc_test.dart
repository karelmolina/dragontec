import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/alertas/domain/usecases/create_alerta_paquete.dart';
import 'package:dragontec/features/alertas/presentation/bloc/alertas_bloc.dart';
import 'package:dragontec/features/alertas/presentation/bloc/alertas_event.dart';
import 'package:dragontec/features/alertas/presentation/bloc/alertas_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'alertas_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<CreateAlertaPaqueteUseCase>()])
void main() {
  late MockCreateAlertaPaqueteUseCase mockUseCase;
  late AlertasBloc bloc;

  setUp(() {
    mockUseCase = MockCreateAlertaPaqueteUseCase();
    bloc = AlertasBloc(createAlertaUseCase: mockUseCase);
  });

  final tDiaLlegada = DateTime(2024, 6, 15);
  final tParams = CreateAlertaPaqueteParams(
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

  group('AlertasBloc', () {
    test('debería emitir AlertasInitial como estado inicial', () {
      expect(bloc.state, equals(const AlertasInitial()));
    });

    blocTest<AlertasBloc, AlertasState>(
      'debería emitir [AlertasLoading, AlertasCreated] cuando la creación es exitosa',
      build: () {
        when(mockUseCase(any))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(CreateAlerta(params: tParams)),
      expect: () => [
        const AlertasLoading(),
        const AlertasCreated(),
      ],
      verify: (_) {
        verify(mockUseCase.call(captureAny)).called(1);
      },
    );

    blocTest<AlertasBloc, AlertasState>(
      'debería emitir [AlertasLoading, AlertasError] cuando hay error de validación',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => const Left(ValidationFailure(message: 'Datos inválidos')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(CreateAlerta(params: tParams)),
      expect: () => [
        const AlertasLoading(),
        const AlertasError(message: 'Datos inválidos'),
      ],
    );

    blocTest<AlertasBloc, AlertasState>(
      'debería emitir [AlertasLoading, AlertasError] cuando ocurre un error del servidor',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Error interno')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(CreateAlerta(params: tParams)),
      expect: () => [
        const AlertasLoading(),
        const AlertasError(message: 'Error interno'),
      ],
    );

    blocTest<AlertasBloc, AlertasState>(
      'debería emitir [AlertasLoading, AlertasError] cuando hay error de red',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => const Left(NetworkFailure(message: 'Sin conexión')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(CreateAlerta(params: tParams)),
      expect: () => [
        const AlertasLoading(),
        const AlertasError(message: 'Sin conexión'),
      ],
    );

    blocTest<AlertasBloc, AlertasState>(
      'debería emitir [AlertasLoading, AlertasError] con mensaje de sesión expirada en UnauthorizedFailure',
      build: () {
        when(mockUseCase(any)).thenAnswer(
          (_) async => const Left(UnauthorizedFailure()),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(CreateAlerta(params: tParams)),
      expect: () => [
        const AlertasLoading(),
        const AlertasError(
          message: 'Sesión expirada. Por favor inicie sesión nuevamente.',
        ),
      ],
    );

    blocTest<AlertasBloc, AlertasState>(
      'debería emitir AlertasInitial al recibir ResetAlerta',
      build: () => bloc,
      act: (bloc) => bloc.add(const ResetAlerta()),
      expect: () => [
        const AlertasInitial(),
      ],
    );
  });
}
