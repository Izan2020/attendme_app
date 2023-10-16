import 'package:attendme_app/domain/usecases/check_auth.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_event.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuth checkAuth;
  AuthBloc({required this.checkAuth}) : super(AuthState()) {
    // Check Authentication from Usecase
    on<OnCheckAuth>((event, emit) async {
      final response = await checkAuth.execute();
      switch (response) {
        case true:
          // If it's true it'll continue to HomeScreen
          emit(SuccessAS());
        default:
          // If it's not you'll Authenticate yourself
          emit(SelectAS());
      }
    });
  }
}
