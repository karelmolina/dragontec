import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/usuario.dart';
import '../repositories/usuarios_repository.dart';

class GetUsuariosParams {
  final int page;
  final int perPage;

  const GetUsuariosParams({this.page = 1, this.perPage = 10});
}

class GetUsuariosUseCase implements UseCase<List<Usuario>, GetUsuariosParams> {
  final UsuariosRepository repository;

  GetUsuariosUseCase(this.repository);

  @override
  Future<Either<Failure, List<Usuario>>> call(GetUsuariosParams params) =>
      repository.getUsuarios(page: params.page, perPage: params.perPage);
}
