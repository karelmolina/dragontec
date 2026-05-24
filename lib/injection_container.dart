import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/api_client.dart';
import 'core/network/api_interceptors.dart';
import 'core/network/network_info.dart';
import 'features/agencias/data/datasources/agencias_remote_datasource.dart';
import 'features/agencias/data/repositories/agencias_repository_impl.dart';
import 'features/agencias/domain/repositories/agencias_repository.dart';
import 'features/agencias/domain/usecases/get_agencias.dart';
import 'features/agencias/presentation/bloc/agencias_bloc.dart';
import 'features/alertas/data/datasources/alertas_remote_datasource.dart';
import 'features/alertas/data/repositories/alertas_repository_impl.dart';
import 'features/alertas/domain/repositories/alertas_repository.dart';
import 'features/alertas/domain/usecases/create_alerta_paquete.dart';
import 'features/alertas/presentation/bloc/alertas_bloc.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_auth_status.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/clientes/data/datasources/clientes_remote_datasource.dart';
import 'features/clientes/data/repositories/clientes_repository_impl.dart';
import 'features/clientes/domain/repositories/clientes_repository.dart';
import 'features/clientes/domain/usecases/asignar_agencia_cliente.dart';
import 'features/clientes/domain/usecases/registrar_cliente.dart';
import 'features/clientes/presentation/bloc/clientes_bloc.dart';
import 'features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'features/tracking/data/repositories/tracking_repository_impl.dart';
import 'features/tracking/domain/repositories/tracking_repository.dart';
import 'features/tracking/domain/usecases/get_tracking_by_courier.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/usuarios/data/datasources/usuarios_remote_datasource.dart';
import 'features/usuarios/data/repositories/usuarios_repository_impl.dart';
import 'features/usuarios/domain/repositories/usuarios_repository.dart';
import 'features/usuarios/domain/usecases/create_usuario.dart';
import 'features/usuarios/domain/usecases/get_usuarios.dart';
import 'features/usuarios/domain/usecases/update_usuario.dart';
import 'features/usuarios/presentation/bloc/usuarios_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Interceptors
  sl.registerLazySingleton(
    () => AuthInterceptor(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoggingInterceptor());

  // API Client
  sl.registerLazySingleton(
    () => ApiClient(
      authInterceptor: sl(),
      loggingInterceptor: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Usuarios data sources
  sl.registerLazySingleton<UsuariosRemoteDataSource>(
    () => UsuariosRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // Usuarios repositories
  sl.registerLazySingleton<UsuariosRepository>(
    () => UsuariosRepositoryImpl(remoteDataSource: sl()),
  );

  // Clientes data sources
  sl.registerLazySingleton<ClientesRemoteDataSource>(
    () => ClientesRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // Clientes repositories
  sl.registerLazySingleton<ClientesRepository>(
    () => ClientesRepositoryImpl(remoteDataSource: sl()),
  );

  // Agencias data sources
  sl.registerLazySingleton<AgenciasRemoteDataSource>(
    () => AgenciasRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // Agencias repositories
  sl.registerLazySingleton<AgenciasRepository>(
    () => AgenciasRepositoryImpl(remoteDataSource: sl()),
  );

  // Tracking data sources
  sl.registerLazySingleton<TrackingRemoteDataSource>(
    () => TrackingRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // Tracking repositories
  sl.registerLazySingleton<TrackingRepository>(
    () => TrackingRepositoryImpl(remoteDataSource: sl()),
  );

  // Alertas data sources
  sl.registerLazySingleton<AlertasRemoteDataSource>(
    () => AlertasRemoteDataSourceImpl(dio: sl<ApiClient>().dio),
  );

  // Alertas repositories
  sl.registerLazySingleton<AlertasRepository>(
    () => AlertasRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetUsuariosUseCase(sl()));
  sl.registerLazySingleton(() => CreateUsuarioUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUsuarioUseCase(sl()));
  sl.registerLazySingleton(() => RegistrarClienteUseCase(sl()));
  sl.registerLazySingleton(() => AsignarAgenciaUseCase(sl()));
  sl.registerLazySingleton(() => GetAgenciasUseCase(sl()));
  sl.registerLazySingleton(() => GetTrackingByCourierUseCase(sl()));
  sl.registerLazySingleton(() => CreateAlertaPaqueteUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UsuariosBloc(
      getUsuariosUseCase: sl(),
      createUsuarioUseCase: sl(),
      updateUsuarioUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ClientesBloc(
      registrarClienteUseCase: sl(),
      asignarAgenciaUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AgenciasBloc(getAgenciasUseCase: sl()),
  );
  sl.registerFactory(
    () => TrackingBloc(getTrackingByCourierUseCase: sl()),
  );
  sl.registerFactory(
    () => AlertasBloc(createAlertaUseCase: sl()),
  );
}
