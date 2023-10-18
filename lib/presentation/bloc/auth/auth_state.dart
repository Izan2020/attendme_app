import 'package:attendme_app/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingAS extends AuthState {}

class SuccessAdminAS extends AuthState {
  User? credentials;
  SuccessAdminAS({this.credentials});
}

class SuccessDefaultAS extends AuthState {
  User? credentials;
  SuccessDefaultAS({this.credentials});
}

class SelectAS extends AuthState {}
