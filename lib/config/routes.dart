import 'package:go_router/go_router.dart';

import '../features/agencias/presentation/pages/agencias_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/clientes/presentation/pages/asignar_agencia_page.dart';
import '../features/clientes/presentation/pages/registro_cliente_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/usuarios/presentation/pages/usuarios_list_page.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String usuarios = '/usuarios';
  static const String registroCliente = '/registro-cliente';
  static const String agencias = '/agencias';
  static const String asignarAgencia = '/asignar-agencia';
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
      path: AppRoutes.usuarios,
      builder: (context, state) => const UsuariosListPage(),
    ),
    GoRoute(
      path: AppRoutes.registroCliente,
      builder: (context, state) => const RegistroClientePage(),
    ),
    GoRoute(
      path: AppRoutes.agencias,
      builder: (context, state) => const AgenciasPage(),
    ),
    GoRoute(
      path: AppRoutes.asignarAgencia,
      builder: (context, state) => const AsignarAgenciaPage(),
    ),
  ],
);
