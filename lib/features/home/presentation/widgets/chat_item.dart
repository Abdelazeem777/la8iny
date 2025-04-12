import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8iny/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8iny/features/chat/data/models/chat_room.dart';
import 'package:la8iny/features/chat/presentation/pages/chat_room_page.dart';

class ChatItem extends StatelessWidget {
  final ChatRoom room;

  const ChatItem({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthCubit>().state.user;
    final currentUserId = currentUser?.id;
    if (currentUserId == null) return const SizedBox();

    final otherParticipantId =
        room.participantIds.firstWhere((id) => id != currentUserId);
    final otherParticipant = room.participants[otherParticipantId];
    if (otherParticipant == null) return const SizedBox();

    return ListTile(
      leading: CircleAvatar(
        child: Text(otherParticipant.fullname[0].toUpperCase()),
      ),
      title: Text(otherParticipant.fullname),
      subtitle: Text(
        otherParticipant.isOnline ? 'Online' : 'Offline',
        style: TextStyle(
          color: otherParticipant.isOnline
              ? const Color.fromARGB(255, 46, 89, 47)
              : Colors.grey,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              room: room,
              otherParticipant: otherParticipant,
              currentUser: currentUser!,
            ),
          ),
        );
      },
    );
  }
}
