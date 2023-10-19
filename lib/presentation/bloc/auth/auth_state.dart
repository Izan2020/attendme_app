import 'package:attendme_app/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingAS extends AuthState {}

class SuccessAS extends AuthState {
  final User? credentials;
  final DateTime? date;
  SuccessAS({this.credentials, this.date});
}

class SelectAS extends AuthState {}
