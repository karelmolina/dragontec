import 'package:dragontec/features/usuarios/data/models/usuario_model.dart';
import 'package:dragontec/features/usuarios/domain/entities/usuario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UsuarioModel', () {
    test('debería deserializar desde JSON con todos los campos', () {
      final json = {
        'id': 1,
        'nombre': 'Juan Pérez',
        'usuario': 'juanp',
        'correo': 'juan@example.com',
        'telefono': '12345678',
        'identificacion': 'ID123',
        'rol': 1,
        'status': 1,
        'direccion': 'Calle 123',
        'id_agencia': 1,
        'id_consignatario': 2,
      };

      final model = UsuarioModel.fromJson(json);

      expect(model.id, 1);
      expect(model.nombre, 'Juan Pérez');
      expect(model.usuario, 'juanp');
      expect(model.correo, 'juan@example.com');
      expect(model.telefono, '12345678');
      expect(model.identificacion, 'ID123');
      expect(model.rol, 1);
      expect(model.status, 1);
      expect(model.direccion, 'Calle 123');
      expect(model.idAgencia, 1);
      expect(model.idConsignatario, 2);
    });

    test('debería serializar a JSON correctamente', () {
      const model = UsuarioModel(
        id: 1,
        nombre: 'Test',
        usuario: 'test',
        correo: 'test@example.com',
        rol: 1,
        status: 1,
      );

      final json = model.toJson();

      expect(json['id'], 1);
      expect(json['nombre'], 'Test');
      expect(json['correo'], 'test@example.com');
      expect(json.containsKey('telefono'), isFalse);
    });

    test('toEntity debería retornar Usuario equivalente', () {
      const model = UsuarioModel(
        id: 1,
        nombre: 'Test',
        usuario: 'test',
        rol: 1,
        status: 1,
      );

      final entity = model.toEntity();

      expect(entity, isA<Usuario>());
      expect(entity.id, 1);
      expect(entity.nombre, 'Test');
    });
  });
}
