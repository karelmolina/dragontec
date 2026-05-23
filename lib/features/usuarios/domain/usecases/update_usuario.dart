import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/usuario.dart';
import '../repositories/usuarios_repository.dart';

class UpdateUsuarioUseCase implements UseCase<Usuario, Usuario> {
  final UsuariosRepository repository;

  UpdateUsuarioUseCase(this.repository);

  @override
  Future<Either<Failure, Usuario>> call(Usuario usuario) =>
      repository.updateUsuario(usuario);
}
