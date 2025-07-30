import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bid4style/Models/UserDetailModal.dart';
import 'package:bid4style/Models/choosePlanModal.dart';
import 'package:bid4style/utils/Helper.dart';
import 'package:bid4style/view/FirstPage.dart';
import 'package:bid4style/viewModal/AuthviewModel/SignupViewModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../Utils/Appcolor.dart';
import '../../repo/userRepo.dart';
import '../../services/session_manager.dart';


class Userdetailviewmodel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final oldpasswordController = TextEditingController();
  final newpasswordController = TextEditingController();
  final cnfnewpasswordController = TextEditingController();

  // Focus
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  ChoosePlanModal? choosePlanDataUserDetail;
  UserDetailModal? usrdata;
  String _drawername = "";
  String _draweremail = "";
  String _userPlanName = "";
  String _userPlanTierid = "";
  String _userPlanPrice = "";
  String _userPlanStorage = "";
  String _userId = "";
  String _profileimgUrl = "";
  String? _profileimgPath;
  String _subscriptionstatus = '';
  String _userPlanImage = '';
  String _userPlanPauseprice = "";
  String _fcmtoken = "";
  bool _isLogoutLoading = false;
  bool _isProfileImageLoading = false;

  String get profileimgUrl => _profileimgUrl;

  set profileimgUrl(String value) {
    _profileimgUrl = value;
    notifyListeners();
  }

  bool get isLogoutLoading => _isLogoutLoading;

  set isLogoutLoading(bool value) {
    _isLogoutLoading = value;
    notifyListeners();
  }

  bool get isProfileImageLoading => _isProfileImageLoading;

  set isProfileImageLoading(bool value) {
    _isProfileImageLoading = value;
    notifyListeners();
  }

  String? get profileimgPath => _profileimgPath;

  set profileimgPath(String? value) {
    _profileimgPath = value;
    notifyListeners();
  }

  Userdetailviewmodel() {
    _isLogoutLoading = false;
    _loadInitialData();
  }

  void resetLogoutState() {
    _isLogoutLoading = false;
    notifyListeners();
  }

  /// Downloads the profile image from the URL, caches it, and returns the local file path
  Future<String?> cacheProfileImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      print("Profile image URL is empty");
      return null;
    }

    try {
      isProfileImageLoading = true;
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      // Create a unique filename based on the URL or user ID
      final fileName = 'profile_${userId}_${imageUrl.hashCode}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);

      // Check if the image is already cached
      if (await file.exists()) {
        print("Using cached profile image: $filePath");
        return filePath;
      }

      // Clear old cached images for this user
      await clearOldCachedImages(tempDir, userId, fileName);

      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Save the image to the cache
        await file.writeAsBytes(response.bodyBytes);
        print("Profile image cached: $filePath");
        return filePath;
      } else {
        print("Failed to download image: ${response.statusCode}");
        // Helper.toastMessage(
        //     message: 'Failed to download profile image', color: AppColors.red);
        return null;
      }
    } catch (e) {
      print("Error caching profile image: $e");
      Helper.toastMessage(
          message: 'Error downloading profile image', color: AppColors.red);
      return null;
    } finally {
      isProfileImageLoading = false;
      notifyListeners();
    }
  }

  /// Clears old cached profile images for the user
  Future<void> clearOldCachedImages(
      Directory tempDir, String userId, String currentFileName) async {
    try {
      final files = tempDir.listSync();
      for (var file in files) {
        if (file is File &&
            file.path.contains('profile_${userId}_') &&
            file.path != '${tempDir.path}/$currentFileName') {
          await file.delete();
          print("Deleted old cached image: ${file.path}");
        }
      }
    } catch (e) {
      print("Error clearing old cached images: $e");
    }
  }

  /// Clears the cached profile image
  Future<void> clearCachedProfileImage() async {
    if (_profileimgPath != null) {
      try {
        final file = File(_profileimgPath!);
        if (await file.exists()) {
          await file.delete();
          print("Cached profile image deleted: $_profileimgPath");
        }
        _profileimgPath = null;
        notifyListeners();
      } catch (e) {
        print("Error deleting cached profile image: $e");
      }
    }
  }

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
      final fileName = 'profile_${userId}_${_profileimgUrl.hashCode}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print("Cleared cached image for refresh: $filePath");
      }
      await cacheProfileImage(_profileimgUrl);
    }
  }

  /// Function to clear app data and logout
  Future<bool> AppDataLogout(BuildContext context) async {
    if (isLogoutLoading) return false;

    try {
      isLogoutLoading = true;
      final response = await ProfileRepository().logout();
      print("Logout API response: $response");

      if (response['status'] == true) {
        print("API logout successful, clearing data...");


        await clearCachedProfileImage();
        await SharedPreferencesHelper.clearAllData();

        if (context.mounted) {
          Helper.toastMessage(
              message: response['message'] ?? 'Logged out successfully',
              color: AppColors.themecolor);
        }
        return true;
      } else {
        print("API logout failed");
        if (context.mounted) {
          Helper.toastMessage(
              message: response['message'] ?? 'Something went wrong',
              color: AppColors.red);
        }
        return false;
      }
    } catch (e) {
      print("Error during logout: $e");
      if (context.mounted) {
        Helper.toastMessage(
            message: 'Error during logout', color: AppColors.red);
      }
      return false;
    } finally {
      await SharedPreferencesHelper.clearAllData();
      clearCachedProfileImage();

      SignupViewModel().clearController();

      drawername = "";
      draweremail = "";
      userPlanName = "";
      userPlanTierid = "";
      userPlanPrice = "";
      userPlanStorage = "";
      userId = "";
      _profileimgUrl = "";
      profileimgPath;
      subscriptionstatus = '';
      userPlanImage = '';
      userPlanPauseprice = "";
      fcmtoken = "";
      resetLogoutState();
    }
  }

  String get fcmtoken => _fcmtoken;

  set fcmtoken(String value) {
    _fcmtoken = value;
    notifyListeners();
  }

  int _isJournal = 0;

  int get isJournal => _isJournal;

  set isJournal(int value) {
    _isJournal = value;
    notifyListeners();
  }

  String get subscriptionstatus => _subscriptionstatus;

  set subscriptionstatus(String value) {
    _subscriptionstatus = value;
    notifyListeners();
  }

  String formatDatesubscription(String? date) {
    if (date == null || date.isEmpty) {
      return "";
    }
    try {
      return DateFormat('MM/dd/yyyy').format(DateTime.parse(date));
    } catch (e) {
      return "";
    }
  }

  String get userPlanPauseprice => _userPlanPauseprice;

  set userPlanPauseprice(String value) {
    _userPlanPauseprice = value;
    notifyListeners();
  }

  String _planexp = "";

  String get planexp => _planexp;

  set planexp(String value) {
    _planexp = value;
    notifyListeners();
  }

  String get userPlanImage => _userPlanImage;

  set userPlanImage(String value) {
    _userPlanImage = value;
    notifyListeners();
  }

  String? _userPlanDuration;

  String? get userPlanDuration => _userPlanDuration;

  set userPlanDuration(String? value) {
    _userPlanDuration = value;
    notifyListeners();
  }

  String get userPlanPrice => _userPlanPrice;

  set userPlanPrice(String value) {
    _userPlanPrice = value;
    notifyListeners();
  }

  String get userPlanStorage => _userPlanStorage;

  set userPlanStorage(String value) {
    _userPlanStorage = value;
    notifyListeners();
  }

  String get profileimg => _profileimgUrl;

  set profileimg(String value) {
    _profileimgUrl = value;
    cacheProfileImage(value).then((path) {
      _profileimgPath = path;
      notifyListeners();
    });
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String get drawername => _drawername;

  set drawername(String value) {
    _drawername = value;
    notifyListeners();
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  String get draweremail => _draweremail;

  set draweremail(String value) {
    _draweremail = value;
    notifyListeners();
  }

  set userPlanName(String value) {
    _userPlanName = value;
    notifyListeners();
  }

  String get userPlanName => _userPlanName;

  set userPlanTierid(String value) {
    _userPlanTierid = value;
    notifyListeners();
  }

  String get userPlanTierid => _userPlanTierid;

  String? _zipurl;

  String? get zipurl => _zipurl;

  set zipurl(String? value) {
    _zipurl = value;
    notifyListeners();
  }

  String? _zipStatus;

  String? get zipStatus => _zipStatus;

  set zipStatus(String? value) {
    _zipStatus = value;
    notifyListeners();
  }

  String? _zip_backup_expired_at;

  String? get zip_backup_expired_at => _zip_backup_expired_at;

  set zip_backup_expired_at(String? value) {
    _zip_backup_expired_at = value;
    notifyListeners();
  }

  Future<void> _loadInitialData() async {
    try {
      usrdata = await SharedPreferencesHelper.getUserFromPrefs();
      if (usrdata != null) {
        drawername = usrdata?.data?.user?.name ?? "";
        draweremail = usrdata?.data?.user?.email ?? "";
        userId = usrdata?.data?.user?.id?.toString() ?? "";
        profileimg = usrdata?.data?.user?.profileImage ?? "";
        isJournal = usrdata?.data?.isjournal ?? 0;
        userPlanTierid =
            usrdata?.data?.user?.userSubscription?.id?.toString() ?? "";
        planexp = (usrdata?.data?.user?.userSubscription!.endDate).toString();
        zipStatus = usrdata?.data?.user?.zipBackupStatus ?? "";
        zipurl = usrdata?.data?.user?.zipBackupUrl ?? "";
        zip_backup_expired_at = usrdata?.data?.user?.zipBackupExpiredAt ?? "";
        subscriptionstatus = (usrdata?.data?.user?.userSubscription == null
                ? '2'
                : usrdata?.data?.user?.userSubscription?.status ?? "0")
            .toString();
      }
    } catch (e) {
      print("Error loading initial data: $e");
    } finally {
      notifyListeners();
    }
  }
Future<void> getUserDetail() async {
  try {
    // Load from SharedPreferences first
    usrdata = await SharedPreferencesHelper.getUserFromPrefs();

    if (usrdata != null) {
      print("_________tttttt___userdetail------");

      final user = usrdata?.data?.user;
      final subscription = user?.userSubscription;

      drawername = user?.name ?? drawername;
      draweremail = user?.email ?? draweremail;
      userId = user?.id?.toString() ?? userId;
      profileimg = user?.profileImage ?? profileimg;
      isJournal = usrdata?.data?.isjournal ?? isJournal;
      userPlanTierid = subscription?.id?.toString() ?? userPlanTierid;
      planexp = subscription?.endDate?.toString() ?? planexp;
      subscriptionstatus = (subscription?.status ?? '2').toString();

      print("ZipStatus-1--- $zipStatus--1-- ZipUrl ---1---$zipurl");
    }

    // Fetch fresh user detail from API
    final response = await ProfileRepository().userdetail();
    usrdata = UserDetailModal.fromJson(response);

    if (usrdata?.status == true) {
      final user = usrdata?.data?.user;
      final subscription = user?.userSubscription;

      drawername = user?.name ?? drawername;
      draweremail = user?.email ?? draweremail;
      userId = user?.id?.toString() ?? userId;

      profileimg = (user?.profileImage?.isNotEmpty ?? false)
          ? user!.profileImage!
          : profileimg;

      isJournal = usrdata?.data?.isjournal ?? isJournal;
      userPlanTierid = subscription?.id?.toString() ?? userPlanTierid;
      planexp = subscription?.endDate?.toString() ?? planexp;
      zipStatus = user?.zipBackupStatus ;
      zipurl = user?.zipBackupUrl ;
      zip_backup_expired_at = user?.zipBackupExpiredAt;
      subscriptionstatus = (subscription?.status ?? '2').toString();

      print("ZipStatus-2--- $zipStatus--2-- ZipUrl ---2---$zipurl");

      await SharedPreferencesHelper.saveUserToPrefs(usrdata!);
    }
  } catch (e) {
    print("Error fetching user details: $e");
  } finally {
    notifyListeners();
  }
}


  Future<void> deleteAccount(BuildContext context) async {
    isLoading = true;
    try {
      final response = await ProfileRepository().deleteAccount(userId);
      if (response['status'] == true) {
        Helper.toastMessage(
            message: response['data']['message'] ?? 'User Deleted',
            color: AppColors.themecolor);
        await clearCachedProfileImage();
        await SharedPreferencesHelper.clearAllData();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const FirstPage()),
          (route) => false,
        );
      } else {
        Helper.toastMessage(
            message: 'Something went wrong', color: AppColors.red);
      }
    } catch (e) {
      Helper.toastMessage(message: e.toString(), color: AppColors.black);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void validateForm(context) {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> data = {
        'current_password': oldpasswordController.text.trim(),
        'new_password': newpasswordController.text.trim()
      };
      changePasswordfun(context, data);
    }
  }

  Future<void> changePasswordfun(context, data) async {
    try {
      isLoading = true;
      final response =
          await ProfileRepository().changePasswordfun(userId, data);
      if (response['status'] == true) {
        Helper.toastMessage(
            message: response['data']['message'] ?? "Password Changed",
            color: AppColors.themecolor);
        cnfnewpasswordController.clear();
        newpasswordController.clear();
        oldpasswordController.clear();
      } else {
        Helper.toastMessage(
            message: 'Wrong Old Password', color: AppColors.red);
      }
    } catch (e) {
      Helper.toastMessage(message: '$e', color: AppColors.red);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updatefcmtoken() async {
    fcmtoken = (await SharedPreferencesHelper.getString('fcm'))!;
    if (fcmtoken.isNotEmpty) {
      final response = await ProfileRepository().updatefcmtoken(fcmtoken);
      print("Response of FCM token----$response");
    }
  }
}
