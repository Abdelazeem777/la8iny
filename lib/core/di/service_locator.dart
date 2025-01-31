import 'package:get_it/get_it.dart';
import 'package:la8iny/auth/data/repo/auth_repo_impl.dart';
import 'package:la8iny/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8iny/auth/presentation/repo/auth_repo.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  sl.registerFactory(() => AuthCubit(sl()));
}
