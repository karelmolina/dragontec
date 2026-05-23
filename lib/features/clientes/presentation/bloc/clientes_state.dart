import 'package:equatable/equatable.dart';

import '../../domain/entities/cliente.dart';

abstract class ClientesState extends Equatable {
  const ClientesState();

  @override
  List<Object?> get props => [];
}

class ClientesInitial extends ClientesState {
  const ClientesInitial();
}

class ClientesLoading extends ClientesState {
  const ClientesLoading();
}

class ClienteRegistrado extends ClientesState {
  final Cliente cliente;

  const ClienteRegistrado(this.cliente);

  @override
  List<Object?> get props => [cliente];
}

class AgenciaAsignada extends ClientesState {
  final String message;

  const AgenciaAsignada(this.message);

  @override
  List<Object?> get props => [message];
}

class ClientesError extends ClientesState {
  final String message;

  const ClientesError(this.message);

  @override
  List<Object?> get props => [message];
}
