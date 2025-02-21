import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> remove(String key);
}

class CacheServiceImpl implements CacheService {
  CacheServiceImpl() {
    SharedPreferences.getInstance().then((value) {
      _sharePreCompleter.complete(value);
    });
  }

  final _sharePreCompleter = Completer<SharedPreferences>();

  @override
  Future<String?> getString(String key) async {
    final sharedPreferences = await _sharePreCompleter.future;
    return Future.value(sharedPreferences.getString(key));
  }

  @override
  Future<void> setString(String key, String value) async {
    final sharedPreferences = await _sharePreCompleter.future;
    sharedPreferences.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    final sharedPreferences = await _sharePreCompleter.future;
    await sharedPreferences.remove(key);
  }
}
