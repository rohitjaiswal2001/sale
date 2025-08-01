import 'dart:io';

import '../Models/UserDetailModal.dart';
import '../data/network/api_services.dart';
import '../data/network/network_services.dart';
import '../resource/aapurl.dart';
import '../services/session_manager.dart';

class ProfileRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  Future<Map<String, dynamic>> userdetail() async {
    _apiServices.token = await SharedPreferencesHelper.getToken();
    print("User__Detail TOKEN---${_apiServices.token}");
    Map<String, dynamic> response = await _apiServices.getGetApiResponse(
      AppUrl.Userdetail,
    );

    return response;
  }

  // Future storageApi()async{

  //  _apiServices.token = await SharedPreferencesHelper.getToken();
  //     print("User__Detail TOKEN---${_apiServices.token}");
  //     Map<String, dynamic> response =
  //         await _apiServices.getGetApiResponse(AppUrl.storage);
  // return response;

  // }
  Future deleteAccount(String id) async {
    _apiServices.token = await SharedPreferencesHelper.getToken();
    print("User Id to be deleted is ----$id");
    Map<String, dynamic> data = {};
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.deleteUser + id,
      data,
    );

    return response;
  }

  Future<Map<String, dynamic>> removeprofilepic() async {
    _apiServices.token = await SharedPreferencesHelper.getToken();
    print("Removepic  TOKEN---${_apiServices.token}");
    Map<String, dynamic> response = await _apiServices.getGetApiResponse(
      AppUrl.removepic,
    );

    return response;
  }

  Future changePasswordfun(String id, data) async {
    _apiServices.token = await SharedPreferencesHelper.getToken();
    print("Password to be changed of ----$id");
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.changePassword + id,
      data,
    );

    return response;
  }

  Future<Map<String, dynamic>> editProfileApI(
    List<MapEntry<String, String>> fields,
    List<MapEntry<String, File>>? files,
  ) async {
    _apiServices.token = await SharedPreferencesHelper.getToken();
    print("Token_____${_apiServices.token}");

    dynamic response = await _apiServices.multipartPostApiResponseDio(
      fields: fields,
      files: files,
      AppUrl.editprofile,
    );
    print("Response of Multipart--$response");
    return response;
  }

  Future updatefcmtoken(String fcmtoken) async {
    _apiServices.token = await SharedPreferencesHelper.getToken();

    Map<String, dynamic> data = {'fcm_token': fcmtoken.trim()};

    print("FCM token for API ----$fcmtoken");

    if (fcmtoken.isNotEmpty || fcmtoken != null) {
      dynamic response = await _apiServices.getPostApiResponse(
        AppUrl.updatefcm,
        data,
      );

      return response;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    _apiServices.token = await SharedPreferencesHelper.getToken();
    print("User__Detail TOKEN---${_apiServices.token}");
    Map<String, dynamic> response = await _apiServices.getPostApiResponse(
      AppUrl.logout,
      {},
    );

    return response;
  }
}
