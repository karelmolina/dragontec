import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/usuarios/domain/entities/usuario.dart';
import 'package:dragontec/features/usuarios/domain/usecases/create_usuario.dart';
import 'package:dragontec/features/usuarios/domain/usecases/get_usuarios.dart';
import 'package:dragontec/features/usuarios/domain/usecases/update_usuario.dart';
import 'package:dragontec/features/usuarios/presentation/bloc/usuarios_bloc.dart';
import 'package:dragontec/features/usuarios/presentation/bloc/usuarios_event.dart';
import 'package:dragontec/features/usuarios/presentation/bloc/usuarios_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'usuarios_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetUsuariosUseCase>(),
  MockSpec<CreateUsuarioUseCase>(),
  MockSpec<UpdateUsuarioUseCase>(),
])
void main() {
  late MockGetUsuariosUseCase mockGetUsuarios;
  late MockCreateUsuarioUseCase mockCreateUsuario;
  late MockUpdateUsuarioUseCase mockUpdateUsuario;
  late UsuariosBloc bloc;

  setUp(() {
    mockGetUsuarios = MockGetUsuariosUseCase();
    mockCreateUsuario = MockCreateUsuarioUseCase();
    mockUpdateUsuario = MockUpdateUsuarioUseCase();
    bloc = UsuariosBloc(
      getUsuariosUseCase: mockGetUsuarios,
      createUsuarioUseCase: mockCreateUsuario,
      updateUsuarioUseCase: mockUpdateUsuario,
    );
  });

  const tUsuario = Usuario(
    id: 1,
    nombre: 'Test',
    usuario: 'test',
    rol: 1,
    status: 1,
  );

  group('UsuariosBloc', () {
    test('debería emitir UsuariosInitial como estado inicial', () {
      expect(bloc.state, equals(const UsuariosInitial()));
    });

    blocTest<UsuariosBloc, UsuariosState>(
      'debería emitir [UsuariosLoading, UsuariosLoaded] cuando carga usuarios',
      build: () {
        when(mockGetUsuarios(any))
            .thenAnswer((_) async => const Right([tUsuario]));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUsuarios()),
      expect: () => [
        const UsuariosLoading(),
        const UsuariosLoaded(usuarios: [tUsuario], hasReachedMax: true),
      ],
    );

    blocTest<UsuariosBloc, UsuariosState>(
      'debería emitir [UsuariosLoading, UsuariosError] cuando falla',
      build: () {
        when(mockGetUsuarios(any))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadUsuarios()),
      expect: () => [
        const UsuariosLoading(),
        UsuariosError('Error'),
      ],
    );

    blocTest<UsuariosBloc, UsuariosState>(
      'debería emitir success al crear usuario',
      build: () {
        when(mockCreateUsuario(any))
            .thenAnswer((_) async => const Right(tUsuario));
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateUsuario(tUsuario)),
      expect: () => [
        const UsuariosLoading(),
        const UsuarioOperationSuccess('Usuario creado exitosamente'),
      ],
    );
  });
}
