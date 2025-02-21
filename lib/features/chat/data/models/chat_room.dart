import 'dart:convert';

import 'package:la8iny/features/auth/data/models/user_model.dart';
import 'package:la8iny/features/chat/data/models/chat_message.dart';

class ChatRoom {
  final String id;
  final List<String> participantIds;
  final Map<String, User> participants;
  final ChatMessage? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatRoom({
    required this.id,
    required this.participantIds,
    required this.participants,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  ChatRoom copyWith({
    String? id,
    List<String>? participantIds,
    Map<String, User>? participants,
    ChatMessage? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantIds': participantIds,
      'participants':
          participants.map((key, value) => MapEntry(key, value.toMap())),
      'lastMessage': lastMessage?.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] ?? '',
      participantIds: List<String>.from(map['participantIds']),
      participants: (map['participants'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, User.fromMap(value)),
      ),
      lastMessage: map['lastMessage'] != null
          ? ChatMessage.fromMap(map['lastMessage'])
          : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatRoom(id: $id, participantIds: $participantIds, participants: $participants, lastMessage: $lastMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatRoom &&
        other.id == id &&
        other.participantIds == participantIds &&
        other.participants == participants &&
        other.lastMessage == lastMessage &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        participantIds.hashCode ^
        participants.hashCode ^
        lastMessage.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
