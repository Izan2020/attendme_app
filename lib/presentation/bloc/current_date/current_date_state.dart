import 'package:equatable/equatable.dart';

class CurrentDateState extends Equatable {
  @override
  List<Object?> get props => [];

  get date => null;
}

class CalendarDateCDS extends CurrentDateState {
  @override
  final DateTime? date;
  CalendarDateCDS({this.date});
}

class TodaysDateCDS extends CurrentDateState {
  @override
  final DateTime? date;
  TodaysDateCDS({this.date});
}
