import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/agencia.dart';
import '../../domain/repositories/agencias_repository.dart';
import '../datasources/agencias_remote_datasource.dart';

class AgenciasRepositoryImpl implements AgenciasRepository {
  final AgenciasRemoteDataSource remoteDataSource;

  AgenciasRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Agencia>>> getAgencias({
    int page = 1,
    int perPage = 10,
    int? id,
    String? codigo,
    String? nombre,
  }) async {
    try {
      final result = await remoteDataSource.getAgencias(
        page: page,
        perPage: perPage,
        id: id,
        codigo: codigo,
        nombre: nombre,
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
}
