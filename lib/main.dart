import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8iny/core/di/service_locator.dart';
import 'package:la8iny/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:la8iny/features/splash_screen/presentation/pages/splash_screen_page.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/chat/presentation/blocs/chat_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  initServiceLocator();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => sl<AuthCubit>()..init(),
        ),
        BlocProvider(
          create: (context) => sl<ChatCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Login Page',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreenPage(),
      ),
    );
  }
}
