import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../features/auth/data/models/user_model.dart';

abstract class RemoteAuthService {
  Future<User> login(String email, String password);
  Future<User> signup(String fullname, String email, String password);

  Future<void> logout();
}

class RemoteAuthServiceImpl implements RemoteAuthService {
  final firebase_auth.FirebaseAuth firebaseAuth;

  RemoteAuthServiceImpl(this.firebaseAuth);

  @override
  Future<User> login(String email, String password) async {
    final firebaseUser = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (firebaseUser.user == null) throw Exception('Invalid credentials');

    final userAdapter = FirebaseAuthUserAdapter();

    return userAdapter.adapt(firebaseUser.user!);
  }

  @override
  Future<User> signup(String fullname, String email, String password) async {
    var firebaseUser = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await firebaseUser.user!.updateDisplayName(fullname);
    await firebaseUser.user!.reload();

    if (firebaseUser.user == null) throw Exception('Invalid credentials');

    final userAdapter = FirebaseAuthUserAdapter();

    return userAdapter.adapt(firebaseAuth.currentUser!);
  }

  @override
  Future<void> logout() {
    return firebaseAuth.signOut();
  }
}

class FirebaseAuthUserAdapter {
  User adapt(firebase_auth.User user) {
    return User(
      id: user.uid,
      email: user.email ?? '',
      fullname: user.displayName ?? '',
    );
  }
}
