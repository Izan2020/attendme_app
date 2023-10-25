import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/domain/entities/insert_attendance_body.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class AttendUser {
  final Repository repository;
  AttendUser(this.repository);
  Future<Either<Failure, bool>> execute(AttendanceBody body) {
    return repository.attendUser(body);
  }
}
