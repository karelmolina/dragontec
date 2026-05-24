import '../../domain/entities/agencia.dart';

class AgenciaModel extends Agencia {
  const AgenciaModel({
    required super.id,
    super.codigo,
    required super.nombre,
    super.representante,
    super.correo,
    super.direccion,
    super.telefono,
    super.status,
    super.logo,
    super.consignatarioNombre,
  });

  factory AgenciaModel.fromJson(Map<String, dynamic> json) {
    String? consignatarioNombre;
    final consignatario = json['consignatario'];
    if (consignatario is Map<String, dynamic>) {
      consignatarioNombre = consignatario['nombre'] as String?;
    }

    return AgenciaModel(
      id: json['id'] as int? ?? 0,
      codigo: json['codigo'] as String?,
      nombre: json['nombre'] as String? ?? '',
      representante: json['representante'] as String?,
      correo: json['correo'] as String?,
      direccion: json['direccion'] as String?,
      telefono: json['telefono'] as String?,
      status: json['status'] as int?,
      logo: json['logo'] as String?,
      consignatarioNombre: consignatarioNombre,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (codigo != null) 'codigo': codigo,
        'nombre': nombre,
        if (representante != null) 'representante': representante,
        if (correo != null) 'correo': correo,
        if (direccion != null) 'direccion': direccion,
        if (telefono != null) 'telefono': telefono,
        if (status != null) 'status': status,
        if (logo != null) 'logo': logo,
        if (consignatarioNombre != null)
          'consignatario': {'nombre': consignatarioNombre},
      };

  Agencia toEntity() => Agencia(
        id: id,
        codigo: codigo,
        nombre: nombre,
        representante: representante,
        correo: correo,
        direccion: direccion,
        telefono: telefono,
        status: status,
        logo: logo,
        consignatarioNombre: consignatarioNombre,
      );
}
