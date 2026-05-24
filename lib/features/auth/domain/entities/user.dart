import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String nombre;
  final String usuario;
  final String? correo;
  final String? telefono;
  final int rol;
  final int status;

  const User({
    required this.id,
    required this.nombre,
    required this.usuario,
    this.correo,
    this.telefono,
    required this.rol,
    required this.status,
  });

  bool get isAdmin => rol == 1;
  bool get isTecnico => rol == 2;
  bool get isConsignatario => rol == 3;
  bool get isUsuario => rol == 4;
  bool get isCliente => rol == 5;

  String get rolNombre {
    switch (rol) {
      case 1:
        return 'Administrador';
      case 2:
        return 'Técnico';
      case 3:
        return 'Consignatario';
      case 4:
        return 'Usuario / Agencia';
      case 5:
        return 'Cliente';
      default:
        return 'Desconocido';
    }
  }

  // Permisos por feature
  bool get canManageUsuarios => isAdmin;
  bool get canViewTracking => isAdmin;
  bool get canCreateAlertas => isAdmin;
  bool get canViewAgencias => true; // Todos los roles autenticados
  bool get canAsignarAgencia =>
      isAdmin || isTecnico || isConsignatario || isUsuario || isCliente;

  @override
  List<Object?> get props => [id, nombre, usuario, correo, telefono, rol, status];
}
