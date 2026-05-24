import 'package:equatable/equatable.dart';

import '../../domain/entities/paquete.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {
  const TrackingInitial();
}

class TrackingLoading extends TrackingState {
  const TrackingLoading();
}

class TrackingLoaded extends TrackingState {
  final Paquete paquete;

  const TrackingLoaded({required this.paquete});

  @override
  List<Object?> get props => [paquete];
}

class TrackingNotFound extends TrackingState {
  const TrackingNotFound();
}

class TrackingError extends TrackingState {
  final String message;

  const TrackingError({required this.message});

  @override
  List<Object?> get props => [message];
}
