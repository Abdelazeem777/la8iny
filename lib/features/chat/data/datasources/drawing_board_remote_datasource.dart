import '../../../../core/services/remote_database_service.dart';
import '../models/drawing_point.dart';

abstract class DrawingBoardRemoteDataSource {
  Future<List<DrawingPoint>> initDrawingBoard(String roomId);
  Future<void> sendDrawingPoint(String roomId, DrawingPoint point);
  Stream<DrawingPoint> listenDrawingFromOtherUsers(
    String roomId,
    String exceptUserId,
  );
  Future<void> clearDrawingBoard(String roomId);
}

class DrawingBoardRemoteDataSourceImpl extends DrawingBoardRemoteDataSource {
  final RemoteDatabaseService _remoteDatabase;

  DrawingBoardRemoteDataSourceImpl({
    required RemoteDatabaseService remoteDatabase,
  }) : _remoteDatabase = remoteDatabase;

  @override
  Future<List<DrawingPoint>> initDrawingBoard(String roomId) {
    return _remoteDatabase.getCollectionPaginated(
      "chatRooms/$roomId/drawingPoints",
      DrawingPoint.fromMap,
    );
  }

  @override
  Stream<DrawingPoint> listenDrawingFromOtherUsers(
    String roomId,
    String exceptUserId,
  ) {
    return _remoteDatabase.watchCollectionSingle(
      "chatRooms/$roomId/drawingPoints",
      DrawingPoint.fromMap,
      queryBuilder: (query) => query
          .where('userId', isNotEqualTo: exceptUserId)
          .orderBy('timestamp', descending: true),
    );
  }

  @override
  Future<void> sendDrawingPoint(String roomId, DrawingPoint point) {
    final id = point.timestamp.toIso8601String() + point.userId;
    return _remoteDatabase.set(
      "chatRooms/$roomId/drawingPoints/$id",
      point,
      (point) => point.toMap(),
    );
  }

  @override
  Future<void> clearDrawingBoard(String roomId) {
    return _remoteDatabase.update(
      "chatRooms/$roomId/drawingPoints",
      {},
    );
  }
}
