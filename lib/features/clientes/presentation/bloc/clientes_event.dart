import 'package:equatable/equatable.dart';

abstract class ClientesEvent extends Equatable {
  const ClientesEvent();

  @override
  List<Object?> get props => [];
}

class RegistrarCliente extends ClientesEvent {
  final String nombre;
  final String usuario;
  final String clave;
  final String claveConfirmacion;
  final String? correo;

  const RegistrarCliente({
    required this.nombre,
    required this.usuario,
    required this.clave,
    required this.claveConfirmacion,
    this.correo,
  });

  @override
  List<Object?> get props => [nombre, usuario, clave, claveConfirmacion, correo];
}

class AsignarAgencia extends ClientesEvent {
  final int idAgencia;

  const AsignarAgencia({required this.idAgencia});

  @override
  List<Object?> get props => [idAgencia];
}

class ClearClientesError extends ClientesEvent {
  const ClearClientesError();
}
