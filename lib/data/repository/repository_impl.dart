import 'dart:convert';
import 'dart:io';
import 'package:attendme_app/common/exception.dart';
import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/common/strings.dart';
import 'package:attendme_app/data/datasources/remote_datasource.dart';
import 'package:attendme_app/data/models/login_model_response.dart';
import 'package:attendme_app/domain/entities/login.dart';
import 'package:attendme_app/domain/entities/user.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryImpl implements Repository {
  final SharedPreferences sharedPreferences;
  final RemoteDataSource remoteDataSource;
  RepositoryImpl({
    required this.sharedPreferences,
    required this.remoteDataSource,
  });

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
    sharedPreferences.setString(credentialsPrefKey, '');
    return sharedPreferences.setBool(authPrefKey, false);
  }

  @override
  Future<Either<Failure, String>> loginUser(Login user) async {
    try {
      final result = await remoteDataSource.loginUser(user);
      if (result != null) {
        // Saves User Credentials
        sharedPreferences.setString(
            credentialsPrefKey, result.toJson().toString());
        return Right(result.role);
      } else {
        return const Left(ServerFailure('Check your Email or Password!'));
      }
    } on ServerException {
      return const Left(ServerFailure('Server Failure'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<User> getLoginCredentials() async {
    String? result = sharedPreferences.getString(credentialsPrefKey);
    LoginData? encodedJson = LoginData.fromJson(jsonDecode(result!));
    return encodedJson.toEntity();
  }
}
