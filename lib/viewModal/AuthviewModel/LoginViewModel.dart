// lib/viewmodels/login_view_model.dart
import 'package:bid4style/Utils/Helper.dart';
import 'package:bid4style/repo/authRepo.dart';
import 'package:bid4style/services/session_manager.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/view/Auth/otp_create.dart';
import 'package:bid4style/view/homepage.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/UserModel.dart';
import '../../Models/UserDetailModal.dart';
import '../../repo/userRepo.dart';

class LoginViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController(); // Define _formKey here
  bool _isLoading = false;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  // Input controllers

  // ... getters and setters for controllers

  bool get isLoading => _isLoading;
  String? emailotp;
  String? passwordotp;
  // Form Validation
  void validateForm(context) {
    if (formKey.currentState!.validate()) {
      // Proceed with login
      login(context).onError((error, stackTrace) {
        print("Errrrrrrrrrrrrrrrrrrrr-- $error");
        // if (error is Map<String, dynamic> && error['error'] != null) {
        Helper.toastMessage(message: error.toString(), color: AppColors.red);
        // } else if (error.toString().contains("Email is not verified")) {

        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (_) => OtpCreate()),
        //   );
        // } else {
        //   // print("Errr---${error.to}")
        //   Helper.toastMessage(
        //     message: error is Map ? error['data']["message"] : error.toString(),
        //     color: AppColors.red,
        //   );
        // }
      });
    }
  }

  void getforOTP() async {
    emailotp = await SharedPreferencesHelper.getEmailotp();
    print("emailotp-- ${emailotp.toString()}");
    passwordotp = await SharedPreferencesHelper.getPasswordotp();
    print("passwordotp---${passwordotp.toString()}");
  }

  // Login Method
  Future<void> login(context) async {
    _isLoading = true;
    notifyListeners();

    Map<String, String> data = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'role': 'buyer',
    };

    // await SharedPreferencesHelper.emailotpSet(
    //   (emailController.text.trim()).toString(),
    // );

    // await SharedPreferencesHelper.passwordotpSet(
    //   (passwordController.text.trim()).toString(),
    // );

    try {
      final response = await AuthRepository().loginApi(data);
      UserModel user = UserModel.fromJson(response);

      //
      if (user.status == true) {
        if (user.status == true && user.data?.email == false) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OtpCreate()),
          );
        }
        if (user.status == true && user.data?.token != null) {
          await SharedPreferencesHelper.saveToken(user.data?.token);
          // print(
          //     "TOKEN TO BE SAVED FROM LOGINVIEWMODAL---${user.data?.accessToken}");

          // final response1 = await ProfileRepository().userdetail();
          // UserDetailModal details = UserDetailModal.fromJson(response1);

          print("LOgged in------------");
          Helper.toastMessage(
            message: user.message ?? 'Logged in successfully',
            color: AppColors.grey,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Homepage()),
          );
        }
      } else {
        print("OTP TRUE3");
        Helper.toastMessage(
          message: user.data?.emailVerify == false
              ? user.message!
              : "Error occured",
          color: AppColors.red,
        );
      }
    }
    // catch (e) {
    //   print("Error in Login $e");
    // }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    emailController.clear();
    passwordController.clear();

    notifyListeners();
  }
}
