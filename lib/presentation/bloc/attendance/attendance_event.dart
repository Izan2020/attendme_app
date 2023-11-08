import 'package:attendme_app/domain/entities/check_attendance_params.dart';

class AttendanceEvent {
  AttendanceEvent();
}

class OnGetAttendanceStatus extends AttendanceEvent {
  final DateTime date;
  OnGetAttendanceStatus(this.date);
}

class OnGetAttendanceStatusByCalendar extends AttendanceEvent {
  final CheckAttendanceParams params;
  OnGetAttendanceStatusByCalendar(this.params);
}

class OnSetCleanState extends AttendanceEvent {}

class OnRefreshAttendance extends AttendanceEvent {}
