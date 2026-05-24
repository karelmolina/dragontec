import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/usuarios/domain/entities/usuario.dart';
import 'package:dragontec/features/usuarios/domain/repositories/usuarios_repository.dart';
import 'package:dragontec/features/usuarios/domain/usecases/create_usuario.dart';
import 'package:dragontec/features/usuarios/domain/usecases/get_usuarios.dart';
import 'package:dragontec/features/usuarios/domain/usecases/update_usuario.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'usuarios_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UsuariosRepository>()])
void main() {
  late MockUsuariosRepository mockRepository;

  setUp(() {
    mockRepository = MockUsuariosRepository();
  });

  const tUsuario = Usuario(
    id: 1,
    nombre: 'Test',
    usuario: 'test',
    rol: 1,
    status: 1,
  );

  group('GetUsuariosUseCase', () {
    late GetUsuariosUseCase useCase;

    setUp(() {
      useCase = GetUsuariosUseCase(mockRepository);
    });

    test('debería retornar lista de usuarios', () async {
      when(mockRepository.getUsuarios(page: anyNamed('page'), perPage: anyNamed('perPage')))
          .thenAnswer((_) async => const Right([tUsuario]));

      final result = await useCase(const GetUsuariosParams());

      expect(result, equals(const Right<Failure, List<Usuario>>([tUsuario])));
    });
  });

  group('CreateUsuarioUseCase', () {
    late CreateUsuarioUseCase useCase;

    setUp(() {
      useCase = CreateUsuarioUseCase(mockRepository);
    });

    test('debería retornar Right(Usuario)', () async {
      when(mockRepository.createUsuario(any))
          .thenAnswer((_) async => const Right(tUsuario));

      final result = await useCase(tUsuario);

      expect(result, equals(const Right<Failure, Usuario>(tUsuario)));
    });
  });

  group('UpdateUsuarioUseCase', () {
    late UpdateUsuarioUseCase useCase;

    setUp(() {
      useCase = UpdateUsuarioUseCase(mockRepository);
    });

    test('debería retornar Right(Usuario)', () async {
      when(mockRepository.updateUsuario(any))
          .thenAnswer((_) async => const Right(tUsuario));

      final result = await useCase(tUsuario);

      expect(result, equals(const Right<Failure, Usuario>(tUsuario)));
    });
  });
}
