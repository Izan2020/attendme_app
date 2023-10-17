import 'dart:convert';
import 'dart:io';

import 'package:attendme_app/common/encryptor.dart';
import 'package:attendme_app/common/exception.dart';
import 'package:attendme_app/domain/entities/login.dart';

abstract class RemoteDataSource {
  Future<String> loginUser(Login user);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final HttpClient client;
  RemoteDataSourceImpl({required this.client});

  static String baseUrl = 'https://zwchmtogrdrczgejsfuv.supabase.co/rest/v1/';
  static String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp3Y2htdG9ncmRyY3pnZWpzZnV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU0Njg4MDUsImV4cCI6MjAxMTA0NDgwNX0.DW0q1iec8gRjHVRFSaMroxOjYjiQtjoqFCKsB8ZAg0s';

  Future<HttpClientResponse> supabaseAPI(String url) async {
    final request = await client.getUrl(Uri.parse('$baseUrl/$url'));
    request.headers.add('apikey', apiKey);
    final response = await request.close();
    return response;
  }

  @override
  Future<String> loginUser(Login user) async {
    final email = user.email;
    final password = calculateSHA256(user.password);

    final response = await supabaseAPI(
        'user?select=id&email=eq.$email&password=eq.$password');
    if (response.statusCode == 200) {
      final body = await response.transform(Utf8Decoder()).join();
      if (body.isNotEmpty) {
        return 'Logged In';
      } else {
        return 'Check your Email or Password!';
      }
    } else {
      throw ServerException();
    }
  }
}
