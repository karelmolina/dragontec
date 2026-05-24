import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/usuarios/data/datasources/usuarios_remote_datasource.dart';
import 'package:dragontec/features/usuarios/data/models/usuario_model.dart';
import 'package:dragontec/features/usuarios/data/repositories/usuarios_repository_impl.dart';
import 'package:dragontec/features/usuarios/domain/entities/usuario.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'usuarios_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UsuariosRemoteDataSource>()])
void main() {
  late MockUsuariosRemoteDataSource mockRemote;
  late UsuariosRepositoryImpl repository;

  setUp(() {
    mockRemote = MockUsuariosRemoteDataSource();
    repository = UsuariosRepositoryImpl(remoteDataSource: mockRemote);
  });

  const tUsuarioModel = UsuarioModel(
    id: 1,
    nombre: 'Test',
    usuario: 'test',
    rol: 1,
    status: 1,
  );
  final tUsuario = tUsuarioModel.toEntity();

  group('getUsuarios', () {
    test('debería retornar lista de usuarios', () async {
      when(mockRemote.getUsuarios(page: anyNamed('page'), perPage: anyNamed('perPage')))
          .thenAnswer((_) async => [tUsuarioModel]);

      final result = await repository.getUsuarios();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('debería ser Right'),
        (usuarios) {
          expect(usuarios.length, 1);
          expect(usuarios.first.nombre, 'Test');
        },
      );
    });

    test('debería retornar Left(ServerFailure) en error', () async {
      when(mockRemote.getUsuarios(page: anyNamed('page'), perPage: anyNamed('perPage')))
          .thenThrow(const ServerException(message: 'Error'));

      final result = await repository.getUsuarios();

      expect(result, equals(const Left<Failure, List<Usuario>>(
        ServerFailure(message: 'Error'),
      )));
    });
  });

  group('createUsuario', () {
    test('debería retornar Right(Usuario) cuando es exitoso', () async {
      when(mockRemote.createUsuario(any))
          .thenAnswer((_) async => tUsuarioModel);

      final result = await repository.createUsuario(tUsuario);

      expect(result, equals(Right<Failure, Usuario>(tUsuario)));
    });
  });

  group('updateUsuario', () {
    test('debería retornar Right(Usuario) cuando es exitoso', () async {
      when(mockRemote.updateUsuario(any))
          .thenAnswer((_) async => tUsuarioModel);

      final result = await repository.updateUsuario(tUsuario);

      expect(result, equals(Right<Failure, Usuario>(tUsuario)));
    });
  });
}
