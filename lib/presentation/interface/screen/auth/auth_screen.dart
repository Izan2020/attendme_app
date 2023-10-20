import 'package:attendme_app/common/images.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_event.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:attendme_app/presentation/interface/screen/auth/login_screen.dart';
import 'package:attendme_app/presentation/interface/screen/home_screen.dart';
import 'package:attendme_app/presentation/interface/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  static const routePath = '/auth_screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    context.read<AuthBloc>().add(OnCheckAuth());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) =>
            state != SuccessAS() ? context.go(AuthScreen.routePath) : null,
        listenWhen: (previous, current) => current != SuccessAS(),
        builder: (context, state) {
          if (state == SuccessAS()) {
            Future.microtask(() => context.go(HomeScreen.routePath));
          }
          switch (state) {
            case LoadingAS():
              return Center(
                child: Image.asset(AppImages.iconSplashScreen),
              );
            case UnauthorizedAS():
              return Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            width: double.infinity,
                            child:
                                Image.asset(AppImages.illustrationAuthScreen)),
                        const SizedBox(height: 16),
                        const Text(
                          'AttendMe',
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          'Effortless Attendance Tracking: Simplify, Monitor, and Manage with Precision - Your Perfect Attendance Companion.',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          title: 'Login',
                          onTap: () => context.push(LoginScreen.routePath),
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(title: 'Register Company', onTap: () {}),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return Container();
          }
        },
      )),
    );
  }
}
