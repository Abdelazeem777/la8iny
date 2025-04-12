part of 'chat_room_cubit.dart';

enum ChatRoomStatus { initial, loading, loadingMore, loaded, error }

enum MessageStatus { loading, sent, failed }

extension MessageStatusX on MessageStatus {
  bool get isLoading => this == MessageStatus.loading;
  bool get isSent => this == MessageStatus.sent;
  bool get isFailed => this == MessageStatus.failed;
}

extension ChatRoomStatusX on ChatRoomState {
  bool get isInitial => status == ChatRoomStatus.initial;
  bool get isLoading => status == ChatRoomStatus.loading;
  bool get isLoadingMore => status == ChatRoomStatus.loadingMore;
  bool get isLoaded => status == ChatRoomStatus.loaded;
  bool get isError => status == ChatRoomStatus.error;
}

class ChatRoomState {
  final ChatRoomStatus status;
  final MessageStatus? messageStatus;
  final String? roomId;
  final List<ChatMessage> messages;
  final bool hasMore;
  final String? error;

  const ChatRoomState({
    this.status = ChatRoomStatus.initial,
    this.messageStatus,
    this.roomId,
    this.messages = const [],
    this.hasMore = true,
    this.error,
  });

  ChatRoomState copyWith({
    ChatRoomStatus? status,
    List<ChatMessage>? messages,
    bool? hasMore,
    MessageStatus? messageStatus,
    String? error,
    String? roomId,
  }) {
    return ChatRoomState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      messageStatus: messageStatus ?? this.messageStatus,
      error: error ?? this.error,
      roomId: roomId ?? this.roomId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatRoomState &&
        other.status == status &&
        other.messages == messages &&
        other.hasMore == hasMore &&
        other.messageStatus == messageStatus &&
        other.error == error &&
        other.roomId == roomId;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        messages.hashCode ^
        hasMore.hashCode ^
        messageStatus.hashCode ^
        error.hashCode ^
        roomId.hashCode;
  }
}
