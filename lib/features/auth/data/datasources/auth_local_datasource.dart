import 'package:la8iny/features/auth/data/models/user_model.dart';

import '../../../../core/services/cache_service.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(User user);
  Future<User?> getCachedUser();
}

const String USER_CACHE_KEY = 'USER_CACHE_KEY';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final CacheService _cacheService;

  AuthLocalDataSourceImpl(this._cacheService);
  @override
  Future<void> cacheUser(User user) {
    return _cacheService.setString(USER_CACHE_KEY, user.toJson());
  }

  @override
  Future<User?> getCachedUser() async {
    final userJson = await _cacheService.getString(USER_CACHE_KEY);

    if (userJson == null) {
      return null;
    }

    return User.fromJson(userJson);
  }
}
