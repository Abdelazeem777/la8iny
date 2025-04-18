part of 'drawing_board_bloc.dart';

enum DrawingBoardStateStatus {
  initial,
}

@immutable
class DrawingBoardState {
  final DrawingBoardStateStatus status;
  final List<DrawingPoint?> points;
  final Color selectedColor;

  const DrawingBoardState({
    this.status = DrawingBoardStateStatus.initial,
    this.points = const [],
    this.selectedColor = Colors.black,
  });

  DrawingBoardState copyWith({
    DrawingBoardStateStatus? status,
    List<DrawingPoint?>? points,
    Color? selectedColor,
  }) {
    return DrawingBoardState(
      status: status ?? this.status,
      points: points ?? this.points,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  @override
  String toString() =>
      'DrawingBoardState(status: $status, points: $points, selectedColor: $selectedColor)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DrawingBoardState &&
        other.status == status &&
        listEquals(other.points, points) &&
        other.selectedColor == selectedColor;
  }

  @override
  int get hashCode =>
      status.hashCode ^ Object.hashAll(points) ^ selectedColor.hashCode;
}
