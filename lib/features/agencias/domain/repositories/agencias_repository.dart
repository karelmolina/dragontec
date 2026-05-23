import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/agencia.dart';

abstract class AgenciasRepository {
  Future<Either<Failure, List<Agencia>>> getAgencias({
    int page,
    int perPage,
    int? id,
    String? codigo,
    String? nombre,
  });
}
