import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network/api_client.dart';
import 'core/network/api_interceptors.dart';
import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_auth_status.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
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

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetUsuariosUseCase(sl()));
  sl.registerLazySingleton(() => CreateUsuarioUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUsuarioUseCase(sl()));

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
}
