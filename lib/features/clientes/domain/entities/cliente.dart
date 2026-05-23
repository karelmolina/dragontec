import 'package:equatable/equatable.dart';

class Cliente extends Equatable {
  final int? id;
  final String nombre;
  final String usuario;
  final String? correo;
  final int? idAgencia;

  const Cliente({
    this.id,
    required this.nombre,
    required this.usuario,
    this.correo,
    this.idAgencia,
  });

  Cliente copyWith({
    int? id,
    String? nombre,
    String? usuario,
    String? correo,
    int? idAgencia,
  }) =>
      Cliente(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        usuario: usuario ?? this.usuario,
        correo: correo ?? this.correo,
        idAgencia: idAgencia ?? this.idAgencia,
      );

  @override
  List<Object?> get props => [id, nombre, usuario, correo, idAgencia];
}
