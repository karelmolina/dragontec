import 'package:equatable/equatable.dart';

class Agencia extends Equatable {
  final int id;
  final String? codigo;
  final String nombre;
  final String? direccion;
  final String? telefono;
  final int? status;

  const Agencia({
    required this.id,
    this.codigo,
    required this.nombre,
    this.direccion,
    this.telefono,
    this.status,
  });

  String get statusNombre => status == 1 ? 'Activo' : 'Inactivo';

  Agencia copyWith({
    int? id,
    String? codigo,
    String? nombre,
    String? direccion,
    String? telefono,
    int? status,
  }) =>
      Agencia(
        id: id ?? this.id,
        codigo: codigo ?? this.codigo,
        nombre: nombre ?? this.nombre,
        direccion: direccion ?? this.direccion,
        telefono: telefono ?? this.telefono,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [id, codigo, nombre, direccion, telefono, status];
}
