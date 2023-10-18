import 'dart:io';

import 'package:attendme_app/common/exception.dart';
import 'package:attendme_app/common/failure.dart';
import 'package:attendme_app/common/strings.dart';
import 'package:attendme_app/data/datasources/remote_datasource.dart';
import 'package:attendme_app/domain/entities/login.dart';
import 'package:attendme_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
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
    return sharedPreferences.setBool(authPrefKey, false);
  }

  @override
  Future<Either<Failure, String>> loginUser(Login user) async {
    try {
      final result = await remoteDataSource.loginUser(user);
      if (result != null) {
        debugPrint('Success Repository : ${result.surname}');

        // Saves Company ID
        sharedPreferences.setInt(companyIdPrefKey, result.companyId);
        // Saves User ID
        sharedPreferences.setInt(companyIdPrefKey, result.id);
        return const Right('Logged In');
      } else {
        debugPrint('Error Repository : Not Found');
        return const Left(ServerFailure('Check your Email or Password!'));
      }
    } on ServerException {
      debugPrint('Error Repository : Server Failure');
      return const Left(ServerFailure('Server Failure'));
    } on SocketException {
      debugPrint('Error Repository : Connection Failure');
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
