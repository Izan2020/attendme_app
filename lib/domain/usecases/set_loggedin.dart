import 'package:attendme_app/domain/repository/repository.dart';

class SetLoggedIn {
  final Repository repository;
  SetLoggedIn(this.repository);

  Future<void> execute() {
    return repository.setLoggedIn();
  }
}
