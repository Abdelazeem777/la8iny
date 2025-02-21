import '../../../../core/services/remote_database_service.dart';
import '../../../auth/data/models/user_model.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatRoom>> getChatRooms(String userId);
  Future<List<ChatRoom>> getChatRoomsPaginated(String userId,
      {int limit = 20, String? lastRoomId});
  Stream<List<ChatMessage>> getChatMessages(String roomId);
  Future<List<ChatMessage>> getChatMessagesPaginated(String roomId,
      {int limit = 20, String? lastMessageId});
  Future<void> sendMessage(ChatMessage message);
  Future<void> markMessageAsRead(String messageId);
  Future<void> updateUserOnlineStatus(String userId, bool isOnline);
  Future<void> updateUserLastSeen(String userId);
  Stream<bool> getUserOnlineStatus(String userId);

  Future<void> createChat({
    required User targetUser,
    required User currentUser,
  });
}

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final RemoteDatabaseService _remoteDatabase;

  ChatRemoteDataSourceImpl({
    required RemoteDatabaseService remoteDatabase,
  }) : _remoteDatabase = remoteDatabase;

  @override
  Stream<List<ChatRoom>> getChatRooms(String userId) {
    return _remoteDatabase.watchCollection(
      'chatRooms',
      ChatRoom.fromMap,
      queryBuilder: (query) => query
          .where('participantIds', arrayContains: userId)
          .orderBy('updatedAt', descending: true),
    );
  }

  @override
  Future<List<ChatRoom>> getChatRoomsPaginated(String userId,
      {int limit = 20, String? lastRoomId}) async {
    final lastDoc = lastRoomId != null
        ? await _remoteDatabase.getDocument('chatRooms/$lastRoomId')
        : null;

    return _remoteDatabase.getCollectionPaginated(
      'chatRooms',
      ChatRoom.fromMap,
      queryBuilder: (query) => query
          .where('participantIds', arrayContains: userId)
          .orderBy('updatedAt', descending: true)
          .limit(limit),
      startAfterDocument: lastDoc,
    );
  }

  @override
  Stream<List<ChatMessage>> getChatMessages(String roomId) {
    return _remoteDatabase.watchCollection(
      'chatRooms/$roomId/messages',
      ChatMessage.fromMap,
      queryBuilder: (query) => query.orderBy('timestamp', descending: true),
    );
  }

  @override
  Future<List<ChatMessage>> getChatMessagesPaginated(String roomId,
      {int limit = 20, String? lastMessageId}) async {
    final lastDoc = lastMessageId != null
        ? await _remoteDatabase
            .getDocument('chatRooms/$roomId/messages/$lastMessageId')
        : null;

    return _remoteDatabase.getCollectionPaginated(
      'chatRooms/$roomId/messages',
      ChatMessage.fromMap,
      queryBuilder: (query) =>
          query.orderBy('timestamp', descending: true).limit(limit),
      startAfterDocument: lastDoc,
    );
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    await _remoteDatabase.set(
      'chatRooms/${message.id}/messages/${message.id}',
      message,
      (message) => message.toMap(),
    );

    await _remoteDatabase.update(
      'chatRooms/${message.id}',
      {
        'lastMessage': message.toMap(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    // Implementation depends on your message structure
    // You might need to update both the message and the chat room
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) {
    return _remoteDatabase.update('users/$userId', {
      'isOnline': isOnline,
      'lastSeen': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> updateUserLastSeen(String userId) {
    return _remoteDatabase.update('users/$userId', {
      'lastSeen': DateTime.now().toIso8601String(),
    });
  }

  @override
  Stream<bool> getUserOnlineStatus(String userId) {
    return _remoteDatabase
        .watchDocument('users/$userId')
        .map((data) => data?['isOnline'] ?? false);
  }

  @override
  Future<void> createChat({
    required User targetUser,
    required User currentUser,
  }) async {
    final isExists = await _checkIfChatExists(targetUser, currentUser);

    if (isExists) return;

    final chatRoomId = '${targetUser.id}_${currentUser.id}}';

    final chatRoom = ChatRoom(
      id: chatRoomId,
      participantIds: [targetUser.id, currentUser.id],
      participants: {
        targetUser.id: targetUser,
        currentUser.id: currentUser,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return _remoteDatabase.set(
      'chatRooms/$chatRoomId',
      chatRoom.toMap(),
      (data) => data,
    );
  }

  Future<bool> _checkIfChatExists(User targetUser, User currentUser) async {
    final chatRoom = await _remoteDatabase.getCollectionPaginated(
      'chatRooms',
      ChatRoom.fromMap,
      queryBuilder: (query) => query.where('participantIds',
          arrayContainsAny: [targetUser.id, currentUser.id]),
    );

    return chatRoom.isNotEmpty;
  }
}
