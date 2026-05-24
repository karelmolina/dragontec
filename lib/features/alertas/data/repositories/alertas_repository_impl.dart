import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/alerta_paquete.dart';
import '../../domain/repositories/alertas_repository.dart';
import '../datasources/alertas_remote_datasource.dart';
import '../models/alerta_paquete_model.dart';

class AlertasRepositoryImpl implements AlertasRepository {
  final AlertasRemoteDataSource remoteDataSource;

  AlertasRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> createAlerta(AlertaPaquete alerta) async {
    try {
      final model = AlertaPaqueteModel(
        diaLlegada: alerta.diaLlegada,
        nombreCliente: alerta.nombreCliente,
        trackingCourier: alerta.trackingCourier,
        idCourier: alerta.idCourier,
        idAgencia: alerta.idAgencia,
        idTipoalerta: alerta.idTipoalerta,
        flete: alerta.flete,
        cantPiezas: alerta.cantPiezas,
        descripcion: alerta.descripcion,
        instrucciones: alerta.instrucciones,
      );

      await remoteDataSource.createAlerta(model);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
