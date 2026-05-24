import 'package:equatable/equatable.dart';

class AlertaPaquete extends Equatable {
  final DateTime? diaLlegada;
  final String nombreCliente;
  final String trackingCourier;
  final int idCourier;
  final int idAgencia;
  final int idTipoalerta;
  final String flete;
  final int cantPiezas;
  final String descripcion;
  final String instrucciones;

  const AlertaPaquete({
    required this.diaLlegada,
    required this.nombreCliente,
    required this.trackingCourier,
    required this.idCourier,
    required this.idAgencia,
    required this.idTipoalerta,
    required this.flete,
    required this.cantPiezas,
    required this.descripcion,
    required this.instrucciones,
  });

  @override
  List<Object?> get props => [
        diaLlegada,
        nombreCliente,
        trackingCourier,
        idCourier,
        idAgencia,
        idTipoalerta,
        flete,
        cantPiezas,
        descripcion,
        instrucciones,
      ];
}
