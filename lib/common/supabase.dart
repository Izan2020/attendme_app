import 'package:dio/dio.dart';

class SupabaseClient {
  final Dio client;
  SupabaseClient({required this.client});

  static String baseUrlSupabase =
      'https://zwchmtogrdrczgejsfuv.supabase.co/rest/v1';
  static String apiKeySupabase =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp3Y2htdG9ncmRyY3pnZWpzZnV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU0Njg4MDUsImV4cCI6MjAxMTA0NDgwNX0.DW0q1iec8gRjHVRFSaMroxOjYjiQtjoqFCKsB8ZAg0s';

  static Options supabaseOptions = Options(
    headers: {
      "apikey": apiKeySupabase,
      "Authorization": "Bearer $apiKeySupabase",
    },
  );

  Future<Response<dynamic>> get(
    String url,
  ) async =>
      await client.get(
        '$baseUrlSupabase/$url',
        options: supabaseOptions,
      );

  Future<Response> patch(
    String url, {
    required Map<String, dynamic> body,
  }) async =>
      await client.patch(
        '$baseUrlSupabase/$url',
        data: body,
        options: supabaseOptions,
      );

  Future<Response> post(
    String url, {
    required Map<String, dynamic> body,
  }) async =>
      await client.post(
        '$baseUrlSupabase/$url',
        data: body,
        options: supabaseOptions,
      );
}
