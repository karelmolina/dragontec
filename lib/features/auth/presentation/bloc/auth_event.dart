import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {
  const AppStarted();
}

class LoginRequested extends AuthEvent {
  final String usuario;
  final String clave;
  final String deviceName;

  const LoginRequested({
    required this.usuario,
    required this.clave,
    required this.deviceName,
  });

  @override
  List<Object?> get props => [usuario, clave, deviceName];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckAuthStatusRequested extends AuthEvent {
  const CheckAuthStatusRequested();
}
