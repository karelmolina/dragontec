import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/paquete.dart';

abstract class TrackingRepository {
  Future<Either<Failure, Paquete>> getTracking(String trackingCourier);
}
