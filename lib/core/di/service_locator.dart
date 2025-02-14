import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:la8iny/core/services/cache_service.dart';
import 'package:la8iny/core/services/remote_database_service.dart';
import 'package:la8iny/features/auth/data/repo/auth_repo_impl.dart';
import 'package:la8iny/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8iny/features/auth/presentation/repo/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_database.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../services/remote_auth_service.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  sl.registerFactory(() => AuthCubit(sl()));

  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(
        authLocalDataSource: sl(),
        authRemoteDataSource: sl(),
        authRemoteDatabase: sl(),
      ));

  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRemoteDatabase>(
      () => AuthRemoteDatabaseImpl(sl()));

  sl.registerLazySingleton<RemoteAuthService>(
      () => RemoteAuthServiceImpl(FirebaseAuth.instance));
  sl.registerLazySingleton<CacheService>(() => CacheServiceImpl());
  sl.registerLazySingleton<RemoteDatabaseService>(
      () => RemoteDatabaseServiceImpl(FirebaseFirestore.instance));
}
