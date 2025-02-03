import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:la8iny/features/auth/data/models/user_model.dart';
import 'package:la8iny/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8iny/features/auth/presentation/repo/auth_repo.dart';
import 'package:collection/collection.dart';

import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepo {}

class FakeAuthRepository implements AuthRepo {
  final _users = [
    User(
      fullname: "Abdelazeem Kuratem",
      email: "test@gmail.com",
    ),
  ];
  @override
  Future<User> login(String email, String password) {
    final user = _users.firstWhereOrNull(
      (user) => user.email == email,
    );
    if (user?.email == email) {
      return Future.value(user);
    } else {
      throw Exception("User password is incorrect");
    }
  }

  @override
  Future<User> signup(String fullname, String email, String password) {
    final user = User(fullname: fullname, email: email);
    if (_users.contains(user)) {
      throw Exception("This email is already in use");
    } else {
      _users.add(user);
      return Future.value(user);
    }
  }
}

void main() {
  late AuthRepo _authRepository;
  late AuthCubit _authCubit;
  group("Using Fake", () {
    setUp(() {
      _authRepository = FakeAuthRepository();
      _authCubit = AuthCubit(_authRepository);
    });

    tearDown(() {
      _authCubit.close();
    });

    group("login", () {
      blocTest(
        'emits [AuthStatus.loading, AuthStatus.loaded] when login is successful',
        build: () => _authCubit,
        act: (cubit) => cubit.login("test@gmail.com", "123456"),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.loaded,
            user: User(
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
            ),
          ),
        ],
      );

      blocTest(
        'emits [AuthStatus.loading, AuthStatus.error] when login is failed',
        build: () => _authCubit,
        act: (cubit) => cubit.login("test123@gmail.com", "123456"),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.error,
            message: "Exception: User password is incorrect",
          ),
        ],
      );
    });

    group("signup", () {
      blocTest(
        'emits [AuthStatus.loading, AuthStatus.loaded] when signup is successful',
        build: () => _authCubit,
        act: (cubit) => cubit.signup(
          fullname: "Abdelazeem Kuratem",
          email: "abdelazeem263@gmail.com",
          password: "123456",
        ),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.loaded,
            user: User(
              fullname: "Abdelazeem Kuratem",
              email: "abdelazeem263@gmail.com",
            ),
          ),
        ],
      );

      blocTest(
        'emits [AuthStatus.loading, AuthStatus.error] when signup is failed',
        build: () => _authCubit,
        act: (cubit) => cubit.signup(
            fullname: "Abdelazeem Kuratem",
            email: "test@gmail.com",
            password: "123456"),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.error,
            message: "Exception: This email is already in use",
          ),
        ],
      );

      blocTest(
        'emits [AuthStatus.loading, AuthStatus.loaded,AuthStatus.loading, AuthStatus.loaded] when signup is successful and login is successful',
        build: () => _authCubit,
        act: (cubit) async {
          await cubit.signup(
              fullname: "Abdelazeem Kuratem2",
              email: "test2@gmail.com",
              password: "123456");

          await cubit.login("test2@gmail.com", "123456");
        },
        expect: () {
          var authState = AuthState(status: AuthStatus.loading);
          return [
            authState,
            authState.copyWith(
              status: AuthStatus.loaded,
              user: () => User(
                fullname: "Abdelazeem Kuratem2",
                email: "test2@gmail.com",
              ),
            ),
            authState.copyWith(
              status: AuthStatus.loading,
              user: () => User(
                fullname: "Abdelazeem Kuratem2",
                email: "test2@gmail.com",
              ),
            ),
            authState.copyWith(
              status: AuthStatus.loaded,
              user: () => User(
                fullname: "Abdelazeem Kuratem2",
                email: "test2@gmail.com",
              ),
            ),
          ];
        },
      );
    });
  });

  group("Using Mock", () {
    setUp(() {
      _authRepository = MockAuthRepository();
      _authCubit = AuthCubit(_authRepository);
    });

    tearDown(() {
      _authCubit.close();
    });

    group("login", () {
      blocTest(
        'emits [AuthStatus.loading, AuthStatus.loaded] when login is successful',
        setUp: () => when(() => _authRepository.login(any(), any()))
            .thenAnswer((_) async => User(
                  fullname: "Abdelazeem Kuratem",
                  email: "test@gmail.com",
                )),
        build: () => _authCubit,
        act: (cubit) => cubit.login("test@gmail.com", "123456"),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.loaded,
            user: User(
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
            ),
          ),
        ],
      );

      blocTest(
        'emits [AuthStatus.loading, AuthStatus.error] when login is failed',
        setUp: () =>
            when(() => _authRepository.login("test@gmail.com", "123456"))
                .thenAnswer(
                    (_) async => throw Exception("User password is incorrect")),
        build: () => _authCubit,
        act: (cubit) => cubit.login("test@gmail.com", "123456"),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.error,
            message: "Exception: User password is incorrect",
          ),
        ],
      );
    });

    group("signup", () {
      blocTest(
        'emits [AuthStatus.loading, AuthStatus.loaded] when signup is successful',
        setUp: () => when(() => _authRepository.signup(any(), any(), any()))
            .thenAnswer((_) async => User(
                  fullname: "Abdelazeem Kuratem",
                  email: "test@gmail.com",
                )),
        build: () => _authCubit,
        act: (cubit) => cubit.signup(
          fullname: "Abdelazeem Kuratem",
          email: "abdelazeem263@gmail.com",
          password: "123456",
        ),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.loaded,
            user: User(
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
            ),
          ),
        ],
      );

      blocTest(
        'emits [AuthStatus.loading, AuthStatus.error] when signup is failed',
        setUp: () =>
            when(() => _authRepository.login("test@gmail.com", "123456"))
                .thenAnswer((_) async =>
                    throw Exception("This email is already in use")),
        build: () => _authCubit,
        act: (cubit) => cubit.login("test@gmail.com", "123456"),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.error,
            message: "Exception: This email is already in use",
          ),
        ],
      );
    });
  });
}
