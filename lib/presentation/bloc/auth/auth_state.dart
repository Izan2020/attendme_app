import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingAS extends AuthState {}

class SuccessAS extends AuthState {}

class LoginAS extends AuthState {}

class SelectAS extends AuthState {}

class RegisterCompanyAS extends AuthState {}
