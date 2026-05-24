import 'package:equatable/equatable.dart';

class Paquete extends Equatable {
  final String tracking;
  final String estado;
  final String trackingCourier;
  final String agencia;
  final int peso;
  final String flete;
  final String descripcion;
  final String consignatario;
  final String nombreCiudad;
  final String nombrePais;
  final String? fechaAlmacen;
  final String colorEstado;
  final int cantPieza;

  const Paquete({
    required this.tracking,
    required this.estado,
    required this.trackingCourier,
    required this.agencia,
    required this.peso,
    required this.flete,
    required this.descripcion,
    required this.consignatario,
    required this.nombreCiudad,
    required this.nombrePais,
    this.fechaAlmacen,
    required this.colorEstado,
    required this.cantPieza,
  });

  @override
  List<Object?> get props => [
    tracking,
    estado,
    trackingCourier,
    agencia,
    peso,
    flete,
    descripcion,
    consignatario,
    nombreCiudad,
    nombrePais,
    fechaAlmacen,
    colorEstado,
    cantPieza,
  ];
}
