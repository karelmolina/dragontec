import 'package:go_router/go_router.dart';

import '../core/widgets/role_guard.dart';
import '../features/agencias/presentation/pages/agencias_page.dart';
import '../features/alertas/presentation/pages/crear_alerta_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/tracking/presentation/pages/tracking_page.dart';
import '../features/usuarios/presentation/pages/usuario_form_page.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String crearUsuario = '/crear-usuario';
  static const String agencias = '/agencias';
  static const String tracking = '/tracking';
  static const String crearAlerta = '/crear-alerta';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.crearUsuario,
      builder: (context, state) => RoleGuard.admin(
        title: 'Crear Usuario',
        child: const UsuarioFormPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.agencias,
      builder: (context, state) => const AgenciasPage(),
    ),
    GoRoute(
      path: AppRoutes.tracking,
      builder: (context, state) => RoleGuard.admin(
        title: 'Tracking',
        child: const TrackingPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.crearAlerta,
      builder: (context, state) => const CrearAlertaPage(),
    ),
  ],
);
