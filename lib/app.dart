import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
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
      ],
      child: MaterialApp.router(
        title: 'Horus Logistic',
        debugShowCheckedModeBanner: false,
        theme: horusTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
