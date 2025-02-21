import 'package:la8iny/features/chat/data/models/chat_message.dart';
import 'package:la8iny/features/chat/data/models/chat_room.dart';

import '../../../auth/data/models/user_model.dart';

abstract class ChatRepository {
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
