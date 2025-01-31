import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});
  static const routeName = '/SplashScreenPage';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
    );
  }
}
