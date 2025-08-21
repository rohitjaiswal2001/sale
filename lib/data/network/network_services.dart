import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bid4style/data/exceptions.dart';
import 'package:bid4style/data/network/api_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkApiService implements BaseApiServices {
  @override
  String? token; // Token for authorization

  NetworkApiService({this.token});

  // Method for GET requests
  @override
  Future<dynamic> getGetApiResponse(String url) async {
    if (kDebugMode) {
      print("GET URL: $url");
      print("Token====$token");
    }

    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse(url), headers: _getHeaders())
          .timeout(const Duration(seconds: 60));
      responseJson = handleResponse(response);
      print("Response--get -${jsonEncode(responseJson)}");
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timeout');
    }

    return responseJson;
  }

  // Method for POST requests
  @override
  Future<dynamic> getPostApiResponse(String url, dynamic bodyData) async {
    if (kDebugMode) {
      print("Token====$token");
      print("POST URL: $url");
      print("Body Data: ${jsonEncode(bodyData)}");
    }

    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: _getHeaders(),
            body: jsonEncode(bodyData),
          )
          .timeout(const Duration(seconds: 60));

      responseJson = handleResponse(response);

      print("Response--post -${jsonEncode(responseJson)}");
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timeout');
    }

    return responseJson;
  }

  // Method for POST requests
  @override
  Future<dynamic> getDeleteApiResponse(String url, dynamic bodyData) async {
    if (kDebugMode) {
      print("Token====$token");
      print("POST URL: $url");
      print("Body Data: ${jsonEncode(bodyData)}");
    }

    dynamic responseJson;
    try {
      final response = await http
          .delete(
            Uri.parse(url),
            headers: _getHeaders(),
            body: jsonEncode(bodyData),
          )
          .timeout(const Duration(seconds: 60));

      responseJson = handleResponse(response);

      print("Response--post -${jsonEncode(responseJson)}");
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timeout');
    }

    return responseJson;
  }

  // Method for PUT requests
  Future<dynamic> putApiResponse(String url, dynamic bodyData) async {
    if (kDebugMode) {
      print("PUT URL: $url");
      print("Body Data: ${jsonEncode(bodyData)}");
    }

    dynamic responseJson;
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: _getHeaders(),
            body: jsonEncode(bodyData),
          )
          .timeout(const Duration(seconds: 60));

      responseJson = handleResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timeout');
    }

    return responseJson;
  }

  // Method for PATCH requests
  Future<dynamic> patchApiResponse(String url, dynamic bodyData) async {
    if (kDebugMode) {
      print("PATCH URL: $url");
      print("Body Data: ${jsonEncode(bodyData)}");
    }

    dynamic responseJson;
    try {
      final response = await http
          .patch(
            Uri.parse(url),
            headers: _getHeaders(),
            body: jsonEncode(bodyData),
          )
          .timeout(const Duration(seconds: 60));

      responseJson = handleResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timeout');
    }

    return responseJson;
  }

  Future<dynamic> multipartPostApiResponseDio(
    String url, {
    List<MapEntry<String, String>>? fields,
    List<MapEntry<String, File>>? files,
  }) async {
    if (kDebugMode) {
      print("Multipart POST URL: $url");
    }

    dynamic responseJson;

    try {
      Dio dio = Dio();
      FormData formData = FormData();

      if (fields != null && fields.isNotEmpty) {
        formData.fields.addAll(fields);
      }

      if (files != null && files.isNotEmpty) {
        for (var entry in files) {
          String key = entry.key;
          File file = entry.value;
          MultipartFile multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: file.uri.pathSegments.last,
          );
          formData.files.add(MapEntry(key, multipartFile));
        }
      }

      Map<String, String> headers = {
        'Accept': 'application/json',
        'user-agent': 'Dart/3.6 (dart:io)',
        'accept-encoding': 'gzip',
        'Content-Type': 'multipart/form-data',
        if (token != null && token!.isNotEmpty) 'x-access-token': '$token',
      };

      if (kDebugMode) {
        formData.fields.forEach((f) {
          print("Field => key: ${f.key}, value: ${f.value}");
        });

        formData.files.forEach((f) {
          print("File => field: ${f.key}, filename: ${f.value.filename}");
        });
      }

      Response response = await dio.post(
        url,
        data: formData,
        options: Options(headers: headers, contentType: 'multipart/form-data'),
      );

      responseJson = handleResponse(response);
    } on DioException catch (e) {
      print("Error----$e");
      if (e.response != null) {
        print("Server response status: ${e.response?.statusCode}");
        print("Server response data: ${e.response?.data}");
      } else {
        print("No response received from server");
      }
      rethrow; // Rethrow to let the caller handle it
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timeout');
    }

    return responseJson;
  }

  //     responseJson = _returnResponse(response as http.Response);
  //     return responseJson;
  //   } on SocketException {
  //     throw NoInternetException('No Internet Connection');
  //   } on TimeoutException {
  //     throw FetchDataException('Request Timeout');
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error uploading files: $e');
  //     }
  //     return null; // Return null on error
  //   }
  // }

  //New Multipostusing Http
  // Future<dynamic> multipartPostApiResponse(
  //   String url, {
  //   Map<String, String>? fields,
  //   List<http.MultipartFile>? files,
  // }) async {
  //   if (kDebugMode) {
  //     print("Multipart POST URL: $url");
  //   }

  //   dynamic responseJson;
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //     request.headers.addAll(_getHeaders());
  //     if (fields != null) request.fields.addAll(fields);
  //     if (files != null) request.files.addAll(files);

  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString();

  //     if (response.statusCode >= 400) {
  //       throw Exception('Failed to upload files: $responseBody');
  //     }

  //     responseJson = jsonDecode(responseBody);
  //   } on SocketException {
  //     throw NoInternetException('No Internet Connection');
  //   } on TimeoutException {
  //     throw FetchDataException('Request Timeout');
  //   }

  //   return responseJson;
  // }

  // Private method to get common headers
  Map<String, String> _getHeaders() {
    return {
      'Accept': 'application/json',
      if (token != null && token!.isNotEmpty) 'x-access-token': '$token',
      'Content-Type': 'application/json',
    };
  }

  // // Private method to handle responses
  // dynamic _returnResponse(http.Response response) {
  //   if (kDebugMode) {
  //     print("Status Code: ${response.statusCode}");
  //   }

  //   switch (response.statusCode) {
  //     case 200:
  //       return jsonDecode(response.body);
  //     case 400:
  //       Map<String, dynamic> errorResponse = jsonDecode(response.body);

  //       throw UnauthorisedException(errorResponse['error']);
  //     case 401:
  //       Map<String, dynamic> errorResponse = jsonDecode(response.body);

  //       throw UnauthorisedException(errorResponse['error']);

  //     case 500:
  //       Map<String, dynamic> errorResponse = jsonDecode(response.body);
  //       if (errorResponse['error'] != null) {
  //         throw UnauthorisedException(errorResponse['error']);
  //       } else {
  //         throw InvalidInputException("Invalid Input");
  //       }
  //     case 422:
  //       Map<String, dynamic> errorResponse = jsonDecode(response.body);

  //       if (errorResponse['error'] != null) {
  //         throw UnauthorisedException(errorResponse['error']);
  //       } else {
  //         throw UnauthorisedException(response.body.toString());
  //       }
  //     case 404:
  //       Map<String, dynamic> errorResponse = jsonDecode(response.body);
  //       throw UnauthorisedException(errorResponse['error']);

  //     default:
  //       throw FetchDataException('Error communicating with server');
  //   }
  // }

  dynamic handleResponse(dynamic response) {
    int statusCode;
    dynamic data;

    if (response is http.Response) {
      statusCode = response.statusCode;
      data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else if (response is Response) {
      // dio.Response
      statusCode = response.statusCode ?? 0;

      if (response.data is String) {
        try {
          data = jsonDecode(response.data);
        } catch (_) {
          data = response.data;
        }
      } else {
        data = response.data;
      }
    } else {
      throw FetchDataException("Unsupported response type");
    }

    if (kDebugMode) {
      print("Status Code: $statusCode");
      print("Response Data: $data");
    }

    switch (statusCode) {
      case 200:
      case 201:
        return data;
      case 400:
        throw UnauthorisedException(data['error'] ?? data.toString());
      case 401:
        throw UnauthorisedException(data['error'] ?? data.toString());
      case 422:
        throw UnauthorisedException(data['error'] ?? data.toString());
      case 404:
        throw UnauthorisedException(data['error'] ?? "Not Found");
      case 500:
        if (data != null && data is Map && data['error'] != null) {
          throw UnauthorisedException(data['error']);
        } else {
          throw InvalidInputException("Invalid Input");
        }
      default:
        throw FetchDataException("Error communicating with server");
    }
  }

  //For Dio

  // dynamic _returnResponseDio(Response response) {
  //   if (kDebugMode) {
  //     print("All multipart data----${response.data}");
  //     print("Status Code: ${response.statusCode}");
  //   }
  //   switch (response.statusCode) {
  //     case 200:
  //       // Check if response.data is a Map
  //       if (response.data is Map<String, dynamic>) {
  //         return response.data; // Directly return it as it's already parsed
  //       }
  //       // If it's a string, parse it as JSON
  //       return jsonDecode(response.data);
  //     case 400:
  //       throw UnauthorisedException(response.data);
  //     // throw BadRequestException(response.data.toString());
  //     case 401:
  //       final errorResponse = response.data is String
  //           ? jsonDecode(response.data)
  //           : response.data as Map<String, dynamic>;

  //       if (errorResponse['data'] != null &&
  //           errorResponse['data']['otp'] != null) {
  //         return throw UnauthorisedException(
  //           errorResponse['data']['errors'] ?? errorResponse['data']['message'],
  //         );
  //       }
  //       if (errorResponse['data'] != null &&
  //           errorResponse['data']['message'] != null) {
  //         throw UnauthorisedException(errorResponse['data']['message']);
  //       }
  //       throw UnauthorisedException(response.data.toString());
  //     case 422:
  //       final errorResponse = response.data is String
  //           ? jsonDecode(response.data)
  //           : response.data as Map<String, dynamic>;

  //       if (errorResponse['data'] != null &&
  //           errorResponse['data']['errors'] != null) {
  //         throw UnauthorisedException(errorResponse['data']['errors']);
  //       }
  //       if (errorResponse['message'] != null) {
  //         throw UnauthorisedException(errorResponse['message']);
  //       }
  //       throw UnauthorisedException(response.data.toString());
  //     case 500:
  //       throw InvalidInputException("Invalid Input");
  //     case 404:
  //       final errorResponse = response.data is String
  //           ? jsonDecode(response.data)
  //           : response.data as Map<String, dynamic>;

  //       throw UnauthorisedException(
  //         errorResponse['data'] != null &&
  //                 errorResponse['data'].containsKey("error")
  //             ? errorResponse['data']['error']
  //             : response.data.toString(),
  //       );
  //     default:
  //       throw FetchDataException('Error communicating with server');
  //   }
  // }
}
