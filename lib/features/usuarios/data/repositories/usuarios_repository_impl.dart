import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuarios_repository.dart';
import '../datasources/usuarios_remote_datasource.dart';
import '../models/usuario_model.dart';

class UsuariosRepositoryImpl implements UsuariosRepository {
  final UsuariosRemoteDataSource remoteDataSource;

  UsuariosRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Usuario>>> getUsuarios({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final result = await remoteDataSource.getUsuarios(
        page: page,
        perPage: perPage,
      );
      return Right(result.map((e) => e.toEntity()).toList());
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
  Future<Either<Failure, Usuario>> createUsuario(Usuario usuario) async {
    try {
      final model = UsuarioModel(
        nombre: usuario.nombre,
        usuario: usuario.usuario,
        correo: usuario.correo,
        telefono: usuario.telefono,
        identificacion: usuario.identificacion,
        rol: usuario.rol,
        status: usuario.status,
        direccion: usuario.direccion,
        idAgencia: usuario.idAgencia,
        idConsignatario: usuario.idConsignatario,
      );
      final result = await remoteDataSource.createUsuario(model);
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
  Future<Either<Failure, Usuario>> updateUsuario(Usuario usuario) async {
    try {
      final model = UsuarioModel(
        id: usuario.id,
        nombre: usuario.nombre,
        usuario: usuario.usuario,
        correo: usuario.correo,
        telefono: usuario.telefono,
        identificacion: usuario.identificacion,
        rol: usuario.rol,
        status: usuario.status,
        direccion: usuario.direccion,
        idAgencia: usuario.idAgencia,
        idConsignatario: usuario.idConsignatario,
      );
      final result = await remoteDataSource.updateUsuario(model);
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
}
