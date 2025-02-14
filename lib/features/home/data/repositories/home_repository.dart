import '../datasources/home_remote_data_source.dart';

abstract class HomeRepository {}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource homeRemoteDataSource,
  }) : _remoteDataSource = homeRemoteDataSource;
}
