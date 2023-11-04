import 'dart:io';

import 'package:attendme_app/common/encryptor.dart';
import 'package:attendme_app/common/exception.dart';
import 'package:attendme_app/common/imgur.dart';
import 'package:attendme_app/common/supabase.dart';
import 'package:attendme_app/common/timestamp.dart';
import 'package:attendme_app/data/models/attendance_model_check_response.dart';
import 'package:attendme_app/data/models/login_model_response.dart';
import 'package:attendme_app/domain/entities/check_attendance_params.dart';
import 'package:attendme_app/domain/entities/insert_attendance_body.dart';
import 'package:attendme_app/domain/entities/login.dart';
import 'package:attendme_app/domain/entities/upload_image_params.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class RemoteDataSource {
  Future<LoginData?> loginUser(Login user);
  Future<AttendanceCheckResponse?> getAttendance(CheckAttendanceParams check);
  Future<bool> updateCheckOut(int attendanceId);
  Future<bool> insertAttendance(AttendanceBody body);

  Future<String?> uploadImageImgur(UploadImage body);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final SupabaseClient supabase;
  final ImgurClient imgur;
  RemoteDataSourceImpl({
    required this.supabase,
    required this.imgur,
  });

  @override
  Future<LoginData?> loginUser(Login user) async {
    final email = user.email;
    final password = calculateSHA256(user.password);

    try {
      final request = await supabase.get(
          'user?select=id,surname,last_name,role,job_desk,image_url,email,company_id&email=eq.$email&password=eq.$password');
      if (request.statusCode == 200) {
        List<dynamic> response = request.data;
        if (response.isNotEmpty) {
          return LoginData.fromJson(response[0]);
        } else {
          debugPrint('Error RDS');
          return null;
        }
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw const SocketException('N/A');
      }
      if (e.response?.statusCode != 200 || e.response?.statusCode != 201) {
        throw ServerException('${e.response?.statusCode}');
      }
    }
    return null;
  }

  @override
  Future<AttendanceCheckResponse?> getAttendance(
      CheckAttendanceParams check) async {
    String date = simpleDateTime(value: check.date!, format: 'yyyy-MM-dd');
    debugPrint(date);
    try {
      final request = await supabase.get(
          'attendance?select=*&created_at=eq.$date&company_id=eq.${check.companyId}&user_id=eq.${check.userId}');

      if (request.statusCode == 200) {
        final dayWeeknd = simpleDateTime(value: check.date!, format: 'E');
        final currentDate = DateTime.now();
        final paramsDate = check.date;

        // Validate Weeknd Date
        if (dayWeeknd == 'Sat' || dayWeeknd == 'Sun') {
          return const AttendanceCheckResponse(status: 'week-end');
        }

        // Validate Future Date
        if (paramsDate!.isAfter(currentDate)) {
          return const AttendanceCheckResponse(status: 'future-date');
        }

        List<dynamic> response = request.data;

        if (response.isNotEmpty) {
          Map<String, dynamic> firstElement = response[0];
          return AttendanceCheckResponse.fromJson(firstElement);
        } else if (paramsDate.isBefore(currentDate) || response.isEmpty) {
          return const AttendanceCheckResponse(status: 'un-attended');
        }
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw const SocketException('N/A');
      }
      if (e.response?.statusCode != 200 || e.response?.statusCode != 201) {
        throw ServerException('${e.response?.statusCode}');
      }
    }
    return null;
  }

  @override
  Future<bool> updateCheckOut(int attendanceId) async {
    final checkOutBody = {"status": "checked-out"};

    try {
      final response = await supabase.patch(
        'attendance?status=eq.$attendanceId',
        body: checkOutBody,
      );
      if (response.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw const SocketException('N/A');
      }
      if (e.response?.statusCode != 200 || e.response?.statusCode != 201) {
        throw ServerException('${e.response?.statusCode}');
      }
    }
    return false;
  }

  @override
  Future<bool> insertAttendance(AttendanceBody body) async {
    final attendanceBody = {
      "user_id": body.userId,
      "company_id": body.companyId,
      "image_url": body.imageUrl,
      "longitude": body.longitude,
      "latitude": body.latitude,
      "status": body.status,
      "reason": body.reason,
    };

    try {
      final response = await supabase.post(
        'attendance',
        body: attendanceBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw const SocketException('N/A');
      }
      if (e.response?.statusCode != 200 || e.response?.statusCode != 201) {
        throw ServerException('${e.response?.statusCode}');
      }
    }
    return false;
  }

  @override
  Future<String?> uploadImageImgur(UploadImage body) async {
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        body.filePath,
        filename: body.fileName,
      )
    });
    try {
      final response = await imgur.uploadImage(formData: formData);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data['data'];
        String link = data['link'];
        return link;
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw const SocketException('N/A');
      }
      if (e.response?.statusCode != 200 || e.response?.statusCode != 201) {
        throw ServerException('${e.response?.statusCode}');
      }
    }
    return null;
  }
}
