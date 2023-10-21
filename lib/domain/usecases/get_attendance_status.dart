import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/domain/entities/check_attendance_params.dart';
import 'package:attendme_app/domain/entities/attendance_status.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class GetAttendanceStatus {
  final Repository repository;
  GetAttendanceStatus(this.repository);

  Future<Either<Failure, AttendanceStatus>> execute(
      CheckAttendanceParams params) {
    return repository.getAttendanceStatus(params);
  }
}
