import 'package:flutter/material.dart';
import 'package:la8iny/features/auth/data/models/user_model.dart';
import 'package:la8iny/features/chat/data/models/chat_room.dart';

class ChatRoomPage extends StatelessWidget {
  final ChatRoom room;
  final User otherParticipant;

  const ChatRoomPage({
    super.key,
    required this.room,
    required this.otherParticipant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(otherParticipant.fullname),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implement chat options menu
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Chat Room Page - Coming Soon'),
      ),
    );
  }
}
