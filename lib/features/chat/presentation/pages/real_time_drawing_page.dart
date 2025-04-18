import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

import '../../../../core/di/service_locator.dart';
import '../../data/models/drawing_point.dart';
import '../blocs/drawing_board_bloc/drawing_board_bloc.dart';

class RealTimeDrawingPage extends StatefulWidget {
  const RealTimeDrawingPage({
    super.key,
    required this.roomId,
    required this.userId,
  });
  final String roomId;
  final String userId;

  @override
  State<RealTimeDrawingPage> createState() => _RealTimeDrawingPageState();
}

class _RealTimeDrawingPageState extends State<RealTimeDrawingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<DrawingBoardBloc>()..add(InitDrawingBoardEvent(widget.roomId)),
      child: Builder(builder: (context) {
        final bloc = context.read<DrawingBoardBloc>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Drawing Board'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => bloc.add(const ClearBoardEvent()),
              ),
            ],
          ),
          body: _buildBody(bloc),
        );
      }),
    );
  }

  Widget _buildBody(DrawingBoardBloc bloc) {
    return Stack(
      children: [
        BlocSelector<DrawingBoardBloc, DrawingBoardState, Color>(
          selector: (state) => state.selectedColor,
          builder: (context, color) {
            return GestureDetector(
              onPanStart: (details) {
                bloc.add(StartDrawingEvent(
                  DrawingPoint(
                    position: details.localPosition,
                    paint: Paint()
                      ..color = color
                      ..isAntiAlias = true
                      ..strokeWidth = 5.0
                      ..strokeCap = StrokeCap.round,
                    userId: widget.userId,
                  ),
                ));
              },
              onPanUpdate: (details) {
                bloc.add(UpdateDrawingEvent(
                  DrawingPoint(
                    position: details.localPosition,
                    paint: Paint()
                      ..color = color
                      ..isAntiAlias = true
                      ..strokeWidth = 5.0
                      ..strokeCap = StrokeCap.round,
                    userId: widget.userId,
                  ),
                ));
              },
              onPanEnd: (details) {
                bloc.add(UpdateDrawingEvent(
                  DrawingPoint(
                    position: null,
                    paint: null,
                    userId: widget.userId,
                  ),
                ));
              },
              child: BlocSelector<DrawingBoardBloc, DrawingBoardState,
                  List<DrawingPoint?>>(
                selector: (state) => state.points,
                builder: (context, points) {
                  return CustomPaint(
                    painter: _DrawingPainter(points),
                    size: Size.infinite,
                  );
                },
              ),
            );
          },
        ),
        _buildColorPalette(bloc),
      ],
    );
  }

  Widget _buildColorPalette(DrawingBoardBloc bloc) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: SafeArea(
          child: BlocSelector<DrawingBoardBloc, DrawingBoardState, Color>(
            selector: (state) => state.selectedColor,
            builder: (context, selectedColor) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Colors.black,
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                ]
                    .map(
                      (color) => _ColorChoice(
                        color: color,
                        isSelected: color == selectedColor,
                        onSelect: (color) =>
                            bloc.add(ChangeSelectedColorEvent(color)),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final ValueChanged<Color> onSelect;

  const _ColorChoice({
    required this.color,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(color),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;

  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    print("drawing...");
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i]?.position != null && points[i + 1]?.position != null) {
        canvas.drawLine(
          points[i]!.position!,
          points[i + 1]!.position!,
          points[i]!.paint!,
        );
      } else if (points[i]?.position != null &&
          points[i + 1]?.position == null) {
        canvas.drawPoints(
          ui.PointMode.points,
          [points[i]!.position!],
          points[i]!.paint!,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
