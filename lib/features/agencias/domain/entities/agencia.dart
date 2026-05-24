import 'package:equatable/equatable.dart';

class Agencia extends Equatable {
  final int id;
  final String? codigo;
  final String nombre;
  final String? representante;
  final String? correo;
  final String? direccion;
  final String? telefono;
  final int? status;
  final String? logo;
  final String? consignatarioNombre;

  const Agencia({
    required this.id,
    this.codigo,
    required this.nombre,
    this.representante,
    this.correo,
    this.direccion,
    this.telefono,
    this.status,
    this.logo,
    this.consignatarioNombre,
  });

  String get statusNombre => status == 1 ? 'Activo' : 'Inactivo';

  Agencia copyWith({
    int? id,
    String? codigo,
    String? nombre,
    String? representante,
    String? correo,
    String? direccion,
    String? telefono,
    int? status,
    String? logo,
    String? consignatarioNombre,
  }) =>
      Agencia(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
        representante: representante ?? this.representante,
        correo: correo ?? this.correo,
        direccion: direccion ?? this.direccion,
        telefono: telefono ?? this.telefono,
        status: status ?? this.status,
        logo: logo ?? this.logo,
        consignatarioNombre: consignatarioNombre ?? this.consignatarioNombre,
      );

  @override
  List<Object?> get props => [
        id,
        codigo,
        nombre,
        representante,
        correo,
        direccion,
        telefono,
        status,
        logo,
        consignatarioNombre,
      ];
}
