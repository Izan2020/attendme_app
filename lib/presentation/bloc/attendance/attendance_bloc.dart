import 'package:attendme_app/common/debouncer.dart';
import 'package:attendme_app/domain/entities/check_attendance_params.dart';
import 'package:attendme_app/domain/usecases/check_out_user.dart';
import 'package:attendme_app/domain/usecases/get_attendance_status.dart';
import 'package:attendme_app/domain/usecases/get_login_credentials.dart';
import 'package:attendme_app/domain/usecases/insert_attendance.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceStatus getAttendanceStatus;
  final GetLoginCredentials getLoginCredentials;
  final AttendUser attendUser;
  final CheckoutUser checkoutUser;
  AttendanceBloc({
    required this.getAttendanceStatus,
    required this.attendUser,
    required this.checkoutUser,
    required this.getLoginCredentials,
  }) : super(InitATS()) {
    on<OnGetAttendanceStatus>((event, emit) async {
      emit(LoadingATS());
      await Future.delayed(const Duration(milliseconds: 1500));
      final credentials = await getLoginCredentials.execute();
      final necessaryParams = CheckAttendanceParams(
          date: event.date,
          userId: credentials.userId,
          companyId: credentials.companyId);
      final result = await getAttendanceStatus.execute(necessaryParams);
      result.fold(
        (failure) {
          emit(ErrorATS(message: failure.message));
        },
        (result) {
          switch (result.status) {
            case 'attended':
              emit(AttendedATS(
                DateTime.parse('2023-11-02 ${result.createdTime}'),
                result.attendanceId,
              ));
              break;
            case 'un-attended':
              emit(UnattendedATS());
              break;
            case 'on-request':
              emit(AbsentRequestATS());
              break;
            case 'checked-out':
              emit(CheckedoutATS());
            case 'week-end':
              emit(WeekendATS());
            case 'future-date':
              emit(FutureDateATS());
          }
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 300)));
    on<OnSetCleanState>(
      (event, emit) => emit(InitATS()),
    );
  }
}
