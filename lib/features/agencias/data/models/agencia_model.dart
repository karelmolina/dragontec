import '../../domain/entities/agencia.dart';

class AgenciaModel extends Agencia {
  const AgenciaModel({
    required super.id,
    super.codigo,
    required super.nombre,
    super.direccion,
    super.telefono,
    super.status,
  });

  factory AgenciaModel.fromJson(Map<String, dynamic> json) => AgenciaModel(
        id: json['id'] as int? ?? 0,
        codigo: json['codigo'] as String?,
        nombre: json['nombre'] as String? ?? '',
        direccion: json['direccion'] as String?,
        telefono: json['telefono'] as String?,
        status: json['status'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (codigo != null) 'codigo': codigo,
        'nombre': nombre,
        if (direccion != null) 'direccion': direccion,
        if (telefono != null) 'telefono': telefono,
        if (status != null) 'status': status,
      };

  Agencia toEntity() => Agencia(
        id: id,
        codigo: codigo,
        nombre: nombre,
        direccion: direccion,
        telefono: telefono,
        status: status,
      );
}
