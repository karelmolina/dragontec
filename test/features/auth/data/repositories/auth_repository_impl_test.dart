import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:dragontec/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dragontec/features/auth/data/models/login_response.dart';
import 'package:dragontec/features/auth/data/models/user_model.dart';
import 'package:dragontec/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dragontec/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthRemoteDataSource>(),
  MockSpec<AuthLocalDataSource>(),
])
void main() {
  late MockAuthRemoteDataSource mockRemote;
  late MockAuthLocalDataSource mockLocal;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAuthRemoteDataSource();
    mockLocal = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  const tUserModel = UserModel(
    id: 1,
    nombre: 'Test',
    usuario: 'test',
    rol: 1,
    status: 1,
  );
  final tLoginResponse = LoginResponse(
    success: true,
    token: '25|abc123',
    message: 'OK',
  );

  group('login', () {
    test('debería retornar Right(User) cuando login es exitoso', () async {
      when(mockRemote.login(any))
          .thenAnswer((_) async => tLoginResponse);
      when(mockLocal.saveToken(any))
          .thenAnswer((_) async => {});
      when(mockRemote.getMe())
          .thenAnswer((_) async => tUserModel);
      when(mockLocal.saveUser(any))
          .thenAnswer((_) async => {});

      final result = await repository.login(
        usuario: 'test',
        clave: 'pass',
        deviceName: 'device',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('debería ser Right'),
        (user) {
          expect(user.id, 1);
          expect(user.nombre, 'Test');
        },
      );
      verify(mockLocal.saveToken('25|abc123'));
      verify(mockLocal.saveUser(tUserModel));
    });

    test('debería retornar Left(ServerFailure) en error del servidor', () async {
      when(mockRemote.login(any))
          .thenThrow(const ServerException(message: 'Error', statusCode: 500));

      final result = await repository.login(
        usuario: 'test',
        clave: 'pass',
        deviceName: 'device',
      );

      expect(result, equals(const Left<Failure, User>(
        ServerFailure(message: 'Error'),
      )));
    });

    test('debería retornar Left(UnauthorizedFailure) en 401', () async {
      when(mockRemote.login(any))
          .thenThrow(const UnauthorizedException(message: 'No autorizado'));

      final result = await repository.login(
        usuario: 'test',
        clave: 'pass',
        deviceName: 'device',
      );

      expect(result, equals(const Left<Failure, User>(
        UnauthorizedFailure(message: 'No autorizado'),
      )));
    });
  });

  group('logout', () {
    test('debería retornar Right(null) cuando logout es exitoso', () async {
      when(mockRemote.logout())
          .thenAnswer((_) async => {});
      when(mockLocal.deleteToken())
          .thenAnswer((_) async => {});
      when(mockLocal.deleteUser())
          .thenAnswer((_) async => {});

      final result = await repository.logout();

      expect(result, equals(const Right<Failure, void>(null)));
      verify(mockLocal.deleteToken());
      verify(mockLocal.deleteUser());
    });

    test('debería limpiar token local incluso si remote falla con Unauthorized', () async {
      when(mockRemote.logout())
          .thenThrow(const UnauthorizedException(message: 'Token expirado'));
      when(mockLocal.deleteToken())
          .thenAnswer((_) async => {});
      when(mockLocal.deleteUser())
          .thenAnswer((_) async => {});

      final result = await repository.logout();

      expect(result.isLeft(), isTrue);
      verify(mockLocal.deleteToken());
      verify(mockLocal.deleteUser());
    });
  });

  group('getCurrentUser', () {
    test('debería retornar usuario local cuando existe', () async {
      when(mockLocal.getUser())
          .thenAnswer((_) async => tUserModel);

      final result = await repository.getCurrentUser();

      expect(result, equals(Right<Failure, User>(tUserModel.toEntity())));
      verifyNever(mockRemote.getMe());
    });

    test('debería fetch remoto cuando no hay usuario local', () async {
      when(mockLocal.getUser())
          .thenAnswer((_) async => null);
      when(mockRemote.getMe())
          .thenAnswer((_) async => tUserModel);
      when(mockLocal.saveUser(any))
          .thenAnswer((_) async => {});

      final result = await repository.getCurrentUser();

      expect(result, equals(Right<Failure, User>(tUserModel.toEntity())));
      verify(mockRemote.getMe());
      verify(mockLocal.saveUser(tUserModel));
    });
  });

  group('isAuthenticated', () {
    test('debería retornar true cuando hay token', () async {
      when(mockLocal.getToken())
          .thenAnswer((_) async => 'valid_token');

      final result = await repository.isAuthenticated();

      expect(result, equals(const Right<Failure, bool>(true)));
    });

    test('debería retornar false cuando no hay token', () async {
      when(mockLocal.getToken())
          .thenAnswer((_) async => null);

      final result = await repository.isAuthenticated();

      expect(result, equals(const Right<Failure, bool>(false)));
    });
  });
}
