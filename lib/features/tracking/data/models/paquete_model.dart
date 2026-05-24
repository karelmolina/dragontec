import '../../domain/entities/paquete.dart';

class PaqueteModel extends Paquete {
  const PaqueteModel({
    required super.tracking,
    required super.estado,
    required super.trackingCourier,
    required super.agencia,
    required super.peso,
    required super.flete,
    required super.descripcion,
    required super.consignatario,
    required super.nombreCiudad,
    required super.nombrePais,
    super.fechaAlmacen,
    required super.colorEstado,
    required super.cantPieza,
  });

  factory PaqueteModel.fromJson(Map<String, dynamic> json) => PaqueteModel(
    tracking: json['tracking'] as String? ?? '',
    estado: json['estado'] as String? ?? '',
    trackingCourier: json['tracking_courier'] as String? ?? '',
    agencia: json['agencia'] as String? ?? '',
    peso: json['peso'] as int? ?? 0,
    flete: json['flete'] as String? ?? '',
    descripcion: json['descripcion'] as String? ?? '',
    consignatario: json['consignatario'] as String? ?? '',
    nombreCiudad: json['nombre_ciudad'] as String? ?? '',
    nombrePais: json['nombre_pais'] as String? ?? '',
    fechaAlmacen: json['fecha_almacen'] as String?,
    colorEstado: json['color_estado'] as String? ?? '',
    cantPieza: json['cant_pieza'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'tracking': tracking,
    'estado': estado,
    'tracking_courier': trackingCourier,
    'agencia': agencia,
    'peso': peso,
    'flete': flete,
    'descripcion': descripcion,
    'consignatario': consignatario,
    'nombre_ciudad': nombreCiudad,
    'nombre_pais': nombrePais,
    if (fechaAlmacen != null) 'fecha_almacen': fechaAlmacen,
    'color_estado': colorEstado,
    'cant_pieza': cantPieza,
  };

  Paquete toEntity() => Paquete(
    tracking: tracking,
    estado: estado,
    trackingCourier: trackingCourier,
    agencia: agencia,
    peso: peso,
    flete: flete,
    descripcion: descripcion,
    consignatario: consignatario,
    nombreCiudad: nombreCiudad,
    nombrePais: nombrePais,
    fechaAlmacen: fechaAlmacen,
    colorEstado: colorEstado,
    cantPieza: cantPieza,
  );
}
