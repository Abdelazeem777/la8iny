part of 'drawing_board_bloc.dart';

@immutable
sealed class DrawingBoardEvent {
  const DrawingBoardEvent();
}

class DrawingBoardEventStart extends DrawingBoardEvent {
  final DrawingPoint drawingPoint;
  const DrawingBoardEventStart(this.drawingPoint);
}

class DrawingBoardEventUpdate extends DrawingBoardEvent {
  final DrawingPoint drawingPoint;
  const DrawingBoardEventUpdate(this.drawingPoint);
}

class DrawingBoardEventEnd extends DrawingBoardEvent {
  const DrawingBoardEventEnd();
}

class ClearBoardEvent extends DrawingBoardEvent {
  const ClearBoardEvent();
}

class ChangeSelectedColorEvent extends DrawingBoardEvent {
  final Color color;
  const ChangeSelectedColorEvent(this.color);
}
