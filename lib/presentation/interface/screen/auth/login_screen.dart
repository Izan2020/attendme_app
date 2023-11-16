import 'package:attendme_app/common/snackbars.dart';
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
  static const routePath = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  double _opacityLogin = 0;

  Future<void> loginUser() async {
    final state = context.read<LoginBloc>().state;

    if (state is LoadingLS) return;

    if (_emailField.text == '') {
      AppSnackbar.danger(context: context, text: 'Fill your Email.');
      return;
    }
    if (_passwordField.text == '') {
      AppSnackbar.danger(context: context, text: 'Fill your Password.');
      return;
    }
    final user = Login(
      email: _emailField.text,
      password: _passwordField.text,
    );
    context.read<LoginBloc>().add(OnLoginUser(user: user));
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
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailField,
                      decoration: const InputDecoration(label: Text('Email')),
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    TextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordField,
                      obscureText: true,
                      decoration:
                          const InputDecoration(label: Text('Password')),
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                      switch (state) {
                        case LoadingLS():
                          return const CircularProgressIndicator();
                        default:
                          return PrimaryButton(
                              title: 'Login', onTap: () => loginUser());
                      }
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is ErrorLS) {
        AppSnackbar.danger(context: context, text: state.message);
      } else if (state is SuccessLS) {
        Future.microtask(() => context.read<AuthBloc>().add(OnLoggingIn()));
        Future.microtask(() => context.read<LoginBloc>().close());
        context.go(HomeScreen.routePath);
      }
    });
  }
}
