import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/agencias/domain/entities/agencia.dart';
import 'package:dragontec/features/agencias/domain/usecases/get_agencias.dart';
import 'package:dragontec/features/agencias/presentation/bloc/agencias_bloc.dart';
import 'package:dragontec/features/agencias/presentation/bloc/agencias_event.dart';
import 'package:dragontec/features/agencias/presentation/bloc/agencias_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'agencias_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetAgenciasUseCase>()])
void main() {
  late MockGetAgenciasUseCase mockUseCase;
  late AgenciasBloc bloc;

  setUp(() {
    mockUseCase = MockGetAgenciasUseCase();
    bloc = AgenciasBloc(getAgenciasUseCase: mockUseCase);
  });

  const tAgencia = Agencia(id: 1, nombre: 'Test');

  group('AgenciasBloc', () {
    test('debería emitir AgenciasInitial como estado inicial', () {
      expect(bloc.state, equals(const AgenciasInitial()));
    });

    blocTest<AgenciasBloc, AgenciasState>(
      'debería emitir [AgenciasLoading, AgenciasLoaded]',
      build: () {
        when(mockUseCase(any))
            .thenAnswer((_) async => const Right([tAgencia]));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAgencias()),
      expect: () => [
        const AgenciasLoading(),
        const AgenciasLoaded(agencias: [tAgencia], hasReachedMax: true),
      ],
    );

    blocTest<AgenciasBloc, AgenciasState>(
      'debería emitir [AgenciasLoading, AgenciasError]',
      build: () {
        when(mockUseCase(any))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAgencias()),
      expect: () => [
        const AgenciasLoading(),
        AgenciasError('Error'),
      ],
    );
  });
}
