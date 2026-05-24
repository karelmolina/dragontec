import 'package:dragontec/features/agencias/data/models/agencia_model.dart';
import 'package:dragontec/features/agencias/domain/entities/agencia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AgenciaModel', () {
    test('debería deserializar desde JSON', () {
      final json = {
        'id': 1,
        'codigo': 'AG001',
        'nombre': 'Agencia Test',
        'representante': 'Juan',
        'status': 1,
        'consignatario': {
          'nombre': 'Consignatario Test',
        },
      };

      final model = AgenciaModel.fromJson(json);

      expect(model.id, 1);
      expect(model.codigo, 'AG001');
      expect(model.nombre, 'Agencia Test');
      expect(model.consignatarioNombre, 'Consignatario Test');
    });

    test('toEntity debería retornar Agencia', () {
      const model = AgenciaModel(id: 1, nombre: 'Test');
      final entity = model.toEntity();
      expect(entity, isA<Agencia>());
    });
  });
}
