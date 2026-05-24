import 'package:dragontec/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    test('debería crear una instancia con valores requeridos', () {
      const user = User(
        id: 1,
        nombre: 'Juan Pérez',
        usuario: 'juanp',
        rol: 1,
        status: 1,
      );

      expect(user.id, 1);
      expect(user.nombre, 'Juan Pérez');
      expect(user.usuario, 'juanp');
      expect(user.correo, isNull);
      expect(user.telefono, isNull);
      expect(user.rol, 1);
      expect(user.status, 1);
    });

    test('debería crear una instancia con todos los campos', () {
      const user = User(
        id: 2,
        nombre: 'María García',
        usuario: 'mariag',
        correo: 'maria@example.com',
        telefono: '12345678',
        rol: 2,
        status: 1,
      );

      expect(user.correo, 'maria@example.com');
      expect(user.telefono, '12345678');
    });

    group('role getters', () {
      test('isAdmin debería retornar true para rol 1', () {
        const admin = User(id: 1, nombre: 'Admin', usuario: 'admin', rol: 1, status: 1);
        expect(admin.isAdmin, isTrue);
        expect(admin.isTecnico, isFalse);
        expect(admin.isCliente, isFalse);
      });

      test('isTecnico debería retornar true para rol 2', () {
        const tecnico = User(id: 2, nombre: 'Téc', usuario: 'tec', rol: 2, status: 1);
        expect(tecnico.isTecnico, isTrue);
        expect(tecnico.isAdmin, isFalse);
      });

      test('isConsignatario debería retornar true para rol 3', () {
        const consig = User(id: 3, nombre: 'Cons', usuario: 'cons', rol: 3, status: 1);
        expect(consig.isConsignatario, isTrue);
      });

      test('isUsuario debería retornar true para rol 4', () {
        const usuario = User(id: 4, nombre: 'User', usuario: 'user', rol: 4, status: 1);
        expect(usuario.isUsuario, isTrue);
      });

      test('isCliente debería retornar true para rol 5', () {
        const cliente = User(id: 5, nombre: 'Client', usuario: 'client', rol: 5, status: 1);
        expect(cliente.isCliente, isTrue);
      });
    });

    group('rolNombre', () {
      test('debería retornar nombre correcto para cada rol', () {
        expect(const User(id: 1, nombre: 'A', usuario: 'a', rol: 1, status: 1).rolNombre, 'Administrador');
        expect(const User(id: 2, nombre: 'A', usuario: 'a', rol: 2, status: 1).rolNombre, 'Técnico');
        expect(const User(id: 3, nombre: 'A', usuario: 'a', rol: 3, status: 1).rolNombre, 'Consignatario');
        expect(const User(id: 4, nombre: 'A', usuario: 'a', rol: 4, status: 1).rolNombre, 'Usuario / Agencia');
        expect(const User(id: 5, nombre: 'A', usuario: 'a', rol: 5, status: 1).rolNombre, 'Cliente');
        expect(const User(id: 6, nombre: 'A', usuario: 'a', rol: 99, status: 1).rolNombre, 'Desconocido');
      });
    });

    group('permisos', () {
      test('admin debería tener todos los permisos de gestión', () {
        const admin = User(id: 1, nombre: 'Admin', usuario: 'admin', rol: 1, status: 1);
        expect(admin.canManageUsuarios, isTrue);
        expect(admin.canViewTracking, isTrue);
        expect(admin.canCreateAlertas, isTrue);
        expect(admin.canViewAgencias, isTrue);
      });

      test('cliente debería solo ver agencias y asignar', () {
        const cliente = User(id: 5, nombre: 'Client', usuario: 'client', rol: 5, status: 1);
        expect(cliente.canManageUsuarios, isFalse);
        expect(cliente.canViewTracking, isFalse);
        expect(cliente.canCreateAlertas, isFalse);
        expect(cliente.canViewAgencias, isTrue);
        expect(cliente.canAsignarAgencia, isTrue);
      });
    });

    test('debería ser igual cuando todos los campos son iguales', () {
      const user1 = User(id: 1, nombre: 'Test', usuario: 'test', rol: 1, status: 1);
      const user2 = User(id: 1, nombre: 'Test', usuario: 'test', rol: 1, status: 1);
      expect(user1, equals(user2));
    });

    test('debería ser diferente cuando id cambia', () {
      const user1 = User(id: 1, nombre: 'Test', usuario: 'test', rol: 1, status: 1);
      const user2 = User(id: 2, nombre: 'Test', usuario: 'test', rol: 1, status: 1);
      expect(user1, isNot(equals(user2)));
    });
  });
}
