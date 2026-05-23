import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/asignar_agencia_cliente.dart';
import '../../domain/usecases/registrar_cliente.dart';
import 'clientes_event.dart';
import 'clientes_state.dart';

class ClientesBloc extends Bloc<ClientesEvent, ClientesState> {
  final RegistrarClienteUseCase registrarClienteUseCase;
  final AsignarAgenciaUseCase asignarAgenciaUseCase;

  ClientesBloc({
    required this.registrarClienteUseCase,
    required this.asignarAgenciaUseCase,
  }) : super(const ClientesInitial()) {
    on<RegistrarCliente>(_onRegistrarCliente);
    on<AsignarAgencia>(_onAsignarAgencia);
    on<ClearClientesError>((_, emit) => emit(const ClientesInitial()));
  }

  Future<void> _onRegistrarCliente(
    RegistrarCliente event,
    Emitter<ClientesState> emit,
  ) async {
    emit(const ClientesLoading());

    final result = await registrarClienteUseCase(
      RegistrarClienteParams(
        nombre: event.nombre,
        usuario: event.usuario,
        clave: event.clave,
        claveConfirmacion: event.claveConfirmacion,
        correo: event.correo,
      ),
    );

    result.fold(
      (failure) => emit(ClientesError(failure.message)),
      (cliente) => emit(ClienteRegistrado(cliente)),
    );
  }

  Future<void> _onAsignarAgencia(
    AsignarAgencia event,
    Emitter<ClientesState> emit,
  ) async {
    emit(const ClientesLoading());

    final result = await asignarAgenciaUseCase(
      AsignarAgenciaParams(idAgencia: event.idAgencia),
    );

    result.fold(
      (failure) => emit(ClientesError(failure.message)),
      (_) => emit(const AgenciaAsignada('Agencia asignada exitosamente')),
    );
  }
}
