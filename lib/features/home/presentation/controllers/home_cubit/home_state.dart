part of 'home_cubit.dart';

enum HomeStateStatus {
  initial,
  loading,
  loaded,
  error,
}

extension HomeStateX on HomeState {
  bool get isInitial => status == HomeStateStatus.initial;
  bool get isLoading => status == HomeStateStatus.loading;
  bool get isLoaded => status == HomeStateStatus.loaded;
  bool get isError => status == HomeStateStatus.error;
}

@immutable

class HomeState {
  final HomeStateStatus status;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStateStatus.initial,
    this.errorMessage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other.runtimeType == runtimeType &&
        (other as HomeState).status == status &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>  status.hashCode ^ errorMessage.hashCode;

  HomeState copyWith({
    HomeStateStatus? status,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}