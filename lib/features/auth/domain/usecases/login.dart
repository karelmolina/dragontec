import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String usuario;
  final String clave;
  final String deviceName;

  const LoginParams({
    required this.usuario,
    required this.clave,
    required this.deviceName,
  });
}

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) =>
      repository.login(
        usuario: params.usuario,
        clave: params.clave,
        deviceName: params.deviceName,
      );
}
