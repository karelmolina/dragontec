import '../../domain/entities/alerta_paquete.dart';

class AlertaPaqueteModel extends AlertaPaquete {
  const AlertaPaqueteModel({
    required super.diaLlegada,
    required super.nombreCliente,
    required super.trackingCourier,
    required super.idCourier,
    required super.idAgencia,
    required super.idTipoalerta,
    required super.flete,
    required super.cantPiezas,
    required super.descripcion,
    required super.instrucciones,
  });

  factory AlertaPaqueteModel.fromJson(Map<String, dynamic> json) =>
      AlertaPaqueteModel(
        diaLlegada: json['dia_llegada'] != null
            ? DateTime.parse(json['dia_llegada'] as String)
            : null,
        nombreCliente: json['nombre_cliente'] as String? ?? '',
        trackingCourier: json['tracking_courier'] as String? ?? '',
        idCourier: json['id_courier'] as int? ?? 0,
        idAgencia: json['id_agencia'] as int? ?? 0,
        idTipoalerta: json['id_tipoalerta'] as int? ?? 0,
        flete: json['flete'] as String? ?? '',
        cantPiezas: json['cant_piezas'] as int? ?? 0,
        descripcion: json['descripcion'] as String? ?? '',
        instrucciones: json['instrucciones'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'nombre_cliente': nombreCliente,
    'tracking_courier': trackingCourier,
    'id_courier': idCourier,
    'id_agencia': idAgencia,
    'id_tipoalerta': idTipoalerta,
    'flete': flete,
    'cant_piezas': cantPiezas,
    'descripcion': descripcion,
    'instrucciones': instrucciones,
    if (diaLlegada != null) 'dia_llegada': diaLlegada!.toIso8601String(),
  };

  AlertaPaquete toEntity() => AlertaPaquete(
        diaLlegada: diaLlegada,
        nombreCliente: nombreCliente,
        trackingCourier: trackingCourier,
        idCourier: idCourier,
        idAgencia: idAgencia,
        idTipoalerta: idTipoalerta,
        flete: flete,
        cantPiezas: cantPiezas,
        descripcion: descripcion,
        instrucciones: instrucciones,
      );
}
