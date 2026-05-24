import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.nombre,
    required super.usuario,
    super.correo,
    super.telefono,
    required super.rol,
    required super.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int? ?? 0,
        nombre: json['nombre'] as String? ?? '',
        usuario: json['usuario'] as String? ?? '',
        correo: json['correo'] as String?,
        telefono: json['telefono'] as String?,
        rol: json['rol'] as int? ?? 0,
        status: json['status'] as int? ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'usuario': usuario,
        'correo': correo,
        'telefono': telefono,
        'rol': rol,
        'status': status,
      };

  User toEntity() => User(
        id: id,
        nombre: nombre,
        usuario: usuario,
        correo: correo,
        telefono: telefono,
        rol: rol,
        status: status,
      );
}
