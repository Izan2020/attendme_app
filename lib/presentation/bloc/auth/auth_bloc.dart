import 'package:attendme_app/domain/usecases/check_auth.dart';
import 'package:attendme_app/domain/usecases/get_login_credentials.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_event.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuth checkAuth;
  final GetLoginCredentials getLoginCredentials;
  AuthBloc({
    required this.checkAuth,
    required this.getLoginCredentials,
  }) : super(LoadingAS()) {
    // Check Authentication from Usecase
    on<OnCheckAuth>((event, emit) async {
      // A little bit of delay
      debugPrint('Loading..');
      await Future.delayed(const Duration(milliseconds: 1500));
      final response = await checkAuth.execute();

      switch (response) {
        case true:
          debugPrint('Getting Credentials');
          final credentials = await getLoginCredentials.execute();
          debugPrint('Credentials Gotten!');
          // If you're an admin you will be stated as Admin
          // else as Default User
          if (credentials.role == 'admin') {
            emit(SuccessAdminAS(credentials: credentials));
            debugPrint('Success Admin ');
          } else {
            emit(SuccessDefaultAS(credentials: credentials));
            debugPrint('Success User');
          }
        default:
          // If youre not you'll be stated as Unauthorized
          emit(SelectAS());
      }
    });
  }
}
