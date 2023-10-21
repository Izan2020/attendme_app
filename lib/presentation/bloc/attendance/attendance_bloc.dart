import 'package:attendme_app/domain/usecases/get_attendance_status.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceStatus getAttendanceStatus;

  AttendanceBloc({required this.getAttendanceStatus}) : super(InitATS()) {
    on<OnGetAttendanceStatus>((event, emit) async {
      emit(LoadingATS());
      await Future.delayed(const Duration(milliseconds: 1500));
      final result = await getAttendanceStatus.execute(event.params);
      result.fold(
        (failure) {
          emit(ErrorATS(message: failure.message));
        },
        (result) {
          switch (result.status) {
            case 'attended':
              emit(AttendedATS(
                DateTime.parse(result.dateAttachment!),
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
    });
  }
}
