import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
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
      ],
      child: MaterialApp.router(
        title: 'Horus Logistic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
