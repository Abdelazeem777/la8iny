import 'package:la8iny/features/auth/presentation/repo/auth_repo.dart';

import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_database.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDatabase _authRemoteDatabase;

  AuthRepoImpl({
    required AuthRemoteDataSource authRemoteDataSource,
    required AuthLocalDataSource authLocalDataSource,
    required AuthRemoteDatabase authRemoteDatabase,
  })  : _authRemoteDataSource = authRemoteDataSource,
        _authLocalDataSource = authLocalDataSource,
        _authRemoteDatabase = authRemoteDatabase;

  @override
  Future<User> login(String email, String password) async {
    final userCredential = await _authRemoteDataSource.login(email, password);

    final user = await _authRemoteDatabase.getUser(userCredential.id);

    _authRemoteDatabase.saveUser(userCredential);

    _authLocalDataSource.cacheUser(user);

    return user;
  }

  @override
  Future<User> signup(String fullname, String email, String password) async {
    final user = await _authRemoteDataSource.signup(fullname, email, password);
    await _authRemoteDatabase.saveUser(user);
    _authLocalDataSource.cacheUser(user);

    return user;
  }

  @override
  Future<User?> getUser() {
    return _authLocalDataSource.getCachedUser();
  }

  @override
  Future<void> logout() {
    return Future.wait([
      _authRemoteDataSource.logout(),
      _authLocalDataSource.removeCachedUser(),
    ]);
  }
}
