import '../../domain/entities/cliente.dart';

class ClienteModel extends Cliente {
  const ClienteModel({
    super.id,
    required super.nombre,
    required super.usuario,
    super.correo,
    super.idAgencia,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) => ClienteModel(
        id: json['id'] as int?,
        nombre: json['nombre'] as String? ?? '',
        usuario: json['usuario'] as String? ?? '',
        correo: json['correo'] as String?,
        idAgencia: json['id_agencia'] as int?,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'usuario': usuario,
        if (correo != null) 'correo': correo,
        if (idAgencia != null) 'id_agencia': idAgencia,
      };

  Map<String, dynamic> toRegistroJson() => {
        'nombre': nombre,
        'usuario': usuario,
        if (correo != null) 'correo': correo,
      };

  Cliente toEntity() => Cliente(
        id: id,
        nombre: nombre,
        usuario: usuario,
        correo: correo,
        idAgencia: idAgencia,
      );
}
