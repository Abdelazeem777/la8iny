import 'package:la8iny/features/auth/presentation/repo/auth_repo.dart';

import '../models/user_model.dart';

class AuthRepoImpl implements AuthRepo {
  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    return User(name: 'Abdelazeem Kuratem "قريطم"', email: email);
  }
}
