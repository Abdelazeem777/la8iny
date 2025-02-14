import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
}

class CacheServiceImpl implements CacheService {
  CacheServiceImpl();

  @override
  Future<String?> getString(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return Future.value(sharedPreferences.getString(key));
  }

  @override
  Future<void> setString(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }
}
