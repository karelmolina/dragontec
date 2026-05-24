import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/create_alerta_paquete.dart';
import 'alertas_event.dart';
import 'alertas_state.dart';

class AlertasBloc extends Bloc<AlertasEvent, AlertasState> {
  final CreateAlertaPaqueteUseCase createAlertaUseCase;

  AlertasBloc({required this.createAlertaUseCase})
      : super(const AlertasInitial()) {
    on<CreateAlerta>(_onCreateAlerta);
    on<ResetAlerta>((_, emit) => emit(const AlertasInitial()));
  }

  Future<void> _onCreateAlerta(
    CreateAlerta event,
    Emitter<AlertasState> emit,
  ) async {
    emit(const AlertasLoading());

    final result = await createAlertaUseCase(event.params);

    result.fold(
      (failure) => emit(AlertasError(message: _mapFailureToMessage(failure))),
      (_) => emit(const AlertasCreated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is UnauthorizedFailure) {
      return failure.message;
    }
    return failure.message;
  }
}
