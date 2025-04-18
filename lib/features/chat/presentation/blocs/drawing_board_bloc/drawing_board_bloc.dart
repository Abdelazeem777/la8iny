import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../pages/real_time_drawing_page.dart';

part 'drawing_board_event.dart';
part 'drawing_board_state.dart';

class DrawingBoardBloc extends Bloc<DrawingBoardEvent, DrawingBoardState> {
  DrawingBoardBloc() : super(const DrawingBoardState()) {
    on<DrawingBoardEventStart>(_onDrawingBoardEventStart);
    on<DrawingBoardEventUpdate>(_onDrawingBoardEventUpdate);
    on<DrawingBoardEventEnd>(_onDrawingBoardEventEnd);
    on<ClearBoardEvent>(_onClearBoardEvent);
    on<ChangeSelectedColorEvent>(_onChangeSelectedColorEvent);
  }

  void _onDrawingBoardEventStart(
      DrawingBoardEventStart event, Emitter<DrawingBoardState> emit) {
    final newPoint = event.drawingPoint;
    emit(state.copyWith(points: [...state.points, newPoint]));
  }

  void _onDrawingBoardEventUpdate(
      DrawingBoardEventUpdate event, Emitter<DrawingBoardState> emit) {
    final newPoint = event.drawingPoint;
    emit(state.copyWith(points: [...state.points, newPoint]));
  }

  void _onDrawingBoardEventEnd(
      DrawingBoardEventEnd event, Emitter<DrawingBoardState> emit) {
    emit(state.copyWith(points: [...state.points, null]));
  }

  void _onClearBoardEvent(
      ClearBoardEvent event, Emitter<DrawingBoardState> emit) {
    emit(state.copyWith(points: const []));
  }

  void _onChangeSelectedColorEvent(
      ChangeSelectedColorEvent event, Emitter<DrawingBoardState> emit) {
    emit(state.copyWith(selectedColor: event.color));
  }
}
