import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:la8iny/core/services/remote_database_service.dart';
import 'package:la8iny/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:la8iny/features/chat/data/models/chat_message.dart';
import 'package:la8iny/features/chat/data/models/chat_room.dart';
import 'package:la8iny/features/chat/data/repositories/chat_repository.dart';

import '../../../auth/data/models/user_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRepositoryImpl({
    required ChatRemoteDataSource chatRemoteDataSource,
  }) : _chatRemoteDataSource = chatRemoteDataSource;

  @override
  Stream<List<ChatRoom>> getChatRooms(String userId) {
    return _chatRemoteDataSource.getChatRooms(userId);
  }

  @override
  Future<List<ChatRoom>> getChatRoomsPaginated(String userId,
      {int limit = 20, String? lastRoomId}) async {
    return _chatRemoteDataSource.getChatRoomsPaginated(userId,
        limit: limit, lastRoomId: lastRoomId);
  }

  @override
  Stream<List<ChatMessage>> getChatMessages(String roomId) {
    return _chatRemoteDataSource.getChatMessages(roomId);
  }

  @override
  Future<List<ChatMessage>> getChatMessagesPaginated(String roomId,
      {int limit = 20, String? lastMessageId}) async {
    return _chatRemoteDataSource.getChatMessagesPaginated(roomId,
        limit: limit, lastMessageId: lastMessageId);
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    return _chatRemoteDataSource.sendMessage(message);
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    return _chatRemoteDataSource.markMessageAsRead(messageId);
  }

  @override
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) {
    return _chatRemoteDataSource.updateUserOnlineStatus(userId, isOnline);
  }

  @override
  Future<void> updateUserLastSeen(String userId) {
    return _chatRemoteDataSource.updateUserLastSeen(userId);
  }

  @override
  Stream<bool> getUserOnlineStatus(String userId) {
    return _chatRemoteDataSource.getUserOnlineStatus(userId);
  }

  @override
  Future<void> createChat({
    required User targetUser,
    required User currentUser,
  }) {
    return _chatRemoteDataSource.createChat(
      targetUser: targetUser,
      currentUser: currentUser,
    );
  }
}
