import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:la8iny/core/services/cache_service.dart';
import 'package:la8iny/core/services/remote_database_service.dart';
import 'package:la8iny/features/auth/data/repo/auth_repo_impl.dart';
import 'package:la8iny/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8iny/features/auth/presentation/repo/auth_repo.dart';
import 'package:la8iny/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:la8iny/features/auth/data/datasources/auth_remote_database.dart';
import 'package:la8iny/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:la8iny/features/chat/data/repositories/chat_repository.dart';
import 'package:la8iny/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:la8iny/features/chat/presentation/blocs/chat_cubit.dart';
import 'package:la8iny/features/chat/presentation/blocs/chat_room/chat_room_cubit.dart';
import 'package:la8iny/core/services/remote_auth_service.dart';

import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/home/presentation/controllers/bloc/search_users_bloc.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  // Cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => ChatCubit(sl()));
  sl.registerFactory<ChatRoomCubit>(
    () => ChatRoomCubit(chatRepository: sl()),
  );
  sl.registerFactory(() => SearchUsersBloc(homeRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(
        authLocalDataSource: sl(),
        authRemoteDataSource: sl(),
        authRemoteDatabase: sl(),
      ));
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(chatRemoteDataSource: sl()),
  );

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
        homeRemoteDataSource: sl(),
      ));

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRemoteDatabase>(
      () => AuthRemoteDatabaseImpl(sl()));
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(remoteDatabase: sl()));
  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(remoteDatabase: sl()));

  // Services
  sl.registerLazySingleton<RemoteAuthService>(
      () => RemoteAuthServiceImpl(FirebaseAuth.instance));
  sl.registerLazySingleton<CacheService>(() => CacheServiceImpl());
  sl.registerLazySingleton<RemoteDatabaseService>(
      () => RemoteDatabaseServiceImpl(FirebaseFirestore.instance));
}
