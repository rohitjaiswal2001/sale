// lib/viewmodels/signup_view_model.dart

import 'dart:async';
import 'dart:convert';
import 'package:bid4style/Models/UserDetailModal.dart';
import 'package:bid4style/repo/authRepo.dart';
import 'package:bid4style/view/Auth/Account_created.dart';
import 'package:bid4style/view/Auth/LoginPage.dart';
import 'package:bid4style/view/Auth/otp_create.dart';
import 'package:bid4style/view/Auth/update%20password.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Models/UserModel.dart';
import '../../Utils/Appcolor.dart';
import '../../Utils/Helper.dart';

import '../../repo/userRepo.dart';
import '../../services/session_manager.dart';

class SignupViewModel with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  bool _isLoadingResend = false;
  bool get isLoadingResend => _isLoadingResend;
  set isLoadingResend(val) {
    _isLoadingResend = val;
    // notifyListeners();
  }

  String? emailotp;
  String? passwordotp;

  clearController() {
    emailController.clear();
    passwordController.clear();
    confirmpasswordController.clear();
    nameController.clear();
    notifyListeners();
  }

  // Input controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  // final bioController = TextEditingController();
  final phoneController = TextEditingController();
  //focus
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode dropdownFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();

  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  // final FocusNode biofocus = FocusNode();

  //UserModal sharedPref
  UserModel? usr;

  //email ans password for create
  String email = "";
  String password = "";
  get remainingTime => _remainingTime;

  // Form Validation
  void validateForm(BuildContext context, bool terms) {
    if (formKey.currentState!.validate()) {
      // Proceed with signup
      if (!terms) {
        Helper.toastMessage(
          message: 'Please accept the terms and conditions',
          color: AppColors.red,
        );
      } else {
        email = emailController.text.trim();
        password = passwordController.text.trim();
        signup(context).onError((error, stackTrace) {
          print("Error ---$error");
          Helper.toastMessage(message: error.toString(), color: AppColors.red);
        });
      }
    }
  }

  // Signup Method method
  Future<void> signup(BuildContext context) async {
    isLoading = true;

    Map<String, String> userdetail = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'user_name': nameController.text.trim(),
      // 'bio': bioController.text.trim(),
      'phone_no': phoneController.text.trim(),
      'role': selectedRole!.toLowerCase().trim(),
    };

    await SharedPreferencesHelper.emailotpSet(emailController.text.trim());

    await SharedPreferencesHelper.passwordotpSet(
      passwordController.text.trim(),
    );
    print("PasswordCHECK----${passwordController.text.trim()}");

    try {
      final response = await AuthRepository().SignUp(userdetail);
      UserModel user = UserModel.fromJson(response);

      print("fffff  ${user.status}");
      if (user.status = true
      // && user.data != null
      ) {
        Helper.toastMessage(
          message: user.message ?? 'Something went wrong',
          color: AppColors.grey,
        );

        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));

        // clearController();
        if (user.data?.email == false) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OtpCreate()),
          );
        }
      } else {
        Helper.toastMessage(
          message: 'Something went wrong',
          color: AppColors.red,
        );
      }
      // Success handling (e.g., navigate to the login screen)
    }
    //  catch (e) {
    //   print("e--signup-->>$e");
    //   Helper.toastMessage(message: e.toString(), color: AppColors.red);
    //   // Error handling (e.g., display a snackbar)
    // }
    finally {
      isLoading = false;
    }
  }

  int _remainingTime = 60;
  Timer? _timer;

  SignupViewModel() {
    startTimer(); // Initialize timer when ViewModel is created
  }

  void startTimer() {
    try {
      isLoadingResend = true;
      _remainingTime = 60;
      _timer?.cancel(); // Cancel any existing timer
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          isLoadingResend = false;

          // Stop the timer
        }
        notifyListeners();
      });
    } finally {
      isLoadingResend = false; // Enable button after timer
    }
  }

  void onlyTimer(BuildContext context) async {
    print(isLoadingResend);
    if (!isLoadingResend) {
      isLoadingResend = true;
      startTimer(); // Start the timer directly without resetting _remainingTime
      // await ResendOTP(context);
      print("Into reset link");

      // _timer?.cancel();
      notifyListeners();
    }
  }

  void resendLink(BuildContext context) async {
    print(isLoadingResend);
    if (!isLoadingResend) {
      isLoadingResend = true;
      startTimer(); // Start the timer directly without resetting _remainingTime
      await ResendOTP(context);
      print("Into reset link");

      // _timer?.cancel();
      notifyListeners();
    }
  }

  // Resend OTP
  Future<void> ResendOTP(BuildContext context) async {
    try {
      await getforOTP();

      Map<String, String> userdetail = {
        'email': emailotp!,
        // 'password': passwordotp!,
      };

      // print("OTP -->> EMAIL--PASSWORD${emailotp!}${passwordotp!}");

      // await SharedPreferencesHelper.emailotpSet(emailController.text.trim());
      // await SharedPreferencesHelper.passwordotpSet(
      //     passwordController.text.trim());

      final response = await AuthRepository().forgetpassword(userdetail);
      UserModel user = UserModel.fromJson(response);

      if (user.status == true) {
        // Corrected the assignment operator
        // final response1 = await ProfileRepository().userdetail();
        // UserDetailModal details = UserDetailModal.fromJson(response1);

        // await SharedPreferencesHelper.saveUserToPrefs(details);

        Helper.toastMessage(
          message: user.message ?? 'Something went wrong',
          color: AppColors.grey,
        );
      } else {
        Helper.toastMessage(
          message: 'Something went wrong',
          color: AppColors.red,
        );
      }
    } catch (e) {
      print("e-- resend-->>$e");
      Helper.toastMessage(message: e.toString(), color: AppColors.black);
    } finally {
      isLoadingResend =
          false; // Move this here to ensure it's set back to false after the operation
      notifyListeners();
    }
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  String? _otpText;

  String? _selectedRole;

  String? get selectedRole => _selectedRole;

  set selectedRole(String? value) {
    _selectedRole = value;
    notifyListeners();
  }

  String? get otpText => _otpText;

  set otpText(String? value) {
    _otpText = value;
    // notifyListeners();
  }

  getforOTP() async {
    emailotp = await SharedPreferencesHelper.getEmailotp();
    passwordotp = await SharedPreferencesHelper.getPasswordotp();
    print("Current emailOtp: $emailotp, Current passwordOtp: $passwordotp");
  }

  Future<void> otpCheck(context) async {
    try {
      isLoading = true;
      await getforOTP();

      Map<String, String> OTPdata = {
        'email': emailotp!,
        // 'password': passwordotp!,
        'otp': otpText!.trim(),
      };

      // API call to verify OTP
      final response = await AuthRepository().VerifyOtp(OTPdata);
      UserModel user = UserModel.fromJson(response);

      // if (user.status == true && user.data?.otp == null) {
      //   print("Null operation in verify account");
      //   Helper.toastMessage(
      //       message: "Registration failed", color: AppColors.green);
      //   // Navigator.push(
      //   //   context,
      //   //   MaterialPageRoute(builder: (_) => AccountCreated()),
      //   // );
      // }

      if (user.status == true
      // && user.data?.token != null
      ) {
        // await SharedPreferencesHelper.saveToken(user.data?.token);
        // final response1 = await ProfileRepository().userdetail();
        // UserDetailModal details = UserDetailModal.fromJson(response1);

        // await SharedPreferencesHelper.saveUserToPrefs(details);

        Helper.toastMessage(
          message: "Verification Successful",
          color: AppColors.grey,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UpdateAccount(email: emailotp!)),
        );
      } else if (user.status == false) {
        Helper.toastMessage(
          message: user.message ?? 'OTP verification failed',
          color: AppColors.red,
        );
      } else if (user.error != null) {
        Helper.toastMessage(
          message: user.error ?? 'Something went wrong',
          color: AppColors.red,
        );
      }
    } catch (e) {
      print("IN catch in Otp verify $e");
      String message = "$e"; // Fallback to stringified exception
      if (e is DioError && e.response != null) {
        message =
            e.response!.data['message'] as String? ?? 'OTP verification failed';
      }
      Helper.toastMessage(message: message, color: AppColors.red);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
