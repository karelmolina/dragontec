import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_usuario.dart';
import '../../domain/usecases/get_usuarios.dart';
import '../../domain/usecases/update_usuario.dart';
import 'usuarios_event.dart';
import 'usuarios_state.dart';

class UsuariosBloc extends Bloc<UsuariosEvent, UsuariosState> {
  final GetUsuariosUseCase getUsuariosUseCase;
  final CreateUsuarioUseCase createUsuarioUseCase;
  final UpdateUsuarioUseCase updateUsuarioUseCase;

  UsuariosBloc({
    required this.getUsuariosUseCase,
    required this.createUsuarioUseCase,
    required this.updateUsuarioUseCase,
  }) : super(const UsuariosInitial()) {
    on<LoadUsuarios>(_onLoadUsuarios);
    on<CreateUsuario>(_onCreateUsuario);
    on<UpdateUsuario>(_onUpdateUsuario);
    on<ClearUsuariosError>((_, emit) => emit(const UsuariosInitial()));
  }

  Future<void> _onLoadUsuarios(
    LoadUsuarios event,
    Emitter<UsuariosState> emit,
  ) async {
    emit(const UsuariosLoading());

    final result = await getUsuariosUseCase(
      GetUsuariosParams(page: event.page, perPage: event.perPage),
    );

    result.fold(
      (failure) => emit(UsuariosError(failure.message)),
      (usuarios) => emit(
        UsuariosLoaded(
          usuarios: usuarios,
          currentPage: event.page,
          hasReachedMax: usuarios.length < event.perPage,
        ),
      ),
    );
  }

  Future<void> _onCreateUsuario(
    CreateUsuario event,
    Emitter<UsuariosState> emit,
  ) async {
    emit(const UsuariosLoading());

    final result = await createUsuarioUseCase(event.usuario);

    result.fold(
      (failure) => emit(UsuariosError(failure.message)),
      (_) => emit(const UsuarioOperationSuccess('Usuario creado exitosamente')),
    );
  }

  Future<void> _onUpdateUsuario(
    UpdateUsuario event,
    Emitter<UsuariosState> emit,
  ) async {
    emit(const UsuariosLoading());

    final result = await updateUsuarioUseCase(event.usuario);

    result.fold(
      (failure) => emit(UsuariosError(failure.message)),
      (_) => emit(const UsuarioOperationSuccess('Usuario actualizado exitosamente')),
    );
  }
}
