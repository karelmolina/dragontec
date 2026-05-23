import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_agencias.dart';
import 'agencias_event.dart';
import 'agencias_state.dart';

class AgenciasBloc extends Bloc<AgenciasEvent, AgenciasState> {
  final GetAgenciasUseCase getAgenciasUseCase;

  AgenciasBloc({required this.getAgenciasUseCase})
      : super(const AgenciasInitial()) {
    on<LoadAgencias>(_onLoadAgencias);
    on<ClearAgenciasError>((_, emit) => emit(const AgenciasInitial()));
  }

  Future<void> _onLoadAgencias(
    LoadAgencias event,
    Emitter<AgenciasState> emit,
  ) async {
    emit(const AgenciasLoading());

    final result = await getAgenciasUseCase(
      GetAgenciasParams(
        page: event.page,
        perPage: event.perPage,
        id: event.id,
        codigo: event.codigo,
        nombre: event.nombre,
      ),
    );

    result.fold(
      (failure) => emit(AgenciasError(failure.message)),
      (agencias) => emit(
        AgenciasLoaded(
          agencias: agencias,
          currentPage: event.page,
          hasReachedMax: agencias.length < event.perPage,
        ),
      ),
    );
  }
}
