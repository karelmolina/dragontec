import 'dart:convert';

import 'package:dragontec/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:dragontec/features/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_local_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
void main() {
  late MockFlutterSecureStorage mockStorage;
  late AuthLocalDataSourceImpl dataSource;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    dataSource = AuthLocalDataSourceImpl(secureStorage: mockStorage);
  });

  group('saveToken', () {
    test('debería guardar token en secure storage', () async {
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async => {});

      await dataSource.saveToken('test_token');

      verify(mockStorage.write(key: 'auth_token', value: 'test_token'))
          .called(1);
    });
  });

  group('getToken', () {
    test('debería retornar token cuando existe', () async {
      when(mockStorage.read(key: 'auth_token'))
          .thenAnswer((_) async => 'test_token');

      final result = await dataSource.getToken();

      expect(result, 'test_token');
    });

    test('debería retornar null cuando no existe', () async {
      when(mockStorage.read(key: 'auth_token'))
          .thenAnswer((_) async => null);

      final result = await dataSource.getToken();

      expect(result, isNull);
    });
  });

  group('deleteToken', () {
    test('debería eliminar token de secure storage', () async {
      when(mockStorage.delete(key: anyNamed('key')))
          .thenAnswer((_) async => {});

      await dataSource.deleteToken();

      verify(mockStorage.delete(key: 'auth_token')).called(1);
    });
  });

  group('saveUser', () {
    test('debería guardar usuario como JSON', () async {
      when(mockStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async => {});

      const user = UserModel(
        id: 1,
        nombre: 'Test',
        usuario: 'test',
        rol: 1,
        status: 1,
      );

      await dataSource.saveUser(user);

      final captured = verify(mockStorage.write(
        key: captureAnyNamed('key'),
        value: captureAnyNamed('value'),
      )).captured;

      expect(captured[0], 'auth_user');
      final savedJson = jsonDecode(captured[1] as String) as Map<String, dynamic>;
      expect(savedJson['id'], 1);
      expect(savedJson['nombre'], 'Test');
    });
  });

  group('getUser', () {
    test('debería retornar UserModel cuando existe', () async {
      const user = UserModel(
        id: 1,
        nombre: 'Test',
        usuario: 'test',
        rol: 1,
        status: 1,
      );
      final userJson = jsonEncode(user.toJson());

      when(mockStorage.read(key: 'auth_user'))
          .thenAnswer((_) async => userJson);

      final result = await dataSource.getUser();

      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.nombre, 'Test');
    });

    test('debería retornar null cuando no existe', () async {
      when(mockStorage.read(key: 'auth_user'))
          .thenAnswer((_) async => null);

      final result = await dataSource.getUser();

      expect(result, isNull);
    });

    test('debería retornar null cuando JSON es inválido', () async {
      when(mockStorage.read(key: 'auth_user'))
          .thenAnswer((_) async => 'invalid json');

      final result = await dataSource.getUser();

      expect(result, isNull);
    });
  });

  group('deleteUser', () {
    test('debería eliminar usuario de secure storage', () async {
      when(mockStorage.delete(key: anyNamed('key')))
          .thenAnswer((_) async => {});

      await dataSource.deleteUser();

      verify(mockStorage.delete(key: 'auth_user')).called(1);
    });
  });
}
