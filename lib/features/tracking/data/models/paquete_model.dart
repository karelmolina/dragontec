import '../../domain/entities/paquete.dart';

class PaqueteModel extends Paquete {
  const PaqueteModel({
    required super.tracking,
    required super.estado,
    super.origen,
    super.destino,
    super.fechaRegistro,
    super.fechaEstimada,
  });

  factory PaqueteModel.fromJson(Map<String, dynamic> json) => PaqueteModel(
        tracking: json['tracking'] as String? ?? '',
        estado: json['estado'] as String? ?? '',
        origen: json['origen'] as String?,
        destino: json['destino'] as String?,
        fechaRegistro: json['fecha_registro'] != null
            ? DateTime.parse(json['fecha_registro'] as String)
            : null,
        fechaEstimada: json['fecha_estimada'] != null
            ? DateTime.parse(json['fecha_estimada'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
    'tracking': tracking,
    'estado': estado,
    if (origen != null) 'origen': origen,
    if (destino != null) 'destino': destino,
    if (fechaRegistro != null)
      'fecha_registro': fechaRegistro!.toIso8601String(),
    if (fechaEstimada != null)
      'fecha_estimada': fechaEstimada!.toIso8601String(),
  };

  Paquete toEntity() => Paquete(
        tracking: tracking,
        estado: estado,
        origen: origen,
        destino: destino,
        fechaRegistro: fechaRegistro,
        fechaEstimada: fechaEstimada,
      );
}
