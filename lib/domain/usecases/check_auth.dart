import 'package:attendme_app/domain/repository/repository.dart';

class CheckAuth {
  final Repository repository;
  CheckAuth(this.repository);
  Future<bool?> execute() async {
    return await repository.checkAuth();
  }
}
