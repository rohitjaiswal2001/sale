// import 'dart:io';
// import 'package:bid4style/Models/profileModal.dart';
// import 'package:bid4style/resource/aapurl.dart';
// import 'package:bid4style/services/session_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserDetailViewmodel with ChangeNotifier {
//   ProfileModel? profiledata;
//   String? _profileimgPath;
//   String _profileimgUrl = "";
//   // File? selectedImage;

//   setProfileData(Map<String, dynamic> data) {
//     try {
//       if (data['data'] != null) {
//         profiledata = ProfileModel.fromJson(data);
//         SharedPreferencesHelper.saveUserToPrefs(profiledata!);

//         print("Profile data setted succesfully");
//         notifyListeners();
//       } else {
//         print("Invalid profile data received: $data");
//       }
//     } catch (e) {
//       print("Error setting profile data: $e");
//     }
//   }

//   clearProfileData() {
//     profiledata = null;
//     notifyListeners();
//   }

//   void loadProfile() async {
//     try {
//       profiledata = await SharedPreferencesHelper.getUserFromPrefs();

//       print("Picture-----${profiledata?.data?.profilePic}");
//     } catch (e) {
//       print("Error setting profile data: $e");
//     }
//   }

//   ImageProvider getProfileImageProvider() {
//     final imageUrl = profiledata?.data?.profilePic ?? '';
//     if (imageUrl.isNotEmpty && imageUrl != "null") {
//       print("imgurl---$imageUrl");

//       String? profileimagefromURL = "";
//       profileimagefromURL = AppUrl.baseUrl + imageUrl;

//       print("PROFILEimgurl---$profileimagefromURL");

//       return NetworkImage(profileimagefromURL!);
//     } else {
//       return const AssetImage('assets/images/created.png');
//     }
//   }
// }

import 'dart:io';

import 'package:bid4style/Models/profileModal.dart';
import 'package:bid4style/resource/aapurl.dart';
import 'package:bid4style/services/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UserDetailViewmodel with ChangeNotifier {
  ProfileModel? profiledata;
  String? _profileimgPath;
  String _profileimgUrl = "";

  String? get profileimgPath => _profileimgPath;
  String get profileimgUrl => _profileimgUrl;

  set profileimgUrl(String value) {
    _profileimgUrl = value;
    notifyListeners();
  }

  // --- Save profile data (after login / update)
  setProfileData(Map<String, dynamic> data) {
    try {
      if (data['data'] != null) {
        profiledata = ProfileModel.fromJson(data);
        SharedPreferencesHelper.saveUserToPrefs(profiledata!);

        // set profile pic url
        _profileimgUrl = AppUrl.baseUrl + (profiledata?.data?.profilePic ?? '');

        // cache image immediately
        cacheProfileImage(_profileimgUrl);

        print("Profile data set successfully");
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
    _profileimgUrl = "";
    _profileimgPath = null;
    notifyListeners();
  }

  void loadProfile() async {
    try {
      profiledata = await SharedPreferencesHelper.getUserFromPrefs();
      if (profiledata?.data?.profilePic != null) {
        _profileimgUrl = AppUrl.baseUrl + (profiledata?.data?.profilePic ?? '');
        await cacheProfileImage(_profileimgUrl);
      }
      print("Picture-----${profiledata?.data?.profilePic}");
    } catch (e) {
      print("Error setting profile data: $e");
    } finally {
      notifyListeners();
    }
  }

  // --- Cache Image ---
  Future<String?> cacheProfileImage(String imageUrl) async {
    if (imageUrl.isEmpty) return null;
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'profile_${imageUrl.hashCode}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        _profileimgPath = filePath;
        notifyListeners(); // <-- Add this
        return filePath;
      }

      await clearOldCachedImages(tempDir, fileName);

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        _profileimgPath = filePath;
        notifyListeners(); // <-- Add this
        return filePath;
      } else {
        print("Failed to download image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error caching profile image: $e");
      return null;
    }
  }

  Future<void> clearOldCachedImages(
    Directory tempDir,
    String currentFileName,
  ) async {
    try {
      final files = tempDir.listSync();
      for (var file in files) {
        if (file is File &&
            file.path.contains('profile_') &&
            !file.path.endsWith(currentFileName)) {
          await file.delete();
        }
      }
    } catch (e) {
      print("Error clearing old cached images: $e");
    }
  }

  Future<void> clearCachedProfileImage() async {
    if (_profileimgPath != null) {
      try {
        final file = File(_profileimgPath!);
        if (await file.exists()) await file.delete();
        _profileimgPath = null;
      } catch (e) {
        print("Error deleting cached profile image: $e");
      } finally {
        notifyListeners();
      }
    }
  }

  // --- Image Provider ---
  ImageProvider getProfileImageProvider() {
    if (_profileimgPath != null && File(_profileimgPath!).existsSync()) {
      notifyListeners();
      return FileImage(File(_profileimgPath!));
    } else if (_profileimgUrl.isNotEmpty && _profileimgUrl != "null") {
      notifyListeners();
      return NetworkImage(_profileimgUrl);
    } else {
      return const AssetImage('assets/images/created.png');
    }
  }
}
