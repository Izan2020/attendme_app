abstract class Repository {
  Future<bool?> checkAuth();
  Future<void> setLoggedIn();
  Future<void> setLoggedOut();
}
