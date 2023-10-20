import 'package:attendme_app/domain/entities/attendance_params.dart';

class AttendanceEvent {
  AttendanceEvent();
}

class OnGetAttendanceStatus extends AttendanceEvent {
  final AttendanceParams params;
  OnGetAttendanceStatus(this.params);
}

class OnGetAttendanceStatusByCalendar extends AttendanceEvent {
  final AttendanceParams params;
  OnGetAttendanceStatusByCalendar(this.params);
}

class OnRefreshAttendanceStatus extends AttendanceEvent {}

class OnAttending extends AttendanceEvent {}

class OnCheckingOut extends AttendanceEvent {}

class OnRequestAbsent extends AttendanceEvent {
  final String message;
  OnRequestAbsent(this.message);
}
