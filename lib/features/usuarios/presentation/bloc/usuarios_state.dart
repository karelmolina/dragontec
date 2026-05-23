import 'package:equatable/equatable.dart';

import '../../domain/entities/usuario.dart';

abstract class UsuariosState extends Equatable {
  const UsuariosState();

  @override
  List<Object?> get props => [];
}

class UsuariosInitial extends UsuariosState {
  const UsuariosInitial();
}

class UsuariosLoading extends UsuariosState {
  const UsuariosLoading();
}

class UsuariosLoaded extends UsuariosState {
  final List<Usuario> usuarios;
  final int currentPage;
  final bool hasReachedMax;

  const UsuariosLoaded({
    required this.usuarios,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  UsuariosLoaded copyWith({
    List<Usuario>? usuarios,
    int? currentPage,
    bool? hasReachedMax,
  }) =>
      UsuariosLoaded(
        usuarios: usuarios ?? this.usuarios,
        currentPage: currentPage ?? this.currentPage,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  List<Object?> get props => [usuarios, currentPage, hasReachedMax];
}

class UsuariosError extends UsuariosState {
  final String message;

  const UsuariosError(this.message);

  @override
  List<Object?> get props => [message];
}

class UsuarioOperationSuccess extends UsuariosState {
  final String message;

  const UsuarioOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
