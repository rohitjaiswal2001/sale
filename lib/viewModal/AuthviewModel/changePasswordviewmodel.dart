import 'package:bid4style/Models/loginSignupModal.dart';
import 'package:bid4style/repo/authRepo.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/Helper.dart';
import 'package:bid4style/view/Auth/LoginPage.dart';
import 'package:flutter/material.dart';

class Changepasswordviewmodel with ChangeNotifier {
  bool _isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  clearController() {
    passwordController.clear();
    confirmpasswordController.clear();

    notifyListeners();
  }

  // Input controllers

  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

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
          message: user.message ?? 'Password Changed',
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
