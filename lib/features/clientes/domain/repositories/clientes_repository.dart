import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cliente.dart';

abstract class ClientesRepository {
  Future<Either<Failure, Cliente>> registrarCliente({
    required String nombre,
    required String usuario,
    required String clave,
    required String claveConfirmacion,
    String? correo,
  });

  Future<Either<Failure, void>> asignarAgencia({
    required int idAgencia,
  });
}
