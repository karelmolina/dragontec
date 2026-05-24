import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';

/// Widget que protege una vista según los roles permitidos.
/// Si el usuario no tiene un rol autorizado, muestra una pantalla de acceso denegado.
class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<int> allowedRoles;
  final String? title;

  const RoleGuard({
    super.key,
    required this.child,
    required this.allowedRoles,
    this.title,
  });

  /// Factory para solo admin (rol 1)
  factory RoleGuard.admin({required Widget child, String? title}) {
    return RoleGuard(
      allowedRoles: const [1],
      title: title,
      child: child,
    );
  }

  /// Factory para todos los roles autenticados
  factory RoleGuard.authenticated({required Widget child, String? title}) {
    return RoleGuard(
      allowedRoles: const [1, 2, 3, 4],
      title: title,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! AuthAuthenticated) {
          // No autenticado, redirigir a login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(AppRoutes.login);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;
        if (!allowedRoles.contains(user.rol)) {
          return Scaffold(
            appBar: title != null ? AppBar(title: Text(title!)) : null,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Acceso denegado',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No tienes permiso para acceder a esta sección.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.go(AppRoutes.home),
                      icon: const Icon(Icons.home),
                      label: const Text('Volver al inicio'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return child;
      },
    );
  }
}
