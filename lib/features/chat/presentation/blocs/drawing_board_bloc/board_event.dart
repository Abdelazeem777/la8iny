part of 'drawing_board_bloc.dart';

@immutable
sealed class BoardEvent {
  const BoardEvent();
}

class InitDrawingBoardEvent extends BoardEvent {
  final String roomId;

  const InitDrawingBoardEvent(this.roomId);
}

class StartDrawingEvent extends BoardEvent {
  final DrawingPoint drawingPoint;
  const StartDrawingEvent(this.drawingPoint);
}

class UpdateDrawingEvent extends BoardEvent {
  final DrawingPoint drawingPoint;

  const UpdateDrawingEvent(this.drawingPoint);
}

class StopDrawingEvent extends BoardEvent {
  final DrawingPoint drawingPoint;
  const StopDrawingEvent(this.drawingPoint);
}

class ClearBoardEvent extends BoardEvent {
  const ClearBoardEvent();
}

class ChangeSelectedColorEvent extends BoardEvent {
  final Color color;
  const ChangeSelectedColorEvent(this.color);
}

class ReceiveDrawingPointEvent extends BoardEvent {
  final DrawingPoint drawingPoint;
  const ReceiveDrawingPointEvent(this.drawingPoint);
}
