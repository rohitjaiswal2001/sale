import 'package:bid4style/view/Auth/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Models/UserModel.dart';
import '../../Utils/Appcolor.dart';
import '../../Utils/Helper.dart';
import '../../repo/authRepo.dart';
import '../../services/session_manager.dart';

class UpdateAccountViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  clearController() {
    passwordController.clear();
    confirmpasswordController.clear();

    notifyListeners();
  }

  // Input controllers

  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  //focus

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  //UserModal sharedPref
  // UserModel? usr;

  // Form Validation
  void validateForm(String email, String password, BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Proceed with Update password
      updatePassword(email, password, context).onError((error, stackTrace) {
        print("Error ---$error");
        Helper.toastMessage(
          message: error is Map ? error["errors"] : error.toString(),
          color: AppColors.red,
        );
      });
    }
  }

  Future<void> updatePassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      isLoading = true;

      Map<String, String> data = {
        'email': email,
        'password': password,

        //  passwordController.text.trim(),
      };

      final response = await AuthRepository().updatepassword(data);
      UserModel user = UserModel.fromJson(response);

      if (user.status = true) {
        Helper.toastMessage(
          message: user.message ?? 'Something went wrong',
          color: AppColors.themecolor,
        );

        // clearController();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        Helper.toastMessage(
          message: 'Something went wrong',
          color: AppColors.red,
        );
      }
      // Success handling (e.g., navigate to the login screen)
    } catch (e) {
      print("e-Updatepassword--->>$e");
      Helper.toastMessage(message: "Invalid OTP", color: AppColors.black);
      // Error handling (e.g., display a snackbar)
    } finally {
      isLoading = false;
    }
  }
}
