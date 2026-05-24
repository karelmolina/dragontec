import 'package:dragontec/features/auth/data/models/user_model.dart';
import 'package:dragontec/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    test('debería deserializar desde JSON con todos los campos', () {
      final json = {
        'id': 1,
        'nombre': 'Juan Pérez',
        'usuario': 'juanp',
        'correo': 'juan@example.com',
        'telefono': '12345678',
        'rol': 1,
        'status': 1,
      };

      final model = UserModel.fromJson(json);

      expect(model.id, 1);
      expect(model.nombre, 'Juan Pérez');
      expect(model.usuario, 'juanp');
      expect(model.correo, 'juan@example.com');
      expect(model.telefono, '12345678');
      expect(model.rol, 1);
      expect(model.status, 1);
    });

    test('debería deserializar desde JSON con campos nulos', () {
      final json = {
        'id': 2,
        'nombre': 'María',
        'usuario': 'maria',
        'rol': 2,
      };

      final model = UserModel.fromJson(json);

      expect(model.id, 2);
      expect(model.correo, isNull);
      expect(model.telefono, isNull);
      expect(model.status, 1); // valor por defecto
    });

    test('debería usar valores por defecto cuando campos faltan', () {
      final json = <String, dynamic>{};

      final model = UserModel.fromJson(json);

      expect(model.id, 0);
      expect(model.nombre, '');
      expect(model.usuario, '');
      expect(model.rol, 0);
      expect(model.status, 1);
    });

    test('debería serializar a JSON correctamente', () {
      const model = UserModel(
        id: 1,
        nombre: 'Test',
        usuario: 'test',
        correo: 'test@example.com',
        telefono: '1234',
        rol: 1,
        status: 1,
      );

      final json = model.toJson();

      expect(json['id'], 1);
      expect(json['nombre'], 'Test');
      expect(json['usuario'], 'test');
      expect(json['correo'], 'test@example.com');
      expect(json['telefono'], '1234');
      expect(json['rol'], 1);
      expect(json['status'], 1);
    });

    test('toEntity debería retornar User equivalente', () {
      const model = UserModel(
        id: 1,
        nombre: 'Test',
        usuario: 'test',
        correo: 'test@example.com',
        telefono: '1234',
        rol: 1,
        status: 1,
      );

      final entity = model.toEntity();

      expect(entity, isA<User>());
      expect(entity.id, 1);
      expect(entity.nombre, 'Test');
      expect(entity.usuario, 'test');
      expect(entity.correo, 'test@example.com');
      expect(entity.rol, 1);
    });

    test('toEntity roundtrip: fromJson -> toEntity debería preservar datos', () {
      final json = {
        'id': 42,
        'nombre': 'Roundtrip',
        'usuario': 'rt',
        'correo': 'rt@example.com',
        'telefono': '9999',
        'rol': 3,
        'status': 1,
      };

      final model = UserModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.id, 42);
      expect(entity.nombre, 'Roundtrip');
      expect(entity.rol, 3);
      expect(entity.status, 1);
    });
  });
}
