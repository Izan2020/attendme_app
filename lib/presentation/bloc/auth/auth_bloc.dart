import 'package:attendme_app/domain/usecases/check_auth.dart';
import 'package:attendme_app/domain/usecases/get_login_credentials.dart';
import 'package:attendme_app/domain/usecases/set_loggedin.dart';
import 'package:attendme_app/domain/usecases/set_loggedout.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_event.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuth checkAuth;
  final GetLoginCredentials getLoginCredentials;
  final SetLoggedOut setLoggedOut;
  final SetLoggedIn setLoggedIn;
  AuthBloc({
    required this.checkAuth,
    required this.getLoginCredentials,
    required this.setLoggedOut,
    required this.setLoggedIn,
  }) : super(LoadingAS()) {
    // Check Authentication from Usecase
    on<OnCheckAuth>((event, emit) async {
      // A little bit of delay
      await Future.delayed(const Duration(milliseconds: 1500));
      final result = await checkAuth.execute();
      switch (result) {
        case true:
          debugPrint('Success State');
          final credentials = await getLoginCredentials.execute();
          emit(SuccessAS(credentials: credentials));
          break;
        default:
          debugPrint('Select State');
          // If youre not you'll be stated as Unauthorized
          emit(UnauthorizedAS());
          break;
      }
    });
    on<OnLogout>((event, emit) async {
      setLoggedOut.execute();
      emit(UnauthorizedAS());
    });
    on<OnLoggingIn>((event, emit) async {
      setLoggedIn.execute();
      final credentials = await getLoginCredentials.execute();
      emit(SuccessAS(credentials: credentials));
    });
  }
}
