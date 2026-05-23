import '../../domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  const UsuarioModel({
    super.id,
    required super.nombre,
    required super.usuario,
    super.correo,
    super.telefono,
    super.identificacion,
    required super.rol,
    required super.status,
    super.direccion,
    super.idAgencia,
    super.idConsignatario,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        id: json['id'] as int?,
        nombre: json['nombre'] as String? ?? '',
        usuario: json['usuario'] as String? ?? '',
        correo: json['correo'] as String?,
        telefono: json['telefono'] as String?,
        identificacion: json['identificacion'] as String?,
        rol: json['rol'] as int? ?? 0,
        status: json['status'] as int? ?? 0,
        direccion: json['direccion'] as String?,
        idAgencia: json['id_agencia'] as int?,
        idConsignatario: json['id_consignatario'] as int?,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'usuario': usuario,
        if (correo != null) 'correo': correo,
        if (telefono != null) 'telefono': telefono,
        if (identificacion != null) 'identificacion': identificacion,
        'rol': rol,
        'status': status,
        if (direccion != null) 'direccion': direccion,
        if (idAgencia != null) 'id_agencia': idAgencia,
        if (idConsignatario != null) 'id_consignatario': idConsignatario,
      };

  Usuario toEntity() => Usuario(
        id: id,
        nombre: nombre,
        usuario: usuario,
        correo: correo,
        telefono: telefono,
        identificacion: identificacion,
        rol: rol,
        status: status,
        direccion: direccion,
        idAgencia: idAgencia,
        idConsignatario: idConsignatario,
      );
}
