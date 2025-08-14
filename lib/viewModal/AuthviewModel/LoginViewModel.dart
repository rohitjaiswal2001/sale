// lib/viewmodels/login_view_model.dart
import 'package:bid4style/Utils/Helper.dart';
import 'package:bid4style/repo/authRepo.dart';
import 'package:bid4style/services/session_manager.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/view/Auth/otp_create.dart';
import 'package:bid4style/view/homepage.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';
import 'package:bid4style/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../Models/loginSignupModal.dart';
import '../../Models/profileModal.dart';
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

  Future<void> login(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final data = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {
      // Authenticate user
      final response = await AuthRepository().loginApi(data);
      final user = UserModel.fromJson(response);

      if (user.status != true || user.data == null) {
        throw Exception(user.message ?? 'Login failed');
      }

      // Check for OTP verification
      if (user.data!.emailVerify == false) {
        Helper.toastMessage(
          message: user.message ?? 'Please verify your email',
          color: AppColors.red,
        );
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OtpCreate()),
          );
        }
        return;
      }

      // Save token
      if (user.data!.token == null) {
        throw Exception('No token received');
      }
      await SharedPreferencesHelper.saveToken(user.data!.token!);

      // Fetch and store profile data
      try {
        final profileResponse = await ProfileRepository().getProfileData();
        debugPrint("Profile data loaded successfully: $profileResponse");
        if (context.mounted) {
          await Provider.of<UserDetailViewmodel>(
            context,
            listen: false,
          ).setProfileData(profileResponse);
        }
      } catch (e) {
        debugPrint("Profile data loading failed: $e");
        // Continue to NavBar even if profile fetch fails
      }

      // Show success message and navigate to NavBar
      Helper.toastMessage(
        message: user.message ?? 'Login successful',
        color: AppColors.grey,
      );
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavBar()),
        );
      }
    } catch (e) {
      debugPrint("Login error: $e");
      if (context.mounted) {
        Helper.toastMessage(message: e.toString(), color: AppColors.red);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    emailController.clear();
    passwordController.clear();

    notifyListeners();
  }

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  // Update the user and notify listeners
  void setUser(GoogleSignInAccount? user) {
    _user = user;
    notifyListeners();
  }

  // Google Sign-In Method
  Future<bool> signInWithGoogle({required BuildContext context}) async {
    // _isLoading = true;
    // notifyListeners();

    // try {
    //   final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    //   // Set up authentication event listener
    //   googleSignIn.authenticationEvents.listen((event) {
    //     if (event is GoogleSignInAuthenticated) {
    //       setUser(event.account);
    //       print('User signed in: ${event.account.email}');
    //     } else if (event is GoogleSignInSignedOut) {
    //       setUser(null);
    //       print('User signed out');
    //     }
    //   }, onError: (error) {
    //     print('Authentication error: $error');
    //   });

    //   // Initialize GoogleSignIn
    //   await googleSignIn.initialize(
    //     clientId: clientId,
    //     serverClientId: serverClientId,
    //   );

    //   // Attempt lightweight authentication
    //   GoogleSignInAccount? account = await googleSignIn
    //       .attemptLightweightAuthentication();

    //   // If lightweight authentication fails, prompt for sign-in
    //   if (account == null) {
    //     if (googleSignIn.supportsAuthenticate()) {
    //       account = await googleSignIn.authenticate();
    //     } else if (kIsWeb) {
    //       Helper.toastMessage(
    //         message:
    //             'Web platform requires Google Sign-In button. Use google_sign_in_web renderButton().',
    //         color: AppColors.red,
    //       );
    //       _isLoading = false;
    //       notifyListeners();
    //       return false;
    //     } else {
    //       Helper.toastMessage(
    //         message: 'Platform does not support authenticate method.',
    //         color: AppColors.red,
    //       );
    //       _isLoading = false;
    //       notifyListeners();
    //       return false;
    //     }
    //   }

    //   // If account is null, sign-in failed
    //   if (account == null) {
    //     Helper.toastMessage(
    //       message: 'Sign-in failed: No account returned.',
    //       color: AppColors.red,
    //     );
    //     _isLoading = false;
    //     notifyListeners();
    //     return false;
    //   }

    //   // Check and request scopes
    //   final GoogleSignInClientAuthorization? authorization = await account
    //       .authorizationClient
    //       .authorizationForScopes(scopes);

    //   if (authorization == null) {
    //     if (googleSignIn.authorizationRequiresUserInteraction()) {
    //       bool userConfirmed = await _showAuthorizationDialog(context);
    //       if (!userConfirmed) {
    //         Helper.toastMessage(
    //           message: 'User canceled scope authorization.',
    //           color: AppColors.red,
    //         );
    //         _isLoading = false;
    //         notifyListeners();
    //         return false;
    //       }
    //     }

    //     final GoogleSignInClientAuthorization? newAuthorization = await account
    //         .authorizationClient
    //         .authorizeScopes(scopes);

    //     if (newAuthorization == null) {
    //       Helper.toastMessage(
    //         message: 'Failed to authorize required scopes.',
    //         color: AppColors.red,
    //       );
    //       _isLoading = false;
    //       notifyListeners();
    //       return false;
    //     }
    //   }

    //   // Request server auth code for backend
    //   String? serverAuthCode;
    //   if (serverClientId != null) {
    //     final GoogleSignInServerAuthorization? serverAuth = await account
    //         .authorizationClient
    //         .authorizeServer(scopes);
    //     if (serverAuth != null) {
    //       serverAuthCode = serverAuth.serverAuthCode;
    //       print('Server auth code: $serverAuthCode');
    //     } else {
    //       print('Server auth code not available.');
    //     }
    //   }

    //   // Send Google token to backend for authentication
    //   try {
    //     final response = await AuthRepository().googleLoginApi({
    //       'idToken': (await account.authentication).idToken,
    //       'serverAuthCode': serverAuthCode,
    //     });

    //     UserModel user = UserModel.fromJson(response);

    //     if (user.status == true) {
    //       if (user.data?.email == false) {
    //         if (context.mounted) {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(builder: (_) => OtpCreate()),
    //           );
    //         }
    //       }
    //       if (user.data?.token != null) {
    //         await SharedPreferencesHelper.saveToken(user.data?.token);

    //         try {
    //           final profileResponse = await ProfileRepository()
    //               .getProfileData();
    //           print("Profile data loaded successfully: $profileResponse");

    //           if (context.mounted) {
    //             try {
    //               Provider.of<UserDetailViewmodel>(
    //                 context,
    //                 listen: false,
    //               ).setProfileData(profileResponse);
    //             } catch (e) {
    //               print("Error accessing UserDetailViewmodel: $e");
    //               Helper.toastMessage(
    //                 message: "Failed to load profile data",
    //                 color: AppColors.red,
    //               );
    //             }
    //           }
    //         } catch (e) {
    //           print("Profile data loading failed: $e");
    //         }

    //         Helper.toastMessage(
    //           message: user.message ?? 'Google Sign-In successful',
    //           color: AppColors.grey,
    //         );

    //         if (context.mounted) {
    //           Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(builder: (_) => Homepage()),
    //           );
    //         }
    //       }
    //     } else {
    //       Helper.toastMessage(
    //         message: user.data?.emailVerify == false
    //             ? user.message!
    //             : "Error occurred",
    //         color: AppColors.red,
    //       );
    //     }
    //   } catch (e) {
    //     Helper.toastMessage(message: e.toString(), color: AppColors.red);
    //     _isLoading = false;
    //     notifyListeners();
    //     return false;
    //   }

    //   setUser(account);
    //   _isLoading = false;
    //   notifyListeners();
    //   return true;
    // } catch (e, stackTrace) {
    //   Helper.toastMessage(
    //     message: 'Google Sign-In error: $e',
    //     color: AppColors.red,
    //   );
    //   print('Error during Google Sign-In: $e');
    //   print('Stack trace: $stackTrace');
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // }
    return true;
  }

  // Sign out the user
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    setUser(null);
  }

  // Helper function to show a dialog for scope authorization
  Future<bool> _showAuthorizationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Additional Permissions Required'),
            content: const Text(
              'This app requires additional permissions to access your Google data.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Allow'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
