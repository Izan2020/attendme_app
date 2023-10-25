import 'package:attendme_app/domain/entities/check_attendance_params.dart';

class AttendanceEvent {
  AttendanceEvent();
}

class OnGetAttendanceStatus extends AttendanceEvent {
  final CheckAttendanceParams params;
  OnGetAttendanceStatus(this.params);
}

class OnGetAttendanceStatusByCalendar extends AttendanceEvent {
  final CheckAttendanceParams params;
  OnGetAttendanceStatusByCalendar(this.params);
}

class OnSetCleanState extends AttendanceEvent {}
