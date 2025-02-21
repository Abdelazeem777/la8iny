import '../../../auth/data/models/user_model.dart';
import '../datasources/home_remote_data_source.dart';

abstract class HomeRepository {
  Future<List<User>> searchUsers(String query);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource homeRemoteDataSource,
  }) : _remoteDataSource = homeRemoteDataSource;

  @override
  Future<List<User>> searchUsers(String query) {
    return _remoteDataSource.searchUsers(query);
  }
}
