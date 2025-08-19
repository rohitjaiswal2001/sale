import 'package:bid4style/Models/profileModal.dart';
import 'package:bid4style/services/session_manager.dart';
import 'package:flutter/material.dart';

class UserDetailViewmodel with ChangeNotifier {
  ProfileModel? profiledata;

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
    } catch (e) {
      print("Error setting profile data: $e");
    }
  }

  void updatePassword(email, password, BuildContext context) {


    
  }



}
