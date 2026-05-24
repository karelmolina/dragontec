import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/clientes/domain/entities/cliente.dart';
import 'package:dragontec/features/clientes/domain/repositories/clientes_repository.dart';
import 'package:dragontec/features/clientes/domain/usecases/asignar_agencia_cliente.dart';
import 'package:dragontec/features/clientes/domain/usecases/registrar_cliente.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clientes_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ClientesRepository>()])
void main() {
  late MockClientesRepository mockRepository;

  setUp(() {
    mockRepository = MockClientesRepository();
  });

  const tCliente = Cliente(id: 1, nombre: 'Test', usuario: 'test');

  group('RegistrarClienteUseCase', () {
    late RegistrarClienteUseCase useCase;

    setUp(() {
      useCase = RegistrarClienteUseCase(mockRepository);
    });

    test('debería retornar Right(Cliente)', () async {
      when(mockRepository.registrarCliente(
        nombre: anyNamed('nombre'),
        usuario: anyNamed('usuario'),
        clave: anyNamed('clave'),
        claveConfirmacion: anyNamed('claveConfirmacion'),
        correo: anyNamed('correo'),
      )).thenAnswer((_) async => const Right(tCliente));

      final result = await useCase(const RegistrarClienteParams(
        nombre: 'Test',
        usuario: 'test',
        clave: 'pass',
        claveConfirmacion: 'pass',
      ));

      expect(result, equals(const Right<Failure, Cliente>(tCliente)));
    });
  });

  group('AsignarAgenciaUseCase', () {
    late AsignarAgenciaUseCase useCase;

    setUp(() {
      useCase = AsignarAgenciaUseCase(mockRepository);
    });

    test('debería retornar Right(null)', () async {
      when(mockRepository.asignarAgencia(idAgencia: anyNamed('idAgencia')))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase(const AsignarAgenciaParams(idAgencia: 1));

      expect(result, equals(const Right<Failure, void>(null)));
    });
  });
}
