import 'dart:async';

import 'package:bid4style/utils/Helper.dart';

import 'package:bid4style/viewModal/AuthviewModel/SignupViewModel.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';

import 'package:flutter/material.dart';

import '../../Utils/Appcolor.dart';
import '../../repo/userRepo.dart';
import '../../services/session_manager.dart';

class Logoutviewmodel extends ChangeNotifier {
  bool _isLogoutLoading = false;

  bool get isLogoutLoading => _isLogoutLoading;

  set isLogoutLoading(bool value) {
    _isLogoutLoading = value;
    notifyListeners();
  }

  Logoutviewmodel() {
    _isLogoutLoading = false;
  }

  void resetLogoutState() {
    _isLogoutLoading = false;
    notifyListeners();
  }

  /// Function to clear app data and logout
  Future<bool> appDataLogout(BuildContext context) async {
    if (isLogoutLoading) return false;

    try {
      isLogoutLoading = true;
      final response = await ProfileRepository().logout();
      print("Logout API response: $response");

      if (response['status'] == true) {
        print("API logout successful, clearing data...");

        // await clearCachedProfileImage();
        await SharedPreferencesHelper.clearAllData();

        UserDetailViewmodel().clearProfileData();

        if (context.mounted) {
          Helper.toastMessage(
            message: response['message'] ?? 'Logged out successfully',
            color: AppColors.themecolor,
          );
        }
        return true;
      } else {
        print("API logout failed");
        if (context.mounted) {
          Helper.toastMessage(
            message: response['message'] ?? 'Something went wrong',
            color: AppColors.red,
          );
        }
        return false;
      }
    } catch (e) {
      print("Error during logout: $e");
      if (context.mounted) {
        Helper.toastMessage(
          message: 'Error during logout - $e',
          color: AppColors.red,
        );
      }
      return false;
    } finally {
      await SharedPreferencesHelper.clearAllData();
      // clearCachedProfileImage();

      SignupViewModel().clearController();

      resetLogoutState();
    }
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
