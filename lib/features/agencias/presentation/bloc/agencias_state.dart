import 'package:equatable/equatable.dart';

import '../../domain/entities/agencia.dart';

abstract class AgenciasState extends Equatable {
  const AgenciasState();

  @override
  List<Object?> get props => [];
}

class AgenciasInitial extends AgenciasState {
  const AgenciasInitial();
}

class AgenciasLoading extends AgenciasState {
  const AgenciasLoading();
}

class AgenciasLoaded extends AgenciasState {
  final List<Agencia> agencias;
  final int currentPage;
  final bool hasReachedMax;

  const AgenciasLoaded({
    required this.agencias,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  AgenciasLoaded copyWith({
    List<Agencia>? agencias,
    int? currentPage,
    bool? hasReachedMax,
  }) =>
      AgenciasLoaded(
        agencias: agencias ?? this.agencias,
        currentPage: currentPage ?? this.currentPage,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  List<Object?> get props => [agencias, currentPage, hasReachedMax];
}

class AgenciasError extends AgenciasState {
  final String message;

  const AgenciasError(this.message);

  @override
  List<Object?> get props => [message];
}
