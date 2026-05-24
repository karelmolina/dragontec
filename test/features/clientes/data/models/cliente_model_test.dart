import 'package:dragontec/features/clientes/data/models/cliente_model.dart';
import 'package:dragontec/features/clientes/domain/entities/cliente.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClienteModel', () {
    test('debería deserializar desde JSON', () {
      final json = {
        'id': 1,
        'nombre': 'Juan',
        'usuario': 'juanp',
        'correo': 'juan@example.com',
        'id_agencia': 1,
      };

      final model = ClienteModel.fromJson(json);

      expect(model.id, 1);
      expect(model.nombre, 'Juan');
      expect(model.correo, 'juan@example.com');
      expect(model.idAgencia, 1);
    });

    test('toRegistroJson debería excluir id y id_agencia', () {
      const model = ClienteModel(
        id: 1,
        nombre: 'Test',
        usuario: 'test',
        correo: 'test@example.com',
        idAgencia: 1,
      );

      final json = model.toRegistroJson();

      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('id_agencia'), isFalse);
      expect(json['nombre'], 'Test');
    });

    test('toEntity debería retornar Cliente', () {
      const model = ClienteModel(id: 1, nombre: 'Test', usuario: 'test');
      final entity = model.toEntity();
      expect(entity, isA<Cliente>());
    });
  });
}
