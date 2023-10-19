import 'dart:convert';
import 'package:attendme_app/common/encryptor.dart';
import 'package:attendme_app/common/exception.dart';
import 'package:attendme_app/data/models/attendance_model_check_response.dart';
import 'package:attendme_app/data/models/login_model_response.dart';
import 'package:attendme_app/domain/entities/attendance.dart';
import 'package:attendme_app/domain/entities/login.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

abstract class RemoteDataSource {
  Future<LoginData?> loginUser(Login user);
  Future<AttendanceCheckResponse?> getAttendance(AttendanceCheck check);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Client client;
  RemoteDataSourceImpl({required this.client});
  static String baseUrl = 'https://zwchmtogrdrczgejsfuv.supabase.co/rest/v1';
  static String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp3Y2htdG9ncmRyY3pnZWpzZnV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU0Njg4MDUsImV4cCI6MjAxMTA0NDgwNX0.DW0q1iec8gRjHVRFSaMroxOjYjiQtjoqFCKsB8ZAg0s';

  Future<Response> supabaseAPI(String url) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$url'),
      headers: {"apiKey": apiKey},
    );

    return response;
  }

  @override
  Future<LoginData?> loginUser(Login user) async {
    final email = user.email;
    final password = calculateSHA256(user.password);

    final response = await supabaseAPI(
        'user?select=id,surname,last_name,role,job_desk,image_url,email,company_id&email=eq.$email&password=eq.$password');
    if (response.statusCode == 200) {
      if (response.body != '[]') {
        final jsonData = json.decode(response.body);
        Map<String, dynamic> firstElement = jsonData[0];
        debugPrint('Success RDS $firstElement');
        return LoginData.fromJson(firstElement);
      } else {
        debugPrint('Error RDS');
        return null;
      }
    } else {
      throw ServerException(response.body);
    }
  }

  @override
  Future<AttendanceCheckResponse?> getAttendance(AttendanceCheck check) async {
    final response = await supabaseAPI(
        'attendance?select=*&created_at=eq.now()&company_id=eq.12&user_id=eq.1');
    if (response.statusCode == 200) {
      if (response.body != '[]') {
        final jsonData = json.decode(response.body);
        Map<String, dynamic> firstElement = jsonData[0];
        String status = firstElement['status'];
        String date = firstElement['created_at'];
      }
    } else {
      throw ServerException(response.statusCode.toString());
    }
  }
}
