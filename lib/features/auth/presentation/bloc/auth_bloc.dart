import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_auth_status.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final authResult = await checkAuthStatusUseCase(const NoParams());

    await authResult.fold(
      (failure) async => emit(const AuthUnauthenticated()),
      (isAuthenticated) async {
        if (isAuthenticated) {
          final userResult = await getCurrentUserUseCase(const NoParams());
          userResult.fold(
            (failure) => emit(AuthUnauthenticated(message: failure.message)),
            (user) => emit(AuthAuthenticated(user)),
          );
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(
      LoginParams(
        usuario: event.usuario,
        clave: event.clave,
        deviceName: event.deviceName,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    await logoutUseCase(const NoParams());

    // Siempre desloguear localmente, incluso si la petición HTTP falla
    // (token expirado, sin conexión, etc.)
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatusRequested(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await checkAuthStatusUseCase(const NoParams());

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (isAuthenticated) => emit(
        isAuthenticated
            ? const AuthUnauthenticated()
            : const AuthUnauthenticated(),
      ),
    );
  }
}
