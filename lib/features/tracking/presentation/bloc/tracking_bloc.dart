import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_tracking_by_courier.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final GetTrackingByCourierUseCase getTrackingByCourierUseCase;

  TrackingBloc({required this.getTrackingByCourierUseCase})
      : super(const TrackingInitial()) {
    on<SearchTracking>(_onSearchTracking);
  }

  Future<void> _onSearchTracking(
    SearchTracking event,
    Emitter<TrackingState> emit,
  ) async {
    emit(const TrackingLoading());

    final result = await getTrackingByCourierUseCase(
      GetTrackingByCourierParams(trackingCourier: event.trackingCourier),
    );

    result.fold(
      (failure) {
        if (failure is TrackingNotFoundFailure) {
          emit(const TrackingNotFound());
        } else {
          emit(TrackingError(message: failure.message));
        }
      },
      (paquete) => emit(TrackingLoaded(paquete: paquete)),
    );
  }
}
