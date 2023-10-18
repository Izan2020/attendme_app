import 'package:attendme_app/data/datasources/remote_datasource.dart';
import 'package:attendme_app/data/repository/repository_impl.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:attendme_app/domain/usecases/check_auth.dart';
import 'package:attendme_app/domain/usecases/login_user.dart';
import 'package:attendme_app/domain/usecases/set_loggedin.dart';
import 'package:attendme_app/domain/usecases/set_loggedout.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/login/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

final inject = GetIt.asNewInstance();

Future<void> initializeDependencies() async {
  // SharedPreferences
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  inject.registerSingleton<SharedPreferences>(sharedPreferences);

  // Datasources
  // RegisterLazySingleton is good for Datasources
  inject.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(client: inject()));

  // Repositories
  // RegisterLazySingleton is good for Repository
  inject.registerLazySingleton<Repository>(() =>
      RepositoryImpl(sharedPreferences: inject(), remoteDataSource: inject()));

  // Usecases
  // RegisterLazySingleton is good for Usecases
  inject.registerLazySingleton(() => CheckAuth(inject()));
  inject.registerLazySingleton(() => LoginUser(inject()));
  inject.registerLazySingleton(() => SetLoggedIn(inject()));
  inject.registerLazySingleton(() => SetLoggedOut(inject()));

  // Blocs
  // RegisterFactory is good for Blocs
  inject.registerFactory(() => AuthBloc(checkAuth: inject()));
  inject.registerFactory(
      () => LoginBloc(loginUser: inject(), setLoggedIn: inject()));

  // Client
  inject.registerLazySingleton(() => Client());
}
