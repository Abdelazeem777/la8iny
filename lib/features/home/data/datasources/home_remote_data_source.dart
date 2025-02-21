import 'package:la8iny/features/auth/data/models/user_model.dart';

import '../../../../core/services/remote_database_service.dart';

abstract class HomeRemoteDataSource {
  Future<List<User>> searchUsers(String query);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final RemoteDatabaseService _remoteDatabase;

  HomeRemoteDataSourceImpl({
    required RemoteDatabaseService remoteDatabase,
  }) : _remoteDatabase = remoteDatabase;

  @override
  Future<List<User>> searchUsers(String queryString) {
    return _remoteDatabase.getCollectionPaginated(
      'users',
      User.fromMap,
      queryBuilder: (query) => query.where('fullname', isEqualTo: queryString),
    );
  }
}
