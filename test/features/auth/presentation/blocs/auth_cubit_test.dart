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
  // Fixed datetime for testing
  final DateTime _fixedDateTime = DateTime(2025, 4, 11, 18, 54, 30);

  final _users = [
    User(
      id: "test-user-id",
      fullname: "Abdelazeem Kuratem",
      email: "test@gmail.com",
      lastSeen: DateTime(2025, 4, 11, 18, 54, 30),
    ),
  ];

  User? _currentUser;

  @override
  Future<User> login(String email, String password) {
    final user = _users.firstWhereOrNull(
      (user) => user.email == email,
    );
    if (user?.email == email) {
      _currentUser = user;
      return Future.value(user);
    } else {
      throw Exception("User password is incorrect");
    }
  }

  @override
  Future<User> signup(String fullname, String email, String password) {
    final user = User(
      id: "user-${_users.length + 1}",
      fullname: fullname,
      email: email,
      lastSeen: _fixedDateTime,
    );
    if (_users.any((u) => u.email == email)) {
      throw Exception("This email is already in use");
    } else {
      _users.add(user);
      _currentUser = user;
      return Future.value(user);
    }
  }

  @override
  Future<User?> getUser() async {
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}

void main() {
  late AuthRepo _authRepository;
  late AuthCubit _authCubit;
  // Fixed datetime for testing
  final DateTime fixedDateTime = DateTime(2025, 4, 11, 18, 54, 30);

  setUpAll(() {
    registerFallbackValue('test@gmail.com');
    registerFallbackValue('123456');
    registerFallbackValue('Abdelazeem Kuratem');
  });

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
        'emits [AuthStatus.loading, AuthStatus.loggedIn] when login is successful',
        build: () => _authCubit,
        act: (cubit) => cubit.login("test@gmail.com", "123456"),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.loggedIn,
            user: User(
              id: "test-user-id",
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
              lastSeen: fixedDateTime,
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
        'emits [AuthStatus.loading, AuthStatus.loggedIn] when signup is successful',
        build: () => _authCubit,
        act: (cubit) => cubit.signup(
          fullname: "Abdelazeem Kuratem",
          email: "abdelazeem263@gmail.com",
          password: "123456",
        ),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.loggedIn,
            user: User(
              id: "user-2",
              fullname: "Abdelazeem Kuratem",
              email: "abdelazeem263@gmail.com",
              lastSeen: fixedDateTime,
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
          password: "123456",
        ),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.error,
            message: "Exception: This email is already in use",
          ),
        ],
      );

      blocTest(
        'emits [AuthStatus.loading, AuthStatus.loggedIn] when signup is successful and login is successful',
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
              status: AuthStatus.loggedIn,
              user: () => User(
                id: "user-2",
                fullname: "Abdelazeem Kuratem2",
                email: "test2@gmail.com",
                lastSeen: fixedDateTime,
              ),
            ),
            authState.copyWith(
              status: AuthStatus.loading,
              user: () => User(
                id: "user-2",
                fullname: "Abdelazeem Kuratem2",
                email: "test2@gmail.com",
                lastSeen: fixedDateTime,
              ),
            ),
            authState.copyWith(
              status: AuthStatus.loggedIn,
              user: () => User(
                id: "user-2",
                fullname: "Abdelazeem Kuratem2",
                email: "test2@gmail.com",
                lastSeen: fixedDateTime,
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
        'emits [AuthStatus.loading, AuthStatus.loggedIn] when login is successful',
        setUp: () {
          when(() => _authRepository.login(any(), any())).thenAnswer(
            (_) async => User(
              id: "test-user-id",
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
              lastSeen: fixedDateTime,
            ),
          );
        },
        build: () => _authCubit,
        act: (cubit) => cubit.login("test@gmail.com", "123456"),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.loggedIn,
            user: User(
              id: "test-user-id",
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
              lastSeen: fixedDateTime,
            ),
          ),
        ],
      );

      blocTest(
        'emits [AuthStatus.loading, AuthStatus.error] when login is failed',
        setUp: () {
          when(() => _authRepository.login(any(), any())).thenThrow(
            Exception("User password is incorrect"),
          );
        },
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
        'emits [AuthStatus.loading, AuthStatus.loggedIn] when signup is successful',
        setUp: () {
          when(() => _authRepository.signup(any(), any(), any())).thenAnswer(
            (_) async => User(
              id: "test-user-id",
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
              lastSeen: fixedDateTime,
            ),
          );
        },
        build: () => _authCubit,
        act: (cubit) => cubit.signup(
          fullname: "Abdelazeem Kuratem",
          email: "abdelazeem263@gmail.com",
          password: "123456",
        ),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.loggedIn,
            user: User(
              id: "test-user-id",
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
              lastSeen: fixedDateTime,
            ),
          ),
        ],
      );

      blocTest(
        'emits [AuthStatus.loading, AuthStatus.error] when signup is failed',
        setUp: () {
          when(() => _authRepository.signup(any(), any(), any())).thenThrow(
            Exception("This email is already in use"),
          );
        },
        build: () => _authCubit,
        act: (cubit) => cubit.signup(
          fullname: "Abdelazeem Kuratem",
          email: "test@gmail.com",
          password: "123456",
        ),
        expect: () => [
          AuthState(status: AuthStatus.loading),
          AuthState(
            status: AuthStatus.error,
            message: "Exception: This email is already in use",
          ),
        ],
      );
    });

    group("getUser", () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthStatus.loggedIn] when user exists',
        setUp: () {
          when(() => _authRepository.getUser()).thenAnswer(
            (_) async => User(
              id: "test-user-id",
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
              lastSeen: fixedDateTime,
            ),
          );
        },
        build: () => _authCubit,
        act: (cubit) => cubit.init(),
        expect: () => [
          AuthState(
            status: AuthStatus.loggedIn,
            user: User(
              id: "test-user-id",
              fullname: "Abdelazeem Kuratem",
              email: "test@gmail.com",
              lastSeen: fixedDateTime,
            ),
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthStatus.loggedOut] when user does not exist',
        setUp: () {
          when(() => _authRepository.getUser()).thenAnswer(
            (_) async => null,
          );
        },
        build: () => _authCubit,
        act: (cubit) => cubit.init(),
        expect: () => [
          AuthState(status: AuthStatus.loggedOut),
        ],
      );
    });

    group("logout", () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthStatus.loggedOut] when logout is successful',
        setUp: () {
          when(() => _authRepository.logout()).thenAnswer(
            (_) async => {},
          );
        },
        build: () => _authCubit,
        act: (cubit) => cubit.logout(),
        expect: () => [
          AuthState(status: AuthStatus.loggedOut),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthStatus.error] when logout fails',
        setUp: () {
          when(() => _authRepository.logout()).thenThrow(
            Exception("Failed to logout"),
          );
        },
        build: () => _authCubit,
        act: (cubit) => cubit.logout(),
        expect: () => [
          AuthState(
            status: AuthStatus.error,
            message: "Exception: Failed to logout",
          ),
        ],
      );
    });
  });
}
