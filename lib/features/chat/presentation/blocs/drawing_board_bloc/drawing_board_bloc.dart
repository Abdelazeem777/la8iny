import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/models/drawing_point.dart';
import '../../../data/repositories/drawing_board_repository.dart';

part 'board_event.dart';
part 'drawing_board_state.dart';

class DrawingBoardBloc extends Bloc<BoardEvent, DrawingBoardState> {
  final DrawingBoardRepository _drawingBoardRepository;

  DrawingBoardBloc(this._drawingBoardRepository)
      : super(const DrawingBoardState()) {
    on<InitDrawingBoardEvent>(_onInitDrawingBoardEvent);

    on<ReceiveDrawingPointEvent>(_onReceiveDrawingPointEvent);

    on<StartDrawingEvent>(_onDrawingBoardEventStart);

    on<UpdateDrawingEvent>(
      _onDrawingBoardEventUpdate,
      transformer: (events, mapper) => events.where(
        (event) {
          // Skip events where points are too close
          final lastPoint = state.points.isNotEmpty && state.points.last != null
              ? state.points.last
              : null;

          if (lastPoint == null) return true;

          // Calculate distance between points
          double distance = _calculateDistance(
            lastPoint.position,
            event.drawingPoint.position,
          );

          // Only process events where distance is 5 or more
          final isDistanceValid = distance >= 5;
          final isTimeValid = event.drawingPoint.timestamp
                  .difference(lastPoint.timestamp)
                  .inMilliseconds <
              10;

          return isDistanceValid || isTimeValid;
        },
      ).switchMap(mapper),
    );
    on<ClearBoardEvent>(_onClearBoardEvent);
    on<ChangeSelectedColorEvent>(_onChangeSelectedColorEvent);
  }

  // Calculate Euclidean distance between two points
  double _calculateDistance(Offset? p1, Offset? p2) {
    if (p1 == null || p2 == null) return 0;
    return (p1 - p2).distance;
  }

  Future<void> _onInitDrawingBoardEvent(
      InitDrawingBoardEvent event, Emitter<DrawingBoardState> emit) async {
    emit(state.copyWith(
      status: DrawingBoardStateStatus.loading,
      roomId: event.roomId,
    ));

    try {
      final initPoints =
          await _drawingBoardRepository.initDrawingBoard(event.roomId);

      _startListeningDrawingFromOtherUsers();

      emit(state.copyWith(
        status: DrawingBoardStateStatus.loaded,
        points: initPoints,
        roomId: event.roomId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DrawingBoardStateStatus.error,
        error: e.toString(),
      ));
    }
  }

  void _startListeningDrawingFromOtherUsers() {
    _drawingBoardRepository
        .listenDrawingFromOtherUsers(state.roomId!)
        .listen((point) => add(ReceiveDrawingPointEvent(point)));
  }

  void _onReceiveDrawingPointEvent(
      ReceiveDrawingPointEvent event, Emitter<DrawingBoardState> emit) {
    emit(state.copyWith(points: [...state.points, event.drawingPoint]));
  }

  void _onDrawingBoardEventStart(
      StartDrawingEvent event, Emitter<DrawingBoardState> emit) {
    final newPoint = event.drawingPoint;
    _drawingBoardRepository.sendDrawingPoint(state.roomId!, newPoint);
    emit(state.copyWith(points: [...state.points, newPoint]));
  }

  void _onDrawingBoardEventUpdate(
      UpdateDrawingEvent event, Emitter<DrawingBoardState> emit) {
    final newPoint = event.drawingPoint;
    _drawingBoardRepository.sendDrawingPoint(state.roomId!, newPoint);
    emit(state.copyWith(points: [...state.points, newPoint]));
  }

  void _onClearBoardEvent(
      ClearBoardEvent event, Emitter<DrawingBoardState> emit) {
    _drawingBoardRepository.clearDrawingBoard(state.roomId!);
    emit(state.copyWith(points: const []));
  }

  void _onChangeSelectedColorEvent(
      ChangeSelectedColorEvent event, Emitter<DrawingBoardState> emit) {
    emit(state.copyWith(selectedColor: event.color));
  }
}

/** Using mix between time and distance using where
 * on<DrawingBoardEventUpdate>(
      _onDrawingBoardEventUpdate,
      transformer: (events, mapper) => events.where(
        (event) {
          // Skip events where points are too close
          DrawingPoint? lastPoint =
              state.points.isNotEmpty && state.points.last != null
                  ? state.points.last
                  : null;

          if (lastPoint == null) return true;

          // Calculate distance between points
          double distance = _calculateDistance(
              lastPoint.position, event.drawingPoint.position);

          // Only process events where distance is 5 or more
          final isDistanceValid = distance >= 5;
          final isTimeValid = event.drawingPoint.timestamp
                  .difference(lastPoint.timestamp)
                  .inMilliseconds <
              10;

          return isDistanceValid || isTimeValid;
        },
      ).switchMap(mapper),
    );
 */



/**
 * 
 *  on<DrawingBoardEventUpdate>(
      _onDrawingBoardEventUpdate,
      transformer: (events, mapper) =>
          ThrottleStreamTransformer<DrawingBoardEventUpdate>(
        (_) => DistanceStream<bool>(
          true,
          distance: 5,
        ),
      ).bind(events),
    );
 */
//TODO: Implement this later!
// class DistanceStream<T> extends Stream<T> {
//   final StreamController<T> _controller;

//   /// Constructs a [Stream] which emits [value] after the specified [Duration].
//   DistanceStream(T value, {required double distance})
//       : _controller = _buildController(value, distance);

//   @override
//   StreamSubscription<T> listen(void Function(T event)? onData,
//       {Function? onError, void Function()? onDone, bool? cancelOnError}) {
//     return _controller.stream.listen(
//       onData,
//       onError: onError,
//       onDone: onDone,
//       cancelOnError: cancelOnError,
//     );
//   }

//   static StreamController<T> _buildController<T>(T value, Duration duration) {
//     final watch = Stopwatch();
//     Timer? timer;
//     late StreamController<T> controller;
//     Duration? totalElapsed = Duration.zero;

//     void onResume() {
//       // Already cancelled or is not paused.
//       if (totalElapsed == null || timer != null) return;

//       totalElapsed = totalElapsed! + watch.elapsed;
//       watch.start();

//       timer = Timer(duration - totalElapsed!, () {
//         controller.add(value);
//         controller.close();
//       });
//     }

//     controller = StreamController(
//       sync: true,
//       onListen: () {
//         watch.start();
//         timer = Timer(duration, () {
//           controller.add(value);
//           controller.close();
//         });
//       },
//       onPause: () {
//         timer?.cancel();
//         timer = null;
//         watch.stop();
//       },
//       onResume: onResume,
//       onCancel: () {
//         timer?.cancel();
//         timer = null;
//         totalElapsed = null;
//       },
//     );
//     return controller;
//   }
// }
