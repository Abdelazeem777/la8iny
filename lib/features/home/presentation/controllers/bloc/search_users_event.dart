part of 'search_users_bloc.dart';

@immutable
class SearchUsersEvent {
  final String query;

  const SearchUsersEvent({required this.query});
}
