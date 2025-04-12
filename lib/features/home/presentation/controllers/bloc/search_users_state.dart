part of 'search_users_bloc.dart';

enum SearchUsersStatus {
  initial,
  loading,
  loaded,
  error,
}

extension SearchUsersStatusX on SearchUsersState {
  bool get isInitial => status == SearchUsersStatus.initial;
  bool get isLoading => status == SearchUsersStatus.loading;
  bool get isLoaded => status == SearchUsersStatus.loaded;
  bool get isError => status == SearchUsersStatus.error;
}

@immutable
class SearchUsersState {
  final SearchUsersStatus status;
  final List<User>? users;
  final String? errorMessage;
  const SearchUsersState({
    this.status = SearchUsersStatus.initial,
    this.users,
    this.errorMessage,
  });

  SearchUsersState copyWith({
    SearchUsersStatus? status,
    List<User>? users,
    String? errorMessage,
    ChatRoom? chatRoom,
  }) {
    return SearchUsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchUsersState) return false;
    return status == other.status &&
        users == other.users &&
        errorMessage == other.errorMessage;
  }

  @override
  int get hashCode => status.hashCode ^ users.hashCode ^ errorMessage.hashCode;
}
