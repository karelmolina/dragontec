import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/agencia.dart';
import '../repositories/agencias_repository.dart';

class GetAgenciasParams {
  final int page;
  final int perPage;
  final int? id;
  final String? codigo;
  final String? nombre;

  const GetAgenciasParams({
    this.page = 1,
    this.perPage = 10,
    this.id,
    this.codigo,
    this.nombre,
  });
}

class GetAgenciasUseCase implements UseCase<List<Agencia>, GetAgenciasParams> {
  final AgenciasRepository repository;

  GetAgenciasUseCase(this.repository);

  @override
  Future<Either<Failure, List<Agencia>>> call(GetAgenciasParams params) =>
      repository.getAgencias(
        page: params.page,
        perPage: params.perPage,
        id: params.id,
        codigo: params.codigo,
        nombre: params.nombre,
      );
}
