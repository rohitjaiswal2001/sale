import 'dart:io';

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

/// Returns the appropriate ImageProvider for the profile image
  ImageProvider getProfileImageProvider({File? selectedImage}) {
    // Prioritize locally selected image
    if (selectedImage != null && selectedImage.existsSync()) {
      print("Using Selected FileImage: ${selectedImage.path}");
      return FileImage(selectedImage);
    }
    // Check for cached image
    else if (_profileimgPath != null && File(_profileimgPath!).existsSync()) {
      print("Using Cached FileImage: $_profileimgPath");
      return FileImage(File(_profileimgPath!));
    }
    // Use profile URL if available and non-empty
    else if (_profileimgUrl.isNotEmpty && _profileimgUrl != "null") {
      print("Using NetworkImage: $_profileimgUrl");
      return NetworkImage(_profileimgUrl);
    }
    // Fallback to default asset
    else {
      print("Using AssetImage: assets/images/created.png");
      return AssetImage('assets/images/created.png');
    }
  }

  ImageProvider? getProfileImageProviderProfileView({File? selectedImage}) {
    // Prioritize locally selected image
    if (selectedImage != null && selectedImage.existsSync()) {
      print("Using Selected FileImage: ${selectedImage.path}");
      return FileImage(selectedImage);
    }
    // Check for cached image
    else if (_profileimgPath != null && File(_profileimgPath!).existsSync()) {
      print("Using Cached FileImage: $_profileimgPath");
      return FileImage(File(_profileimgPath!));
    }
    // Use profile URL if available and non-empty
    else if (profileimgUrl.isNotEmpty && profileimgUrl != "null") {
      print("Using NetworkImage: $_profileimgUrl");
      return NetworkImage(_profileimgUrl);
    }
    // Fallback to default asset
    else {
      // print("Using AssetImage: assets/images/created.png");
      return null;
      // AssetImage('assets/images/created.png');
    }
  }

  /// Forces a refresh of the cached profile image
  Future<void> refreshProfileImage() async {
    if (_profileimgUrl.isNotEmpty) {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'profile_${_profileimgUrl.hashCode}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print("Cleared cached image for refresh: $filePath");
      }
      await cacheProfileImage(_profileimgUrl);
    }
  }

  // Method to pick an image
  Future<bool> pickImageProfile(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);

      // selectedImage = await cropImage(context, pickedImage.path, false);

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

    
  }



}
