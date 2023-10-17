import 'package:attendme_app/domain/usecases/login_user.dart';
import 'package:attendme_app/presentation/bloc/login/login_event.dart';
import 'package:attendme_app/presentation/bloc/login/login_state.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUser loginUser;
  LoginBloc({required this.loginUser}) : super(InitLS()) {
    on<OnLoginUser>((event, emit) async {
      emit(LoadingLS());
      final result = await loginUser.execute(event.user);
      result.fold(
        (failure) {
          emit(ErrorLS(failure.message));
        },
        (result) {
          emit(SuccessLS(result));
        },
      );
    });
  }
}
