import '../../data/models/user_model.dart';

abstract class AuthRepo {
  Future<User> login(String email, String password);
  Future<User> signup(String fullname, String email, String password);

  Future<User?> getUser();

  Future<void> logout();
}
