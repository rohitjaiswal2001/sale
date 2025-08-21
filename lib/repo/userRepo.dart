import 'dart:io';
import '../Models/profileModal.dart';
import '../data/network/api_services.dart';
import '../data/network/network_services.dart';
import '../resource/aapurl.dart';
import '../services/session_manager.dart';

class ProfileRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<Map<String, dynamic>> getProfileData() async {
    _apiServices.token = await SharedPreferencesHelper.getToken();

    Map<String, dynamic> response = await _apiServices.getGetApiResponse(
      AppUrl.getProfile,
    );

    return response;
  }

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

  // Future changePasswordfun(String id, data) async {
  //   _apiServices.token = await SharedPreferencesHelper.getToken();
  //   print("Password to be changed of ----$id");
  //   dynamic response = await _apiServices.getPostApiResponse(
  //     AppUrl.changePassword ,
  //     data,
  //   );
  //   return response;
  // }

  // Future<Map<String, dynamic>> editProfileApI(
  //   List<MapEntry<String, String>> fields,
  //   List<MapEntry<String, File>>? files,
  // ) async {
  //   _apiServices.token = await SharedPreferencesHelper.getToken();
  //   print("Token_____${_apiServices.token}");

  //   dynamic response = await _apiServices.multipartPostApiResponseDio(
  //     fields: fields,
  //     files: files,
  //     AppUrl.editprofile,
  //   );
  //   print("Response of Multipart--$response");
  //   return response;
  // }

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
    Map<String, dynamic> response = await _apiServices.getGetApiResponse(
      AppUrl.logout,
    );

    return response;
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, String> mapdata,
  ) async {
    dynamic response = await _apiServices.getPostApiResponse(
      AppUrl.editprofile,
      mapdata,
    );

    return response;
  }

  Future<Map<String, dynamic>> uploadProfilePicture(
    List<MapEntry<String, String>>? fields,
    List<MapEntry<String, File>>? files,
  ) async {
    dynamic response = await _apiServices.multipartPostApiResponseDio(
      fields: fields,
      files: files,
      AppUrl.uploadprofilepicture,
    );
    print("Response of Multipart--$response");
    return response;
  }
}
