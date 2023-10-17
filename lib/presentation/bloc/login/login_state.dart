import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitLS extends LoginState {}

class LoadingLS extends LoginState {}

class SuccessLS extends LoginState {
  final String message;
  SuccessLS(this.message);
}

class ErrorLS extends LoginState {
  final String message;
  ErrorLS(this.message);
}
