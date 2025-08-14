import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bid4style/Models/loginSignupModal.dart';
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
  bool _canResend = false;
  int _remainingSeconds = 0;
  Timer? _timer;
  String? _otpText;
  String? emailotp;
  bool _isDisposed = false;
  bool _isInitialized = false;

  ForgotPasswordViewModel() {
    // Initialize synchronously to avoid issues
    _canResend = false;
    _initialize();
  }

  // Initialization method
  void _initialize() {
    if (!_isInitialized) {
      _isInitialized = true;
      // Load email asynchronously without blocking constructor
      _loadEmailFromPrefs();
    }
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingResend => _isLoadingResend;
  bool get canResend => _canResend;
  int get remainingSeconds => _remainingSeconds;
  String? get otpText => _otpText;

  // Setters with notify
  set otpText(String? value) {
    _otpText = value;
    notifyListeners();
  }

  // Private setter without notification for performance
  set otpTextSilent(String? value) {
    _otpText = value;
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

    _isLoadingResend = true;
    notifyListeners();

    try {
      await _loadEmailFromPrefs();
      if (emailotp == null || emailotp!.isEmpty) {
        throw "Email not found";
      }

      final response = await AuthRepository().forgetpassword({
        'email': emailotp!,
      });
      final user = UserModel.fromJson(response);

      if (user.status == true) {
        Helper.toastMessage(
          message: user.message ?? 'OTP resent successfully',
          color: AppColors.grey,
        );
        _startTimer(); // Start timer only after successful resend
      } else {
        Helper.toastMessage(
          message: user.message ?? 'Something went wrong',
          color: AppColors.red,
        );
      }
    } catch (e) {
      Helper.toastMessage(message: e.toString(), color: AppColors.red);
    } finally {
      _isLoadingResend = false;
      notifyListeners();
    }
  }

  Future<void> otpCheck(BuildContext context) async {
    if (otpText == null || otpText!.isEmpty) {
      Helper.toastMessage(message: "Please enter OTP", color: AppColors.red);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _loadEmailFromPrefs();

      if (emailotp == null || emailotp!.isEmpty) {
        throw "Email not found";
      }

      final response = await AuthRepository().VerifyOtp({
        'email': emailotp!,
        'otp': otpText!.trim(),
      });

      final user = UserModel.fromJson(response);

      if (user.status == true) {
        Helper.toastMessage(
          message: "Verification Successful",
          color: AppColors.grey,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UpdateAccount(email: emailotp!)),
        );
      } else {
        Helper.toastMessage(
          message: user.message ?? 'OTP verification failed',
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

  Future<void> _loadEmailFromPrefs() async {
    emailotp = await SharedPreferencesHelper.getEmailotp();
    // Don't notify listeners here - this is internal data loading
  }

  // Accurate countdown timer that works like a real clock
  void _startTimer() {
    _canResend = false;
    _remainingSeconds = 60;
    _timer?.cancel();
    print(
      "Timer started - remaining: $_remainingSeconds, canResend: $_canResend",
    );

    // Update every second for accurate countdown like a real clock
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isDisposed) {
        _remainingSeconds--;

        if (_remainingSeconds <= 0) {
          _remainingSeconds = 0;
          _canResend = true;
          _isLoadingResend = false;
          timer.cancel();
          print("Timer finished - canResend: $_canResend");
        }

        // Update UI every second for real-time countdown
        print(
          "Timer update - remaining: $_remainingSeconds, canResend: $_canResend",
        );
        notifyListeners();
      } else {
        timer.cancel();
      }
    });

    notifyListeners(); // Initial notification
  }

  void startTimerIfNeeded() {
    // Start timer when OTP screen loads for the first time
    if ((_timer == null || !_timer!.isActive) && !_canResend) {
      print(
        "Starting timer - remaining seconds: $_remainingSeconds, canResend: $_canResend",
      );
      _startTimer();
    }
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    emailController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
