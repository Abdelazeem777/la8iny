import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la8iny/core/di/service_locator.dart';

import '../blocs/auth_cubit.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.isLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Welcome ${state.user?.fullname}'),
                  ),
                );
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
                  _buildEmailFullnameField(),
                  const SizedBox(height: 16.0),
                  _buildEmailField(),
                  const SizedBox(height: 16.0),
                  _buildPasswordField(),
                  const SizedBox(height: 16.0),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailFullnameField() {
    return TextFormField(
      controller: _fullNameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your full name';
        }
        return null;
      },
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
              cubit.login(
                _emailController.text,
                _passwordController.text,
              );
            }
          },
          child: Text(state.isLoading ? "Loading" : 'Signup'),
        );
      },
    );
  }
}
