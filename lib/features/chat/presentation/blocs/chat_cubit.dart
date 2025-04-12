import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:la8iny/features/auth/data/models/user_model.dart';
import 'package:la8iny/features/chat/data/models/chat_message.dart';
import 'package:la8iny/features/chat/data/models/chat_room.dart';
import 'package:la8iny/features/chat/data/repositories/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatRoom>>? _chatRoomsSubscription;

  ChatCubit(this._chatRepository) : super(const ChatState());

  void init(String userId) {
    _chatRoomsSubscription?.cancel();
    _chatRoomsSubscription = _chatRepository.getChatRooms(userId).listen(
      (rooms) {
        emit(state.copyWith(
          status: ChatStatus.loaded,
          chatRooms: rooms,
        ));
      },
      onError: (error) {
        log(error.toString());
        emit(state.copyWith(
          status: ChatStatus.error,
          error: error.toString(),
        ));
      },
    );
  }

  Future<void> loadMoreRooms(String userId) async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(status: ChatStatus.loading));

    try {
      final lastRoomId =
          state.chatRooms.isNotEmpty ? state.chatRooms.last.id : null;
      final rooms = await _chatRepository.getChatRoomsPaginated(
        userId,
        lastRoomId: lastRoomId,
      );

      if (rooms.isEmpty) {
        emit(state.copyWith(hasMore: false));
        return;
      }

      emit(state.copyWith(
        status: ChatStatus.loaded,
        chatRooms: [...state.chatRooms, ...rooms],
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ChatStatus.error,
        error: error.toString(),
      ));
    }
  }

  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    try {
      await _chatRepository.updateUserOnlineStatus(userId, isOnline);
    } catch (error) {
      emit(state.copyWith(
        status: ChatStatus.error,
        error: error.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    return super.close();
  }

  Future<void> createChat({
    required User targetUser,
    required User currentUser,
  }) async {
    try {
      final room = await _chatRepository.createChat(
        targetUser: targetUser,
        currentUser: currentUser,
      );

      emit(state.copyWith(chatRoom: room));
    } catch (error) {
      emit(state.copyWith(
        status: ChatStatus.error,
        error: error.toString(),
      ));
    }
  }
}
