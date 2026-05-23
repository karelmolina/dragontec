import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  final int? id;
  final String nombre;
  final String usuario;
  final String? correo;
  final String? telefono;
  final String? identificacion;
  final int rol;
  final int status;
  final String? direccion;
  final int? idAgencia;
  final int? idConsignatario;

  const Usuario({
    this.id,
    required this.nombre,
    required this.usuario,
    this.correo,
    this.telefono,
    this.identificacion,
    required this.rol,
    required this.status,
    this.direccion,
    this.idAgencia,
    this.idConsignatario,
  });

  String get rolNombre {
    switch (rol) {
      case 1:
        return 'Administrador';
      case 2:
        return 'Técnico';
      case 3:
        return 'Consignatario';
      case 4:
        return 'Usuario';
      default:
        return 'Desconocido';
    }
  }

  String get statusNombre => status == 1 ? 'Activo' : 'Inactivo';

  Usuario copyWith({
    int? id,
    String? nombre,
    String? usuario,
    String? correo,
    String? telefono,
    String? identificacion,
    int? rol,
    int? status,
    String? direccion,
    int? idAgencia,
    int? idConsignatario,
  }) =>
      Usuario(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        usuario: usuario ?? this.usuario,
        correo: correo ?? this.correo,
        telefono: telefono ?? this.telefono,
        identificacion: identificacion ?? this.identificacion,
        rol: rol ?? this.rol,
        status: status ?? this.status,
        direccion: direccion ?? this.direccion,
        idAgencia: idAgencia ?? this.idAgencia,
        idConsignatario: idConsignatario ?? this.idConsignatario,
      );

  @override
  List<Object?> get props => [
        id,
        nombre,
        usuario,
        correo,
        telefono,
        identificacion,
        rol,
        status,
        direccion,
        idAgencia,
        idConsignatario,
      ];
}
