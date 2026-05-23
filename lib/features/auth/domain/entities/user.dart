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

  @override
  List<Object?> get props => [id, nombre, usuario, correo, telefono, rol, status];
}
