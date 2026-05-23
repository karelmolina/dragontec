import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/repositories/clientes_repository.dart';
import '../datasources/clientes_remote_datasource.dart';

class ClientesRepositoryImpl implements ClientesRepository {
  final ClientesRemoteDataSource remoteDataSource;

  ClientesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Cliente>> registrarCliente({
    required String nombre,
    required String usuario,
    required String clave,
    required String claveConfirmacion,
    String? correo,
  }) async {
    try {
      final result = await remoteDataSource.registrarCliente(
        nombre: nombre,
        usuario: usuario,
        clave: clave,
        claveConfirmacion: claveConfirmacion,
        correo: correo,
      );
      return Right(result.toEntity());
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

  @override
  Future<Either<Failure, void>> asignarAgencia({
    required int idAgencia,
  }) async {
    try {
      await remoteDataSource.asignarAgencia(idAgencia: idAgencia);
      return const Right(null);
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
