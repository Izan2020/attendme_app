import 'package:attendme_app/domain/entities/login.dart';

class LoginEvent {
  LoginEvent();
}

class OnLoginUser extends LoginEvent {
  final Login user;
  OnLoginUser({required this.user});
}
