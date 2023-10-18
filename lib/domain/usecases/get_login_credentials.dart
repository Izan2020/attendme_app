import 'package:attendme_app/domain/entities/user.dart';
import 'package:attendme_app/domain/repository/repository.dart';

class GetLoginCredentials {
  final Repository repository;
  GetLoginCredentials(this.repository);

  Future<User> execute() {
    return repository.getLoginCredentials();
  }
}
