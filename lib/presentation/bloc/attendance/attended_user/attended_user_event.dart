class AttendedUserEvent {}

class OnFetchAttendedUser extends AttendedUserEvent {
  final DateTime dateTime;
  OnFetchAttendedUser(this.dateTime);
}
