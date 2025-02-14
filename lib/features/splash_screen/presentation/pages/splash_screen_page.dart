import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8iny/features/auth/presentation/blocs/auth_cubit.dart';

import '../../../auth/presentation/pages/login_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});
  static const routeName = '/SplashScreenPage';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isLoggedIn) {
          Future.delayed(const Duration(seconds: 2)).then(
            (value) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
          );
        } else {
          Future.delayed(const Duration(seconds: 2)).then(
            (value) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          );
        }
      },
      child: const Scaffold(
        // Using white background color
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            'la8iny',
            style: TextStyle(
              fontSize: 32, // Large font size for visibility
              fontWeight: FontWeight.bold,
              color: Colors.black, // Black text color
            ),
          ),
        ),
      ),
    );
  }
}
