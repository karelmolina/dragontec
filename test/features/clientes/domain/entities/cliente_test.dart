import 'package:dragontec/features/clientes/domain/entities/cliente.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cliente', () {
    test('debería crear una instancia con valores requeridos', () {
      const cliente = Cliente(
        nombre: 'Juan',
        usuario: 'juanp',
      );

      expect(cliente.nombre, 'Juan');
      expect(cliente.usuario, 'juanp');
      expect(cliente.id, isNull);
    });

    test('copyWith debería actualizar campos', () {
      const cliente = Cliente(nombre: 'Test', usuario: 'test');
      final updated = cliente.copyWith(nombre: 'Nuevo', id: 1);
      expect(updated.nombre, 'Nuevo');
      expect(updated.id, 1);
    });
  });
}
