import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/domain/entities/login.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_event.dart';
import 'package:attendme_app/presentation/bloc/login/login_bloc.dart';
import 'package:attendme_app/presentation/bloc/login/login_event.dart';
import 'package:attendme_app/presentation/bloc/login/login_state.dart';

import 'package:attendme_app/presentation/interface/screen/home_screen.dart';
import 'package:attendme_app/presentation/interface/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  static const routePath = '/login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  double _opacityLogin = 0;

  _loginUser() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (_emailField.text == '') {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: const Text(
          'Fill your Email!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.danger,
      ));
      return;
    }
    if (_passwordField.text == '') {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: const Text(
          'Fill your Password!',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.danger,
      ));
      return;
    }
    final user = Login(
      email: _emailField.text,
      password: _passwordField.text,
    );
    context.read<LoginBloc>().add(OnLoginUser(user: user));
    final state = context.read<LoginBloc>().state;
    if (state is SuccessLS) {
      Future.microtask(() => context.read<AuthBloc>().add(OnLoggingIn()));
      context.go(HomeScreen.routePath);
    }
  }

  @override
  void initState() {
    Future.microtask(() {
      setState(() {
        _opacityLogin = 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Login'),
        ),
        body: AnimatedOpacity(
          opacity: _opacityLogin,
          duration: const Duration(milliseconds: 300),
          child: SafeArea(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailField,
                      decoration: const InputDecoration(label: Text('Email')),
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    TextField(
                      controller: _passwordField,
                      obscureText: true,
                      decoration:
                          const InputDecoration(label: Text('Password')),
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    PrimaryButton(title: 'Login', onTap: () => _loginUser())
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      if (state is ErrorLS) {
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(
            state.message,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.danger,
        ));
      }
    });
  }
}
