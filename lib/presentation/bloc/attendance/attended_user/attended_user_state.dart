import 'package:attendme_app/data/models/attended_user_response.dart';
import 'package:equatable/equatable.dart';

class AttendedUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitAUS extends AttendedUserState {}

class LoadingAUS extends AttendedUserState {}

class SuccessAUS extends AttendedUserState {
  final String userPercentage;
  final List<AttendedUser> listOfUser;
  SuccessAUS(this.userPercentage, this.listOfUser);
}

class ErrorAUS extends AttendedUserState {
  final String message;
  ErrorAUS(this.message);
}
