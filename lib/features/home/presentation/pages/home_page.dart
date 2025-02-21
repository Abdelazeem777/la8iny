import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8iny/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8iny/features/auth/presentation/pages/login_page.dart';
import 'package:la8iny/features/chat/presentation/blocs/chat_cubit.dart';
import 'package:la8iny/features/home/presentation/widgets/chat_list_tab.dart';
import 'package:la8iny/features/home/presentation/widgets/profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initChatCubit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final userId = context.read<AuthCubit>().state.user?.id;
    if (userId == null) return;

    final isOnline = state == AppLifecycleState.resumed;
    context.read<ChatCubit>().updateUserOnlineStatus(userId, isOnline);
  }

  void _initChatCubit() {
    final userId = context.read<AuthCubit>().state.user?.id;
    if (userId != null) {
      context.read<ChatCubit>().init(userId);
      context.read<ChatCubit>().updateUserOnlineStatus(userId, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.isLoggedOut) _goToLoginPage(context);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const ChatListTab(),
            const ProfileTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _goToLoginPage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (route) => false,
    );
  }
}
