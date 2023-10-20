import 'package:equatable/equatable.dart';

class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitATS extends AttendanceState {}

class LoadingATS extends AttendanceState {}

class ErrorATS extends AttendanceState {
  final String? message;
  ErrorATS({this.message});
}

class UnattendedATS extends AttendanceState {}

class AttendedATS extends AttendanceState {
  final String? timeAttended;
  final int? attendanceId;
  AttendedATS(this.timeAttended, this.attendanceId);
}

class AbsentedATS extends AttendanceState {
  final int? attendanceId;
  AbsentedATS(this.attendanceId);
}

class AbsentRequestATS extends AttendanceState {}

class CheckedoutATS extends AttendanceState {}
