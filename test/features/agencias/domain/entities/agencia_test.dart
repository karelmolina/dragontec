import 'package:dragontec/features/agencias/domain/entities/agencia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Agencia', () {
    test('debería crear una instancia con valores requeridos', () {
      const agencia = Agencia(
        id: 1,
        nombre: 'Agencia Test',
      );

      expect(agencia.id, 1);
      expect(agencia.nombre, 'Agencia Test');
      expect(agencia.codigo, isNull);
    });

    test('debería crear una instancia con todos los campos', () {
      const agencia = Agencia(
        id: 1,
        codigo: 'AG001',
        nombre: 'Agencia Test',
        representante: 'Juan',
        correo: 'test@example.com',
        direccion: 'Calle 123',
        telefono: '12345678',
        status: 1,
        logo: 'logo.png',
        consignatarioNombre: 'Consignatario',
      );

      expect(agencia.codigo, 'AG001');
      expect(agencia.status, 1);
    });

    test('statusNombre debería retornar Activo para status 1', () {
      const agencia = Agencia(id: 1, nombre: 'Test', status: 1);
      expect(agencia.statusNombre, 'Activo');
    });

    test('copyWith debería actualizar campos', () {
      const agencia = Agencia(id: 1, nombre: 'Test');
      final updated = agencia.copyWith(nombre: 'Nuevo');
      expect(updated.nombre, 'Nuevo');
      expect(updated.id, 1);
    });
  });
}
