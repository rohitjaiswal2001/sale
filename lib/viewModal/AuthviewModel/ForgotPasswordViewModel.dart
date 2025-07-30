// lib/viewmodels/forgot_password_view_model.dart
// import 'package:android_intent_plus/android_intent.dart';
// import 'package:android_intent_plus/flag.dart';
import 'package:bid4style/Models/UserModel.dart';
import 'package:bid4style/Utils/Appcolor.dart';
import 'package:bid4style/repo/authRepo.dart';
import 'package:bid4style/services/session_manager.dart';
import 'package:bid4style/view/Auth/otp_create.dart';
import 'package:bid4style/view/Auth/update%20password.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Helper.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Input controller
  final emailController = TextEditingController();

  bool get isLoading => _isLoading;

  void validateForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      sendResetLink(context).onError((error, stackTrace) {
        print("ERROR----------");
        Helper.toastMessage(
          message: error is Map ? error["status"] : error.toString(),
          color: AppColors.red,
        );
      });
    }
  }

  Future<void> sendResetLink(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {'email': emailController.text.trim()};
      final response = await AuthRepository().forgetpassword(data);
      UserModel user = UserModel.fromJson(response);

      // emailController.clear();
      // Navigate to OTP Verification Screen

      // Logic

      if (user.status == true) {
        Helper.toastMessage(
          message: (user.message).toString(),
          color: AppColors.themecolor,
        );
        SharedPreferencesHelper.emailotpSet(emailController.text.trim());

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpCreate()),
        );
      } else {
        Helper.toastMessage(
          message: user.error ?? "Something went wrong",
          color: AppColors.green,
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      Helper.toastMessage(message: e.toString(), color: AppColors.red);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: ${e.toString()}')),
      // );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> openEmailInbox() async {
  //   if (Platform.isAndroid) {
  //     final intent = AndroidIntent(
  //       action: 'android.intent.action.MAIN',
  //       category: 'android.intent.category.APP_EMAIL',
  //       flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
  //     );
  //     await intent.launch();
  //   } else {
  //     throw 'This functionality is only supported on Android.';
  //   }
  // }
}
