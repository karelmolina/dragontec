import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/paquete.dart';
import '../repositories/tracking_repository.dart';

class GetTrackingByCourierParams {
  final String trackingCourier;

  const GetTrackingByCourierParams({required this.trackingCourier});
}

class GetTrackingByCourierUseCase
    implements UseCase<Paquete, GetTrackingByCourierParams> {
  final TrackingRepository repository;

  GetTrackingByCourierUseCase(this.repository);

  @override
  Future<Either<Failure, Paquete>> call(GetTrackingByCourierParams params) =>
      repository.getTracking(params.trackingCourier);
}
