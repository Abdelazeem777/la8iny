import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8iny/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8iny/features/chat/data/models/chat_room.dart';
import 'package:la8iny/features/chat/presentation/blocs/chat_cubit.dart';
import 'package:la8iny/features/home/presentation/pages/search_page.dart';
import 'package:la8iny/features/home/presentation/widgets/chat_item.dart';

class ChatListTab extends StatelessWidget {
  const ChatListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state.isInitial || state.isLoading && state.chatRooms.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.isError && state.chatRooms.isEmpty) {
            return Center(
              child: Text(state.error ?? 'Something went wrong'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final userId = context.read<AuthCubit>().state.user?.id;
              if (userId != null) {
                context.read<ChatCubit>().init(userId);
              }
            },
            child: ListView.separated(
              itemCount: state.chatRooms.length + (state.hasMore ? 1 : 0),
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                if (index == state.chatRooms.length) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const SizedBox();
                }

                final room = state.chatRooms[index];
                return ChatItem(room: room);
              },
            ),
          );
        },
      ),
    );
  }
}
