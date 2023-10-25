import 'package:equatable/equatable.dart';

class AttendingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnInitATNS extends AttendingState {}

class OnLoadingATNS extends AttendingState {}

class OnErrorATNS extends AttendingState {
  final String message;
  OnErrorATNS(this.message);
}

class OnSuccessATNS extends AttendingState {}
