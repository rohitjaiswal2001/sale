import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../Models/UserModel.dart';
import '../data/network/api_services.dart';
import '../data/network/network_services.dart';
import '../resource/aapurl.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
    print("data root=>$data");
    _apiServices.token = '';
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.login,
      data,
    );

    return response;
  }

  Future forgetpassword(Map<String, dynamic> email) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.forgotPassword,
      email,
    );

    return response;
  }

  Future SignUp(Map<String, dynamic> user) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.signUp,
      user,
    );

    return response;
  }

  Future updatepassword(Map<String, dynamic> data) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.updatepassword,
      data,
    );

    return response;
  }

  Future VerifyOtp(Map<String, dynamic> otpdata) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.verifyOtp,
      otpdata,
    );

    return response;
  }
}
