import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/alerta_paquete.dart';
import '../repositories/alertas_repository.dart';

class CreateAlertaPaqueteParams {
  final DateTime? diaLlegada;
  final String nombreCliente;
  final String trackingCourier;
  final int idCourier;
  final int idAgencia;
  final int idTipoalerta;
  final String flete;
  final int cantPiezas;
  final String descripcion;
  final String instrucciones;

  const CreateAlertaPaqueteParams({
    required this.diaLlegada,
    required this.nombreCliente,
    required this.trackingCourier,
    required this.idCourier,
    required this.idAgencia,
    required this.idTipoalerta,
    required this.flete,
    required this.cantPiezas,
    required this.descripcion,
    required this.instrucciones,
  });
}

class CreateAlertaPaqueteUseCase
    implements UseCase<void, CreateAlertaPaqueteParams> {
  final AlertasRepository repository;

  CreateAlertaPaqueteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateAlertaPaqueteParams params) async {
    final alerta = AlertaPaquete(
      diaLlegada: params.diaLlegada,
      nombreCliente: params.nombreCliente,
      trackingCourier: params.trackingCourier,
      idCourier: params.idCourier,
      idAgencia: params.idAgencia,
      idTipoalerta: params.idTipoalerta,
      flete: params.flete,
      cantPiezas: params.cantPiezas,
      descripcion: params.descripcion,
      instrucciones: params.instrucciones,
    );

    return repository.createAlerta(alerta);
  }
}
