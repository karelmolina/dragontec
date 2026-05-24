import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/agencias/domain/entities/agencia.dart';
import 'package:dragontec/features/agencias/domain/repositories/agencias_repository.dart';
import 'package:dragontec/features/agencias/domain/usecases/get_agencias.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_agencias_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AgenciasRepository>()])
void main() {
  late MockAgenciasRepository mockRepository;
  late GetAgenciasUseCase useCase;

  setUp(() {
    mockRepository = MockAgenciasRepository();
    useCase = GetAgenciasUseCase(mockRepository);
  });

  const tAgencia = Agencia(id: 1, nombre: 'Test');

  test('debería retornar lista de agencias', () async {
    when(mockRepository.getAgencias(
      page: anyNamed('page'),
      perPage: anyNamed('perPage'),
      id: anyNamed('id'),
      codigo: anyNamed('codigo'),
      nombre: anyNamed('nombre'),
    )).thenAnswer((_) async => const Right([tAgencia]));

    final result = await useCase(const GetAgenciasParams());

    expect(result, equals(const Right<Failure, List<Agencia>>([tAgencia])));
  });
}
