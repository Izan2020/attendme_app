import 'package:attendme_app/common/encryptor.dart';
import 'package:attendme_app/common/exception.dart';
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

  Future<String> uploadImageImgur(UploadImage body);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio client;

  RemoteDataSourceImpl({
    required this.client,
  });
  static String baseUrlSupabase =
      'https://zwchmtogrdrczgejsfuv.supabase.co/rest/v1';
  static String apiKeySupabase =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp3Y2htdG9ncmRyY3pnZWpzZnV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU0Njg4MDUsImV4cCI6MjAxMTA0NDgwNX0.DW0q1iec8gRjHVRFSaMroxOjYjiQtjoqFCKsB8ZAg0s';

  static String baseUrlImgur = 'https://api.imgur.com/3';
  static String clientIdImgur = '9582aa03bf58baa';

  static Options supabaseOptions = Options(
    headers: {
      "apikey": apiKeySupabase,
      "Authorization": "Bearer $apiKeySupabase",
    },
  );
  static Options imgurOptions = Options(
    headers: {"Authorization": 'Client-ID $clientIdImgur'},
  );

  Future<Response<dynamic>> supabaseGet(String url) async {
    final response = await client.get(
      '$baseUrlSupabase/$url',
      options: supabaseOptions,
    );
    return response;
  }

  Future<Response> supabasePatch({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await client.patch(
      '$baseUrlSupabase/$url',
      data: body,
      options: supabaseOptions,
    );
    return response;
  }

  Future<Response> supabasePost({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final response = await client.post(
      '$baseUrlSupabase/$url',
      data: body,
      options: supabaseOptions,
    );
    return response;
  }

  @override
  Future<LoginData?> loginUser(Login user) async {
    final email = user.email;
    final password = calculateSHA256(user.password);

    final request = await supabaseGet(
        'user?select=id,surname,last_name,role,job_desk,image_url,email,company_id&email=eq.$email&password=eq.$password');
    if (request.statusCode == 200) {
      List<dynamic> response = request.data;
      if (response.isNotEmpty) {
        return LoginData.fromJson(response[0]);
      } else {
        debugPrint('Error RDS');
        return null;
      }
    } else {
      throw ServerException('${request.statusCode}');
    }
  }

  @override
  Future<AttendanceCheckResponse?> getAttendance(
      CheckAttendanceParams check) async {
    final request = await supabaseGet(
        'attendance?select=*&created_at=eq.${check.date}&company_id=eq.${check.companyId}&user_id=eq.${check.userId}');

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
      } else if (paramsDate.isBefore(currentDate) || request.data == '[]') {
        return const AttendanceCheckResponse(status: 'un-attended');
      }
    } else {
      throw ServerException('${request.statusCode}');
    }
    return null;
  }

  @override
  Future<bool> updateCheckOut(int attendanceId) async {
    final checkOutBody = {"status": "checked-out"};

    final response = await supabasePatch(
        url: 'attendance?status=eq.$attendanceId', body: checkOutBody);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException('${response.statusCode}');
    }
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

    final response = await supabasePost(
      url: 'attendance',
      body: attendanceBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw ServerException('${response.statusMessage}');
    }
  }

  @override
  Future<String> uploadImageImgur(UploadImage body) async {
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        body.filePath,
        filename: body.fileName,
      )
    });
    final response = await client.post(
      '$baseUrlImgur/upload',
      data: formData,
      options: imgurOptions,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data['data'];
      String link = data['link'];
      return link;
    } else {
      throw ServerException('${response.statusCode}');
    }
  }
}
