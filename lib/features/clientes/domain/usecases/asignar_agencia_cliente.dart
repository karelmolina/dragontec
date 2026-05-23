import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/clientes_repository.dart';

class AsignarAgenciaParams {
  final int idAgencia;

  const AsignarAgenciaParams({required this.idAgencia});
}

class AsignarAgenciaUseCase implements UseCase<void, AsignarAgenciaParams> {
  final ClientesRepository repository;

  AsignarAgenciaUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AsignarAgenciaParams params) =>
      repository.asignarAgencia(idAgencia: params.idAgencia);
}
