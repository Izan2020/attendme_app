import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/domain/entities/attended_user.dart';
import 'package:attendme_app/domain/entities/check_attendance_params.dart';
import 'package:attendme_app/domain/entities/attendance_status.dart';
import 'package:attendme_app/domain/entities/insert_attendance_body.dart';
import 'package:attendme_app/domain/entities/login.dart';
import 'package:attendme_app/domain/entities/upload_image_params.dart';
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
      CheckAttendanceParams params);
  Future<Either<Failure, bool>> checkOutUser(int attendanceId);
  Future<Either<Failure, bool>> attendUser(AttendanceBody body);
  Future<Either<Failure, String>> uploadImage(UploadImage body);
  Future<Either<Failure, UserAttended>> getAttendedUser(
      CheckAttendanceParams check);
}
