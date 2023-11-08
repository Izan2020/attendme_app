import 'package:equatable/equatable.dart';

class AttendingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitATNS extends AttendingState {}

class LoadingATNS extends AttendingState {}

class ErrorATNS extends AttendingState {
  final String message;
  ErrorATNS(this.message);
}

class SuccessATNS extends AttendingState {
  final String message;
  SuccessATNS(this.message);
}
