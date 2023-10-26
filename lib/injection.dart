import 'package:attendme_app/data/datasources/remote_datasource.dart';
import 'package:attendme_app/data/repository/repository_impl.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:attendme_app/domain/usecases/check_auth.dart';
import 'package:attendme_app/domain/usecases/check_out_user.dart';
import 'package:attendme_app/domain/usecases/get_attendance_status.dart';
import 'package:attendme_app/domain/usecases/get_login_credentials.dart';
import 'package:attendme_app/domain/usecases/insert_attendance.dart';
import 'package:attendme_app/domain/usecases/login_user.dart';
import 'package:attendme_app/domain/usecases/set_loggedout.dart';
import 'package:attendme_app/domain/usecases/upload_image.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/current_date/current_date_bloc.dart';
import 'package:attendme_app/presentation/bloc/login/login_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
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
  inject.registerLazySingleton(() => SetLoggedOut(inject()));
  inject.registerLazySingleton(() => GetLoginCredentials(inject()));
  inject.registerLazySingleton(() => GetAttendanceStatus(inject()));
  inject.registerLazySingleton(() => AttendUser(inject()));
  inject.registerLazySingleton(() => CheckoutUser(inject()));
  inject.registerLazySingleton(() => UploadImageImgur(inject()));

  // Blocs
  // RegisterFactory is good for Blocs
  inject.registerFactory(() => AuthBloc(
        checkAuth: inject(),
        getLoginCredentials: inject(),
        setLoggedOut: inject(),
      ));
  inject.registerFactory(() => LoginBloc(
        loginUser: inject(),
      ));
  inject.registerFactory(() => AttendanceBloc(
        getAttendanceStatus: inject(),
        attendUser: inject(),
        checkoutUser: inject(),
      ));
  inject.registerFactory(
    () => CurrentDateBloc(),
  );
  inject.registerFactory(
    () => AttendingBloc(
      attendUser: inject(),
      checkoutUser: inject(),
    ),
  );
  inject.registerFactory(
    () => ImageBloc(uploadImageImgur: inject()),
  );

  // Client
  inject.registerLazySingleton(() => Dio());
}
