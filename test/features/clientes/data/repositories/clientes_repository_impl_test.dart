import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/clientes/data/datasources/clientes_remote_datasource.dart';
import 'package:dragontec/features/clientes/data/models/cliente_model.dart';
import 'package:dragontec/features/clientes/data/repositories/clientes_repository_impl.dart';
import 'package:dragontec/features/clientes/domain/entities/cliente.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clientes_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ClientesRemoteDataSource>()])
void main() {
  late MockClientesRemoteDataSource mockRemote;
  late ClientesRepositoryImpl repository;

  setUp(() {
    mockRemote = MockClientesRemoteDataSource();
    repository = ClientesRepositoryImpl(remoteDataSource: mockRemote);
  });

  const tClienteModel = ClienteModel(id: 1, nombre: 'Test', usuario: 'test');
  final tCliente = tClienteModel.toEntity();

  group('registrarCliente', () {
    test('debería retornar Right(Cliente)', () async {
      when(mockRemote.registrarCliente(
        nombre: anyNamed('nombre'),
        usuario: anyNamed('usuario'),
        clave: anyNamed('clave'),
        claveConfirmacion: anyNamed('claveConfirmacion'),
        correo: anyNamed('correo'),
      )).thenAnswer((_) async => tClienteModel);

      final result = await repository.registrarCliente(
        nombre: 'Test',
        usuario: 'test',
        clave: 'pass',
        claveConfirmacion: 'pass',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('debería ser Right'),
        (cliente) {
          expect(cliente.nombre, 'Test');
          expect(cliente.usuario, 'test');
        },
      );
    });
  });

  group('asignarAgencia', () {
    test('debería retornar Right(null)', () async {
      when(mockRemote.asignarAgencia(idAgencia: anyNamed('idAgencia')))
          .thenAnswer((_) async => {});

      final result = await repository.asignarAgencia(idAgencia: 1);

      expect(result, equals(const Right<Failure, void>(null)));
    });
  });
}
