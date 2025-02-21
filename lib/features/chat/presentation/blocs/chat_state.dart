part of 'chat_cubit.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState {
  final ChatStatus status;
  final List<ChatRoom> chatRooms;
  final bool hasMore;
  final String? error;

  const ChatState({
    this.status = ChatStatus.initial,
    this.chatRooms = const [],
    this.hasMore = true,
    this.error,
  });

  bool get isInitial => status == ChatStatus.initial;
  bool get isLoading => status == ChatStatus.loading;
  bool get isLoaded => status == ChatStatus.loaded;
  bool get isError => status == ChatStatus.error;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatRoom>? chatRooms,
    bool? hasMore,
    String? error,
  }) {
    return ChatState(
      status: status ?? this.status,
      chatRooms: chatRooms ?? this.chatRooms,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatState &&
        other.status == status &&
        other.chatRooms == chatRooms &&
        other.hasMore == hasMore &&
        other.error == error;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        chatRooms.hashCode ^
        hasMore.hashCode ^
        error.hashCode;
  }
}
