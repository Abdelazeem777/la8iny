import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8iny/core/di/service_locator.dart';

import '../../../auth/presentation/blocs/auth_cubit.dart';
import '../../../chat/presentation/blocs/chat_cubit.dart';
import '../controllers/bloc/search_users_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchUsersBloc>(
      create: (context) => sl(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Search'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            final searchUsersBloc = context.read<SearchUsersBloc>();
            return TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                searchUsersBloc.add(SearchUsersEvent(query: value));
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<SearchUsersBloc, SearchUsersState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final usersList = state.users;

        if (usersList == null || usersList.isEmpty) {
          return const Center(
            child: Text('No users found'),
          );
        }

        return ListView.builder(
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(usersList[index].fullname),
              subtitle: Text(usersList[index].email),
              onLongPress: () {
                final chatCubit = context.read<ChatCubit>();
                final currentUser = context.read<AuthCubit>().state.user!;
                chatCubit.createChat(
                  targetUser: usersList[index],
                  currentUser: currentUser,
                );
              },
            );
          },
        );
      },
    );
  }
}
