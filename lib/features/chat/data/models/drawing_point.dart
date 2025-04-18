import 'package:flutter/material.dart';

class DrawingPoint {
  final Offset? position;
  final DateTime timestamp;
  final Paint? paint;
  final String userId;

  DrawingPoint({
    required this.position,
    required this.paint,
    required this.userId,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory DrawingPoint.fromMap(Map<String, dynamic> map) {
    return DrawingPoint(
      position: map['x'] == null && map['y'] == null
          ? null
          : Offset(map['x'], map['y']),
      paint: map['color'] == null
          ? null
          : (Paint()
            ..color = Color(map['color'])
            ..isAntiAlias = true
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round),
      userId: map['userId'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'x': position?.dx,
      'y': position?.dy,
      'color': paint?.color.value,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
    }..removeWhere((_, v) => v == null);
  }

  @override
  String toString() {
    return 'DrawingPoint(position: $position, paint: $paint, userId: $userId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrawingPoint &&
        other.position == position &&
        other.paint == paint &&
        other.userId == userId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode =>
      position.hashCode ^ paint.hashCode ^ userId.hashCode ^ timestamp.hashCode;
}
