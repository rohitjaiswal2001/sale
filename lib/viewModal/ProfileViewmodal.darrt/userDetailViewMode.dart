import 'dart:io';
import 'package:bid4style/Models/profileModal.dart';
import 'package:bid4style/resource/aapurl.dart';
import 'package:bid4style/services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailViewmodel with ChangeNotifier {
  ProfileModel? profiledata;
  String? _profileimgPath;
  String _profileimgUrl = "";
  // File? selectedImage;

  setProfileData(Map<String, dynamic> data) {
    try {
      if (data['data'] != null) {
        profiledata = ProfileModel.fromJson(data);
        SharedPreferencesHelper.saveUserToPrefs(profiledata!);

        print("Profile data setted succesfully");
        notifyListeners();
      } else {
        print("Invalid profile data received: $data");
      }
    } catch (e) {
      print("Error setting profile data: $e");
    }
  }

  clearProfileData() {
    profiledata = null;
    notifyListeners();
  }

  void loadProfile() async {
    try {
      profiledata = await SharedPreferencesHelper.getUserFromPrefs();

      print("Picture-----${profiledata?.data?.profilePic}");
    } catch (e) {
      print("Error setting profile data: $e");
    }
  }

  ImageProvider getProfileImageProvider() {
    final imageUrl = profiledata?.data?.profilePic ?? '';
    if (imageUrl.isNotEmpty && imageUrl != "null") {
      print("imgurl---$imageUrl");

      String? profileimagefromURL = "";
      profileimagefromURL = AppUrl.baseUrl + imageUrl;

      print("PROFILEimgurl---$profileimagefromURL");

      return NetworkImage(profileimagefromURL!);
    } else {
      return const AssetImage('assets/images/created.png');
    }
  }
}
