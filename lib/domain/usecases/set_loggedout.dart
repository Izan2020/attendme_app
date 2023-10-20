import 'package:attendme_app/domain/repository/repository.dart';

class SetLoggedOut {
  final Repository repository;
  SetLoggedOut(this.repository);

  Future<void> execute() {
    return repository.logoutUser();
  }
}
