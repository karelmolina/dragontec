import 'package:equatable/equatable.dart';

abstract class AgenciasEvent extends Equatable {
  const AgenciasEvent();

  @override
  List<Object?> get props => [];
}

class LoadAgencias extends AgenciasEvent {
  final int page;
  final int perPage;
  final int? id;
  final String? codigo;
  final String? nombre;

  const LoadAgencias({
    this.page = 1,
    this.perPage = 10,
    this.id,
    this.codigo,
    this.nombre,
  });

  @override
  List<Object?> get props => [page, perPage, id, codigo, nombre];
}

class ClearAgenciasError extends AgenciasEvent {
  const ClearAgenciasError();
}
