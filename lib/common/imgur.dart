import 'package:dio/dio.dart';

class ImgurClient {
  final Dio client;
  ImgurClient({required this.client});

  static String baseUrlImgur = 'https://api.imgur.com/3';
  static String clientIdImgur = '9582aa03bf58baa';
  static Options imgurOptions = Options(
    headers: {"Authorization": 'Client-ID $clientIdImgur'},
  );

  Future<Response<dynamic>> uploadImage({
    required FormData formData,
  }) async =>
      await client.post(
        '$baseUrlImgur/upload',
        data: formData,
        options: imgurOptions,
      );
}
