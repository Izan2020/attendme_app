import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/domain/entities/login.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  Future<bool?> checkAuth();
  Future<void> setLoggedIn();
  Future<void> setLoggedOut();
  Future<Either<Failure, String>> loginUser(Login user);
}
