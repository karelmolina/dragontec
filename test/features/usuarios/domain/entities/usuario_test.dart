import 'package:dragontec/features/usuarios/domain/entities/usuario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Usuario', () {
    test('debería crear una instancia con valores requeridos', () {
      const usuario = Usuario(
        nombre: 'Juan Pérez',
        usuario: 'juanp',
        rol: 1,
        status: 1,
      );

      expect(usuario.id, isNull);
      expect(usuario.nombre, 'Juan Pérez');
      expect(usuario.usuario, 'juanp');
      expect(usuario.rol, 1);
      expect(usuario.status, 1);
    });

    test('debería crear una instancia con todos los campos', () {
      const usuario = Usuario(
        id: 1,
        nombre: 'María García',
        usuario: 'mariag',
        correo: 'maria@example.com',
        telefono: '12345678',
        identificacion: 'ID123',
        rol: 2,
        status: 1,
        direccion: 'Calle 123',
        idAgencia: 1,
        idConsignatario: 2,
      );

      expect(usuario.id, 1);
      expect(usuario.correo, 'maria@example.com');
      expect(usuario.idAgencia, 1);
    });

    group('rolNombre', () {
      test('debería retornar nombre correcto para cada rol', () {
        expect(const Usuario(nombre: 'A', usuario: 'a', rol: 1, status: 1).rolNombre, 'Administrador');
        expect(const Usuario(nombre: 'A', usuario: 'a', rol: 2, status: 1).rolNombre, 'Técnico');
        expect(const Usuario(nombre: 'A', usuario: 'a', rol: 3, status: 1).rolNombre, 'Consignatario');
        expect(const Usuario(nombre: 'A', usuario: 'a', rol: 4, status: 1).rolNombre, 'Usuario');
        expect(const Usuario(nombre: 'A', usuario: 'a', rol: 99, status: 1).rolNombre, 'Desconocido');
      });
    });

    group('statusNombre', () {
      test('debería retornar Activo para status 1', () {
        expect(const Usuario(nombre: 'A', usuario: 'a', rol: 1, status: 1).statusNombre, 'Activo');
      });

      test('debería retornar Inactivo para status 0', () {
        expect(const Usuario(nombre: 'A', usuario: 'a', rol: 1, status: 0).statusNombre, 'Inactivo');
      });
    });

    test('copyWith debería actualizar campos seleccionados', () {
      const usuario = Usuario(
        id: 1,
        nombre: 'Test',
        usuario: 'test',
        rol: 1,
        status: 1,
      );

      final updated = usuario.copyWith(nombre: 'Nuevo', status: 0);

      expect(updated.id, 1);
      expect(updated.nombre, 'Nuevo');
      expect(updated.status, 0);
      expect(updated.usuario, 'test'); // sin cambio
    });

    test('debería ser igual cuando todos los campos son iguales', () {
      const u1 = Usuario(id: 1, nombre: 'Test', usuario: 'test', rol: 1, status: 1);
      const u2 = Usuario(id: 1, nombre: 'Test', usuario: 'test', rol: 1, status: 1);
      expect(u1, equals(u2));
    });
  });
}
