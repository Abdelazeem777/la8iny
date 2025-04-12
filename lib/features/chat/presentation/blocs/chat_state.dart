part of 'chat_cubit.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState {
  final ChatStatus status;
  final List<ChatRoom> chatRooms;
  final Map<String, List<ChatMessage>> messages;
  final Map<String, bool> roomsHasMore;
  final Map<String, bool> isLoadingMoreMessages;
  final bool hasMore;
  final String? error;
  final bool isSendingMessage;
  final ChatRoom? chatRoom;

  const ChatState({
    this.status = ChatStatus.initial,
    this.chatRooms = const [],
    this.messages = const {},
    this.roomsHasMore = const {},
    this.isLoadingMoreMessages = const {},
    this.hasMore = true,
    this.error,
    this.isSendingMessage = false,
    this.chatRoom,
  });

  bool get isInitial => status == ChatStatus.initial;
  bool get isLoading => status == ChatStatus.loading;
  bool get isLoaded => status == ChatStatus.loaded;
  bool get isError => status == ChatStatus.error;

  List<ChatMessage> getMessagesForRoom(String roomId) => messages[roomId] ?? [];

  bool hasMoreMessagesForRoom(String roomId) => roomsHasMore[roomId] ?? true;

  bool isLoadingMoreForRoom(String roomId) =>
      isLoadingMoreMessages[roomId] ?? false;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatRoom>? chatRooms,
    Map<String, List<ChatMessage>>? messages,
    Map<String, bool>? roomsHasMore,
    Map<String, bool>? isLoadingMoreMessages,
    bool? hasMore,
    String? error,
    bool? isSendingMessage,
    ChatRoom? chatRoom,
  }) {
    return ChatState(
      status: status ?? this.status,
      chatRooms: chatRooms ?? this.chatRooms,
      messages: messages ?? this.messages,
      roomsHasMore: roomsHasMore ?? this.roomsHasMore,
      isLoadingMoreMessages:
          isLoadingMoreMessages ?? this.isLoadingMoreMessages,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      chatRoom: chatRoom ?? this.chatRoom,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatState &&
        other.status == status &&
        other.chatRooms == chatRooms &&
        other.messages == messages &&
        other.roomsHasMore == roomsHasMore &&
        other.isLoadingMoreMessages == isLoadingMoreMessages &&
        other.hasMore == hasMore &&
        other.error == error &&
        other.isSendingMessage == isSendingMessage &&
        other.chatRoom == chatRoom;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        chatRooms.hashCode ^
        messages.hashCode ^
        roomsHasMore.hashCode ^
        isLoadingMoreMessages.hashCode ^
        hasMore.hashCode ^
        error.hashCode ^
        isSendingMessage.hashCode ^
        chatRoom.hashCode;
  }
}
