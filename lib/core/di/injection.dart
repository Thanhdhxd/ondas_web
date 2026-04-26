import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:ondas_web/core/network/dio_client.dart';
import 'package:ondas_web/core/network/jwt_interceptor.dart';
import 'package:ondas_web/core/storage/secure_storage.dart';
import 'package:ondas_web/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ondas_web/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:ondas_web/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ondas_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:ondas_web/features/auth/domain/usecases/login_usecase.dart';
import 'package:ondas_web/features/auth/domain/usecases/login_usecase_impl.dart';
import 'package:ondas_web/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ondas_web/features/auth/domain/usecases/logout_usecase_impl.dart';
import 'package:ondas_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ondas_web/features/artists/data/datasources/artist_remote_datasource.dart';
import 'package:ondas_web/features/artists/data/datasources/artist_remote_datasource_impl.dart';
import 'package:ondas_web/features/artists/data/repositories/artist_repository_impl.dart';
import 'package:ondas_web/features/artists/domain/repositories/artist_repository.dart';
import 'package:ondas_web/features/artists/domain/usecases/create_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/create_artist_usecase_impl.dart';
import 'package:ondas_web/features/artists/domain/usecases/delete_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/delete_artist_usecase_impl.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artist_usecase_impl.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artists_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/get_artists_usecase_impl.dart';
import 'package:ondas_web/features/artists/domain/usecases/update_artist_usecase.dart';
import 'package:ondas_web/features/artists/domain/usecases/update_artist_usecase_impl.dart';
import 'package:ondas_web/features/artists/presentation/bloc/artist_bloc.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ── Storage ────────────────────────────────────────────────────────────────
  const flutterSecureStorage = FlutterSecureStorage(
    webOptions: WebOptions(dbName: 'ondas_admin', publicKey: 'ondas_admin'),
  );
  sl.registerLazySingleton<SecureStorage>(
    () => SecureStorage(flutterSecureStorage),
  );

  // ── Network ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<JwtInterceptor>(
    () => JwtInterceptor(sl<SecureStorage>()),
  );
  sl.registerLazySingleton<DioClient>(
    () => DioClient(sl<JwtInterceptor>()),
  );

  // ── Auth Feature ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>(), sl<SecureStorage>()),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCaseImpl(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCaseImpl(sl<AuthRepository>()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(loginUseCase: sl<LoginUseCase>()),
  );
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      logoutUseCase: sl<LogoutUseCase>(),
      secureStorage: sl<SecureStorage>(),
    ),
  );

  // ── Artists Feature ────────────────────────────────────────────────────────
  sl.registerLazySingleton<ArtistRemoteDataSource>(
    () => ArtistRemoteDataSourceImpl(sl<DioClient>()),
  );
  sl.registerLazySingleton<ArtistRepository>(
    () => ArtistRepositoryImpl(sl<ArtistRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetArtistsUseCase>(
    () => GetArtistsUseCaseImpl(sl<ArtistRepository>()),
  );
  sl.registerLazySingleton<GetArtistUseCase>(
    () => GetArtistUseCaseImpl(sl<ArtistRepository>()),
  );
  sl.registerLazySingleton<CreateArtistUseCase>(
    () => CreateArtistUseCaseImpl(sl<ArtistRepository>()),
  );
  sl.registerLazySingleton<UpdateArtistUseCase>(
    () => UpdateArtistUseCaseImpl(sl<ArtistRepository>()),
  );
  sl.registerLazySingleton<DeleteArtistUseCase>(
    () => DeleteArtistUseCaseImpl(sl<ArtistRepository>()),
  );
  sl.registerFactory<ArtistBloc>(
    () => ArtistBloc(
      getArtistsUseCase: sl<GetArtistsUseCase>(),
      getArtistUseCase: sl<GetArtistUseCase>(),
      createArtistUseCase: sl<CreateArtistUseCase>(),
      updateArtistUseCase: sl<UpdateArtistUseCase>(),
      deleteArtistUseCase: sl<DeleteArtistUseCase>(),
    ),
  );
}
