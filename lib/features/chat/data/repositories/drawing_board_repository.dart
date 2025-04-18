import '../datasources/drawing_board_remote_datasource.dart';
import '../models/drawing_point.dart';

abstract class DrawingBoardRepository {
  Future<List<DrawingPoint>> initDrawingBoard(String roomId);

  Future<void> sendDrawingPoint(String roomId, DrawingPoint point);
  Stream<DrawingPoint> listenDrawingFromOtherUsers(String roomId);
  Future<void> clearDrawingBoard(String roomId);
}

class DrawingBoardRepositoryImpl extends DrawingBoardRepository {
  final DrawingBoardRemoteDataSource _drawingBoardRemoteDataSource;

  DrawingBoardRepositoryImpl({
    required DrawingBoardRemoteDataSource drawingBoardRemoteDataSource,
  }) : _drawingBoardRemoteDataSource = drawingBoardRemoteDataSource;

  @override
  Future<List<DrawingPoint>> initDrawingBoard(String roomId) =>
      _drawingBoardRemoteDataSource.initDrawingBoard(roomId);

  @override
  Future<void> sendDrawingPoint(String roomId, DrawingPoint point) =>
      _drawingBoardRemoteDataSource.sendDrawingPoint(roomId, point);

  @override
  Stream<DrawingPoint> listenDrawingFromOtherUsers(String roomId) =>
      _drawingBoardRemoteDataSource.listenDrawingFromOtherUsers(roomId);

  @override
  Future<void> clearDrawingBoard(String roomId) =>
      _drawingBoardRemoteDataSource.clearDrawingBoard(roomId);
}
