part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, loaded, error }

extension AuthStatusX on AuthState {
  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;
  bool get isLoaded => status == AuthStatus.loaded;
  bool get isError => status == AuthStatus.error;
}

@immutable
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? message;

  AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.message,
  });

  AuthState copyWith({
    AuthStatus? state,
    ValueGetter<User?>? user,
    String? message,
  }) {
    return AuthState(
      status: state ?? this.status,
      user: user != null ? user() : this.user,
      message: message ?? this.message,
    );
  }

  @override
  String toString() =>
      'AuthState(state: $status, user: $user, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.status == status &&
        other.user == user &&
        other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ user.hashCode ^ message.hashCode;
}
