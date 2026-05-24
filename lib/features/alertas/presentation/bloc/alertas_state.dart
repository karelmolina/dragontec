import 'package:equatable/equatable.dart';

abstract class AlertasState extends Equatable {
  const AlertasState();

  @override
  List<Object?> get props => [];
}

class AlertasInitial extends AlertasState {
  const AlertasInitial();
}

class AlertasLoading extends AlertasState {
  const AlertasLoading();
}

class AlertasCreated extends AlertasState {
  const AlertasCreated();
}

class AlertasError extends AlertasState {
  final String message;

  const AlertasError({required this.message});

  @override
  List<Object?> get props => [message];
}
