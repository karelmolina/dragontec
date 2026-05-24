import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/core/usecases/usecase.dart';
import 'package:dragontec/features/auth/domain/entities/user.dart';
import 'package:dragontec/features/auth/domain/repositories/auth_repository.dart';
import 'package:dragontec/features/auth/domain/usecases/check_auth_status.dart';
import 'package:dragontec/features/auth/domain/usecases/get_current_user.dart';
import 'package:dragontec/features/auth/domain/usecases/login.dart';
import 'package:dragontec/features/auth/domain/usecases/logout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_usecases_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('LoginUseCase', () {
    late LoginUseCase useCase;

    setUp(() {
      useCase = LoginUseCase(mockRepository);
    });

    const tUser = User(id: 1, nombre: 'Test', usuario: 'test', rol: 1, status: 1);

    test('debería retornar Right(User) cuando login es exitoso', () async {
      when(mockRepository.login(
        usuario: anyNamed('usuario'),
        clave: anyNamed('clave'),
        deviceName: anyNamed('deviceName'),
      )).thenAnswer((_) async => const Right(tUser));

      final result = await useCase(const LoginParams(
        usuario: 'test',
        clave: 'pass',
        deviceName: 'device',
      ));

      expect(result, equals(const Right<Failure, User>(tUser)));
    });

    test('debería retornar Left(Failure) cuando login falla', () async {
      when(mockRepository.login(
        usuario: anyNamed('usuario'),
        clave: anyNamed('clave'),
        deviceName: anyNamed('deviceName'),
      )).thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));

      final result = await useCase(const LoginParams(
        usuario: 'test',
        clave: 'pass',
        deviceName: 'device',
      ));

      expect(result, equals(const Left<Failure, User>(
        ServerFailure(message: 'Error'),
      )));
    });
  });

  group('LogoutUseCase', () {
    late LogoutUseCase useCase;

    setUp(() {
      useCase = LogoutUseCase(mockRepository);
    });

    test('debería retornar Right(null) cuando logout es exitoso', () async {
      when(mockRepository.logout())
          .thenAnswer((_) async => const Right(null));

      final result = await useCase(const NoParams());

      expect(result, equals(const Right<Failure, void>(null)));
    });
  });

  group('GetCurrentUserUseCase', () {
    late GetCurrentUserUseCase useCase;

    setUp(() {
      useCase = GetCurrentUserUseCase(mockRepository);
    });

    const tUser = User(id: 1, nombre: 'Test', usuario: 'test', rol: 1, status: 1);

    test('debería retornar Right(User) cuando hay usuario', () async {
      when(mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(tUser));

      final result = await useCase(const NoParams());

      expect(result, equals(const Right<Failure, User>(tUser)));
    });
  });

  group('CheckAuthStatusUseCase', () {
    late CheckAuthStatusUseCase useCase;

    setUp(() {
      useCase = CheckAuthStatusUseCase(mockRepository);
    });

    test('debería retornar true cuando está autenticado', () async {
      when(mockRepository.isAuthenticated())
          .thenAnswer((_) async => const Right(true));

      final result = await useCase(const NoParams());

      expect(result, equals(const Right<Failure, bool>(true)));
    });

    test('debería retornar false cuando no está autenticado', () async {
      when(mockRepository.isAuthenticated())
          .thenAnswer((_) async => const Right(false));

      final result = await useCase(const NoParams());

      expect(result, equals(const Right<Failure, bool>(false)));
    });
  });
}
