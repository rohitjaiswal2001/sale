import 'dart:io';

abstract class BaseApiServices {
  String? get token;

  set token(String? value);

  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);
  Future<dynamic> multipartPostApiResponseDio(String url,
      {List<MapEntry<String, String>>? fields,
      List<MapEntry<String, File>>? files});

  Future<dynamic> getDeleteApiResponse(String url, dynamic data);
}
