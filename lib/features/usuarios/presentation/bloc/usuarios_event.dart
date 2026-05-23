import 'package:equatable/equatable.dart';

import '../../domain/entities/usuario.dart';

abstract class UsuariosEvent extends Equatable {
  const UsuariosEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsuarios extends UsuariosEvent {
  final int page;
  final int perPage;

  const LoadUsuarios({this.page = 1, this.perPage = 10});

  @override
  List<Object?> get props => [page, perPage];
}

class CreateUsuario extends UsuariosEvent {
  final Usuario usuario;

  const CreateUsuario(this.usuario);

  @override
  List<Object?> get props => [usuario];
}

class UpdateUsuario extends UsuariosEvent {
  final Usuario usuario;

  const UpdateUsuario(this.usuario);

  @override
  List<Object?> get props => [usuario];
}

class ClearUsuariosError extends UsuariosEvent {
  const ClearUsuariosError();
}
