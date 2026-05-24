import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/alerta_paquete.dart';

abstract class AlertasRepository {
  Future<Either<Failure, void>> createAlerta(AlertaPaquete alerta);
}
