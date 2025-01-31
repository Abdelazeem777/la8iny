part of 'splash_cubit.dart';

enum SplashStateStatus {
  initial,
  loading,
  loaded,
  error,
}

extension SplashStateX on SplashState {
  bool get isInitial => status == SplashStateStatus.initial;
  bool get isLoading => status == SplashStateStatus.loading;
  bool get isLoaded => status == SplashStateStatus.loaded;
  bool get isError => status == SplashStateStatus.error;
}

@immutable
class SplashState {
  final SplashStateStatus status;
  final String? errorMessage;

  const SplashState({
    this.status = SplashStateStatus.initial,
    this.errorMessage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other.runtimeType == runtimeType &&
        (other as SplashState).status == status &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => status.hashCode ^ errorMessage.hashCode;

  SplashState copyWith({
    SplashStateStatus? status,
    String? errorMessage,
  }) {
    return SplashState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
