import 'package:attendme_app/data/repository/repository_impl.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:attendme_app/domain/usecases/check_auth.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final inject = GetIt.asNewInstance();
Future<void> initializeDependencies() async {
  // Repositories
  // RegisterLazySingleton is good for Repository
  inject.registerSingleton<Repository>(RepositoryImpl(
    sharedPreferences: inject(),
  ));

  // Usecases
  // RegisterLazySingleton is good for Usecases
  inject.registerLazySingleton(() => CheckAuth(inject()));

  // Blocs
  // RegisterFactory is good for Blocs
  inject.registerFactory(() => AuthBloc(checkAuth: inject()));

  // Datasources
  // RegisterLazySingleton is good for Datasources
  // TODO : Add Datasources
}
