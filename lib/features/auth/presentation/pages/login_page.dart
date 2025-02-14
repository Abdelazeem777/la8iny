import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8iny/features/auth/data/repo/auth_repo_impl.dart';
import 'package:la8iny/core/di/service_locator.dart';
import 'package:la8iny/features/auth/presentation/pages/signup_page.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../blocs/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.isLoggedIn) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Welcome ${state.user?.fullname}'),
                ),
              );

              _goToHomePage(context);
            } else if (state.isError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? "Error"),
                ),
              );
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildEmailField(),
                SizedBox(height: 16.0),
                _buildPasswordField(),
                SizedBox(height: 16.0),
                _buildLoginButton(),
                _buildDontHaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previousState, currentState) {
        return previousState != currentState;
      },
      builder: (context, state) {
        final cubit = BlocProvider.of<AuthCubit>(context);
        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              cubit.login(_emailController.text, _passwordController.text);
            }
          },
          child: Text(state.isLoading ? "Loading" : 'Login'),
        );
      },
    );
  }

  Widget _buildDontHaveAccount() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignupPage(),
          ),
        );
      },
      child: Text('Don\'t have an account? Sign up'),
    );
  }

  void _goToHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }
}
