import 'package:attendme_app/common/strings.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryImpl implements Repository {
  SharedPreferences sharedPreferences;
  RepositoryImpl({required this.sharedPreferences});

  @override
  Future<bool?> checkAuth() async {
    return sharedPreferences.getBool(authPrefKey);
  }

  @override
  Future<void> setLoggedIn() {
    return sharedPreferences.setBool(authPrefKey, true);
  }

  @override
  Future<void> setLoggedOut() {
    return sharedPreferences.setBool(authPrefKey, false);
  }
}
