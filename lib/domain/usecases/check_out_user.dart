import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class CheckoutUser {
  final Repository repository;
  CheckoutUser(this.repository);
  Future<Either<Failure, bool>> execute(int attendanceId) {
    return repository.checkOutUser(attendanceId);
  }
}
