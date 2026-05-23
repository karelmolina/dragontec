import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/usuario.dart';

abstract class UsuariosRepository {
  Future<Either<Failure, List<Usuario>>> getUsuarios({
    int page,
    int perPage,
  });

  Future<Either<Failure, Usuario>> createUsuario(Usuario usuario);

  Future<Either<Failure, Usuario>> updateUsuario(Usuario usuario);
}
