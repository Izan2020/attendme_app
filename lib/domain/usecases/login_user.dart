import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/domain/entities/login.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class LoginUser {
  final Repository repository;
  LoginUser(this.repository);

  Future<Either<Failure, String>> execute(Login user) {
    return repository.loginUser(user);
  }
}
