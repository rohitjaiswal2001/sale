import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bid4style/Models/UserModel.dart';
import 'package:bid4style/Utils/Appcolor.dart';
import 'package:bid4style/repo/authRepo.dart';
import 'package:bid4style/services/session_manager.dart';
import 'package:bid4style/view/Auth/otp_create.dart';
import 'package:bid4style/view/Auth/update%20password.dart';
import '../../../Utils/Helper.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingResend = false;
  int _remainingTime = 60;
  Timer? _timer;
  String? _otpText;
  String? emailotp;

  ForgotPasswordViewModel() {
    _initialize();
  }

  // Initialization method
  void _initialize() async {
    await _loadEmailFromPrefs();
    _startTimer();
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingResend => _isLoadingResend;
  int get remainingTime => _remainingTime;
  String? get otpText => _otpText;

  // Setters with notify
  set otpText(String? value) {
    _otpText = value;
    notifyListeners();
  }

  set isLoadingResend(bool val) {
    _isLoadingResend = val;
    notifyListeners();
  }

  void validateForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      sendResetLink(context);
    }
  }

  Future<void> sendResetLink(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final email = emailController.text.trim();
      await SharedPreferencesHelper.emailotpSet(email);

      final response = await AuthRepository().forgetpassword({'email': email});
      final user = UserModel.fromJson(response);

      if (user.status == true) {
        Helper.toastMessage(
          message: user.message ?? "OTP sent",
          color: AppColors.themecolor,
        );
        Navigator.push(context, MaterialPageRoute(builder: (_) => OtpCreate()));
      } else {
        Helper.toastMessage(
          message: user.error ?? "Something went wrong",
          color: AppColors.red,
        );
      }
    } catch (e) {
      Helper.toastMessage(message: e.toString(), color: AppColors.red);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendOtp(BuildContext context) async {
    if (_isLoadingResend) return;

    isLoadingResend = true;
    _startTimer();

    try {
      await _loadEmailFromPrefs();
      if (emailotp == null || emailotp!.isEmpty) {
        throw "Email not found";
      }

      final response = await AuthRepository().forgetpassword({
        'email': emailotp!,
      });
      final user = UserModel.fromJson(response);
      print("object");
      if (user.status == true) {
        Helper.toastMessage(
          message: user.message ?? 'OTP resent successfully',
          color: AppColors.grey,
        );
      } else {
        Helper.toastMessage(
          message: user.message ?? 'Something went wrong',
          color: AppColors.red,
        );
      }
    } catch (e) {
      print("Catch----$e");
      Helper.toastMessage(message: e.toString(), color: AppColors.red);
    } finally {
      isLoadingResend = false;
    }
  }

  Future<void> otpCheck(BuildContext context) async {
    print("otpCheck: Started");

    if (otpText == null || otpText!.isEmpty) {
      print("otpCheck: OTP is empty");
      Helper.toastMessage(message: "Please enter OTP", color: AppColors.red);
      return;
    }

    _isLoading = true;
    notifyListeners();
    print("otpCheck: isLoading set to true");

    try {
      print("otpCheck: Loading email from SharedPreferences...");
      await _loadEmailFromPrefs();
      print("otpCheck: Loaded email -> $emailotp");

      if (emailotp == null || emailotp!.isEmpty) {
        print("otpCheck: Email not found in SharedPreferences");
        throw "Email not found";
      }

      print("otpCheck: Sending OTP verification request...");
      final response = await AuthRepository().VerifyOtp({
        'email': emailotp!,
        'otp': otpText!.trim(),
      });

      final user = UserModel.fromJson(response);
      print("otpCheck: Response received -> ${user.status}");

      if (user.status == true) {
        print("otpCheck: OTP verified successfully");
        Helper.toastMessage(
          message: "Verification Successful",
          color: AppColors.grey,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UpdateAccount(email: emailotp!)),
        );
      } else {
        print("otpCheck: OTP verification failed - ${user.message}");
        Helper.toastMessage(
          message: user.message ?? 'OTP verification failed',
          color: AppColors.red,
        );
      }
    } catch (e) {
      print("otpCheck: Error occurred - $e");
      Helper.toastMessage(message: e.toString(), color: AppColors.red);
    } finally {
      _isLoading = false;
      notifyListeners();
      print("otpCheck: isLoading set to false, operation completed");
    }
  }

  Future<void> _loadEmailFromPrefs() async {
    emailotp = await SharedPreferencesHelper.getEmailotp();
    notifyListeners();
  }

  void _startTimer() {
    _remainingTime = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        timer.cancel();
        isLoadingResend = false;
      }
    });
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    emailController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
