import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/domain/entities/attended_user.dart';
import 'package:attendme_app/domain/entities/check_attendance_params.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class GetAttendedUsers {
  final Repository repository;
  GetAttendedUsers(this.repository);

  Future<Either<Failure, UserAttended>> execute(CheckAttendanceParams check) {
    return repository.getAttendedUser(check);
  }
}
