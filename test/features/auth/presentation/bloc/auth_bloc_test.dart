import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/core/usecases/usecase.dart';
import 'package:dragontec/features/auth/domain/entities/user.dart';
import 'package:dragontec/features/auth/domain/usecases/check_auth_status.dart';
import 'package:dragontec/features/auth/domain/usecases/get_current_user.dart';
import 'package:dragontec/features/auth/domain/usecases/login.dart';
import 'package:dragontec/features/auth/domain/usecases/logout.dart';
import 'package:dragontec/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dragontec/features/auth/presentation/bloc/auth_event.dart';
import 'package:dragontec/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginUseCase>(),
  MockSpec<LogoutUseCase>(),
  MockSpec<GetCurrentUserUseCase>(),
  MockSpec<CheckAuthStatusUseCase>(),
])
void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
  late AuthBloc bloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
    bloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
    );
  });

  const tUser = User(id: 1, nombre: 'Test', usuario: 'test', rol: 1, status: 1);

  group('AuthBloc', () {
    test('debería emitir AuthInitial como estado inicial', () {
      expect(bloc.state, equals(const AuthInitial()));
    });

    blocTest<AuthBloc, AuthState>(
      'debería emitir [AuthLoading, AuthAuthenticated] cuando AppStarted y hay sesión',
      build: () {
        when(mockCheckAuthStatusUseCase(any))
            .thenAnswer((_) async => const Right(true));
        when(mockGetCurrentUserUseCase(any))
            .thenAnswer((_) async => const Right(tUser));
        return bloc;
      },
      act: (bloc) => bloc.add(const AppStarted()),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debería emitir [AuthLoading, AuthUnauthenticated] cuando AppStarted y no hay sesión',
      build: () {
        when(mockCheckAuthStatusUseCase(any))
            .thenAnswer((_) async => const Right(false));
        return bloc;
      },
      act: (bloc) => bloc.add(const AppStarted()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debería emitir [AuthLoading, AuthAuthenticated] cuando login es exitoso',
      build: () {
        when(mockLoginUseCase(any))
            .thenAnswer((_) async => const Right(tUser));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(
        usuario: 'test',
        clave: 'pass',
        deviceName: 'device',
      )),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debería emitir [AuthLoading, AuthError] cuando login falla',
      build: () {
        when(mockLoginUseCase(any))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoginRequested(
        usuario: 'test',
        clave: 'pass',
        deviceName: 'device',
      )),
      expect: () => [
        const AuthLoading(),
        AuthError('Error'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'debería emitir [AuthLoading, AuthUnauthenticated] cuando logout',
      build: () {
        when(mockLogoutUseCase(any))
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(const LogoutRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthUnauthenticated(),
      ],
    );
  });
}
