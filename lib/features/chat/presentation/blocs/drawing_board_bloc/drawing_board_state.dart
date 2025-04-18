part of 'drawing_board_bloc.dart';

enum DrawingBoardStateStatus {
  initial,
  loading,
  loaded,
  error,
}

@immutable
class DrawingBoardState {
  final DrawingBoardStateStatus status;
  final List<DrawingPoint?> points;
  final Color selectedColor;
  final String? error;
  final String? roomId;

  const DrawingBoardState({
    this.status = DrawingBoardStateStatus.initial,
    this.points = const [],
    this.selectedColor = Colors.black,
    this.error,
    this.roomId,
  });

  DrawingBoardState copyWith({
    DrawingBoardStateStatus? status,
    List<DrawingPoint?>? points,
    Color? selectedColor,
    String? error,
    String? roomId,
  }) {
    return DrawingBoardState(
      status: status ?? this.status,
      points: points ?? this.points,
      selectedColor: selectedColor ?? this.selectedColor,
      error: error ?? this.error,
      roomId: roomId ?? this.roomId,
    );
  }

  @override
  String toString() =>
      'DrawingBoardState(status: $status, points: $points, selectedColor: $selectedColor, error: $error, roomId: $roomId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DrawingBoardState &&
        other.status == status &&
        listEquals(other.points, points) &&
        other.selectedColor == selectedColor &&
        other.error == error &&
        other.roomId == roomId;
  }

  @override
  int get hashCode =>
      status.hashCode ^
      Object.hashAll(points) ^
      selectedColor.hashCode ^
      error.hashCode ^
      roomId.hashCode;
}
