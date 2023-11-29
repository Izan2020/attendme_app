import 'package:attendme_app/domain/entities/check_attendance_params.dart';
import 'package:attendme_app/domain/usecases/get_attended_users.dart';
import 'package:attendme_app/domain/usecases/get_login_credentials.dart';
import 'package:attendme_app/presentation/bloc/attendance/attended_user/attended_user_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attended_user/attended_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendedUserBloc extends Bloc<AttendedUserEvent, AttendedUserState> {
  final GetAttendedUsers getAttendedUsers;
  final GetLoginCredentials getLoginCredentials;
  AttendedUserBloc({
    required this.getAttendedUsers,
    required this.getLoginCredentials,
  }) : super(InitAUS()) {
    on<OnFetchAttendedUser>((event, emit) async {
      emit(LoadingAUS());
      final credentials = await getLoginCredentials.execute();
      final necessaryParams = CheckAttendanceParams(
        date: event.dateTime,
        userId: credentials.userId,
        companyId: credentials.companyId,
      );
      final result = await getAttendedUsers.execute(necessaryParams);
      result.fold(
        (failure) => emit(ErrorAUS(failure.message)),
        (result) => emit(SuccessAUS(
          result.userCount.toString(),
          result.userList,
        )),
      );
    });
  }
}
