import 'package:attendme_app/domain/entities/insert_attendance_body.dart';

class AttendingEvent {}

class OnAttendUser extends AttendingEvent {
  final AttendanceBody body;
  OnAttendUser(this.body);
}

class OnAbsentRequestUser extends AttendingEvent {
  final AttendanceBody body;
  OnAbsentRequestUser(this.body);
}

class OnCheckoutUser extends AttendingEvent {
  final int userId;
  OnCheckoutUser(this.userId);
}
