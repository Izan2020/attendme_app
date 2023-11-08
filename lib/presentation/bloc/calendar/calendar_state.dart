import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {
  @override
  List<Object?> get props => [];

  get date => [];
}

class InitCDS extends CalendarState {}

class CalendarDateCDS extends CalendarState {
  @override
  final DateTime? date;
  CalendarDateCDS({this.date});
}

class TodaysDateCDS extends CalendarState {
  @override
  final DateTime? date = DateTime.now();
  TodaysDateCDS();
}
