import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8iny/core/di/service_locator.dart';
import 'package:la8iny/features/auth/data/models/user_model.dart';
import 'package:la8iny/features/chat/data/models/chat_message.dart';
import 'package:la8iny/features/chat/data/models/chat_room.dart';
import 'package:la8iny/features/chat/presentation/blocs/chat_room/chat_room_cubit.dart';
import 'package:la8iny/features/chat/presentation/pages/real_time_drawing_page.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoom room;
  final User otherParticipant;
  final User currentUser;

  const ChatRoomPage({
    super.key,
    required this.room,
    required this.otherParticipant,
    required this.currentUser,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final cubit = context.read<ChatRoomCubit>();
        final state = cubit.state;
        if (!state.isLoadingMore && state.hasMore) {
          cubit.loadMoreMessages();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatRoomCubit>(
      create: (_) => sl<ChatRoomCubit>()..init(widget.room.id),
      child: BlocListener<ChatRoomCubit, ChatRoomState>(
        listener: (context, state) {
          if (state.messageStatus?.isSent == true) _messageController.clear();

          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
                  builder: (context, state) {
                    if (state.isInitial ||
                        (state.isLoading && state.messages.isEmpty)) {
                      return _buildLoadingIndicator();
                    }

                    if (state.isError && state.messages.isEmpty) {
                      return _buildErrorMessage(state);
                    }

                    if (state.messages.isEmpty) {
                      return _buildEmptyMessagesList();
                    }

                    return _buildMessagesList(state, context);
                  },
                ),
              ),
              BlocBuilder<ChatRoomCubit, ChatRoomState>(
                buildWhen: (previous, current) =>
                    previous.messageStatus != current.messageStatus,
                builder: (context, state) {
                  return _buildInputArea(state, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(widget.otherParticipant.fullname),
      actions: [
        IconButton(
          icon: const Icon(Icons.brush),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RealTimeDrawingPage(
                  roomId: widget.room.id,
                  userId: widget.currentUser.id,
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // TODO: Implement chat options menu
          },
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorMessage(ChatRoomState state) {
    return Center(
      child: Text('Error: ${state.error}'),
    );
  }

  Widget _buildEmptyMessagesList() {
    return const Center(
      child: Text('No messages yet'),
    );
  }

  Widget _buildMessagesList(ChatRoomState state, BuildContext context) {
    var shouldShowLoadingMore = state.hasMore && state.isLoadingMore;
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      itemCount: state.messages.length + (shouldShowLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (shouldShowLoadingMore && index == state.messages.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final message = state.messages[index];
        final isMyMessage = message.senderId == widget.currentUser.id;

        return _ChatBubble(
          message: message,
          isMyMessage: isMyMessage,
        );
      },
    );
  }

  Widget _buildInputArea(ChatRoomState state, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  filled: true,
                  fillColor: Color.fromARGB(255, 230, 230, 230),
                ),
              ),
            ),
            const SizedBox(width: 8),
            state.messageStatus?.isLoading == true
                ? const CircularProgressIndicator()
                : IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => context.read<ChatRoomCubit>().sendMessage(
                          content: _messageController.text.trim(),
                          currentUser: widget.currentUser,
                          otherUser: widget.otherParticipant,
                        ),
                    color: Theme.of(context).primaryColor,
                  ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMyMessage;

  const _ChatBubble({
    required this.message,
    required this.isMyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color:
              isMyMessage ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMyMessage ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: isMyMessage ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
