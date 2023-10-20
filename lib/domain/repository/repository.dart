import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/domain/entities/attendance_params.dart';
import 'package:attendme_app/domain/entities/attendance_status.dart';
import 'package:attendme_app/domain/entities/login.dart';
import 'package:attendme_app/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  // Authentication
  Future<bool?> checkAuth();

  Future<void> logoutUser();
  Future<Either<Failure, String>> loginUser(Login user);
  Future<User> getLoginCredentials();
  // Attendance
  Future<Either<Failure, AttendanceStatus>> getAttendanceStatus(
      AttendanceParams params);
}
