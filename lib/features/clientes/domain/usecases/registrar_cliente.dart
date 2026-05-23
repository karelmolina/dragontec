import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cliente.dart';
import '../repositories/clientes_repository.dart';

class RegistrarClienteParams {
  final String nombre;
  final String usuario;
  final String clave;
  final String claveConfirmacion;
  final String? correo;

  const RegistrarClienteParams({
    required this.nombre,
    required this.usuario,
    required this.clave,
    required this.claveConfirmacion,
    this.correo,
  });
}

class RegistrarClienteUseCase implements UseCase<Cliente, RegistrarClienteParams> {
  final ClientesRepository repository;

  RegistrarClienteUseCase(this.repository);

  @override
  Future<Either<Failure, Cliente>> call(RegistrarClienteParams params) =>
      repository.registrarCliente(
        nombre: params.nombre,
        usuario: params.usuario,
        clave: params.clave,
        claveConfirmacion: params.claveConfirmacion,
        correo: params.correo,
      );
}
