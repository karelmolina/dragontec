import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'features/agencias/presentation/bloc/agencias_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/clientes/presentation/bloc/clientes_bloc.dart';
import 'features/usuarios/presentation/bloc/usuarios_bloc.dart';
import 'injection_container.dart';

class DragontecApp extends StatelessWidget {
  const DragontecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<UsuariosBloc>(
          create: (_) => sl<UsuariosBloc>(),
        ),
        BlocProvider<ClientesBloc>(
          create: (_) => sl<ClientesBloc>(),
        ),
        BlocProvider<AgenciasBloc>(
          create: (_) => sl<AgenciasBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Horus Logistic',
        debugShowCheckedModeBanner: false,
        theme: horusTheme,
        routerConfig: appRouter,
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                appRouter.go(AppRoutes.login);
              }
            },
            child: child!,
          );
        },
      ),
    );
  }
}
