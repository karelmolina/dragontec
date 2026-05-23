import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String usuario,
    required String clave,
    required String deviceName,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, bool>> isAuthenticated();
}
