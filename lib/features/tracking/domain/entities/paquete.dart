import 'package:equatable/equatable.dart';

class Paquete extends Equatable {
  final String tracking;
  final String estado;
  final String? origen;
  final String? destino;
  final DateTime? fechaRegistro;
  final DateTime? fechaEstimada;

  const Paquete({
    required this.tracking,
    required this.estado,
    this.origen,
    this.destino,
    this.fechaRegistro,
    this.fechaEstimada,
  });

  @override
  List<Object?> get props => [
    tracking,
    estado,
    origen,
    destino,
    fechaRegistro,
    fechaEstimada,
  ];
}
