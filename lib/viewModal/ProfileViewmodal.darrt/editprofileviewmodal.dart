import 'package:bid4style/Models/loginSignupModal.dart';
import 'package:bid4style/Models/profileModal.dart' hide Data;
import 'package:bid4style/repo/authRepo.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/Helper.dart';
import 'package:bid4style/utils/permissions.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class EditProfileViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final bioController = TextEditingController();
  final profilePicController = TextEditingController();
  File? _localImage; // Store local image file

  final FocusNode usernamenameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode bioFocusNode = FocusNode();
  final FocusNode userNameFocusNode = FocusNode();

  final PermissionHandler _permissionHandler = PermissionHandler();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  File? get localImage => _localImage;

  // Initialize controllers with existing profile data from UserDetailViewmodel
  Future<void> initializeControllers(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userDetailViewModel = context.read<UserDetailViewmodel>();
      print(
        "UserDetailViewmodel accessed in EditProfileViewModel: $userDetailViewModel",
      );
      final profileData = userDetailViewModel.profiledata;
      print("Profile data in EditProfileViewModel: ${profileData?.toJson()}");

      if (profileData?.data != null) {
        emailController.text = profileData!.data!.email ?? '';
        userNameController.text = profileData!.data!.userName ?? '';
        bioController.text = profileData!.data!.bio ?? '';
        profilePicController.text = profileData!.data!.profilePic ?? '';
        _localImage = null; // Reset local image
        print("Profile data initialized: ${profileData.data!.toJson()}");
      } else {
        print("No profile data available to initialize");
        Helper.toastMessage(
          message: 'No profile data available',
          color: AppColors.red,
        );
      }
    } catch (e) {
      print("Error initializing controllers: $e");
      Helper.toastMessage(
        message: 'Failed to load profile data: $e',
        color: AppColors.red,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pick image from camera or gallery with permission handling
  Future<void> pickImage(BuildContext context, ImageSource source) async {
    try {
      bool hasPermission;
      if (source == ImageSource.camera) {
        hasPermission = await _permissionHandler.requestCameraPermission(
          context,
        );
      } else {
        hasPermission = await _permissionHandler.requestGalleryPermission(
          context,
        );
      }

      if (!hasPermission) {
        return; // Permission denied, exit
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        _isLoading = true;
        notifyListeners();

        // Store local image file
        _localImage = File(pickedFile.path);
        print("Local image picked: ${_localImage!.path}");

        // Optionally upload to server and get URL
        // Uncomment the following lines when ready to upload to a server
        /*
        final imageUrl = await _uploadImageToServer(_localImage!);
        profilePicController.text = imageUrl;
        print("Profile picture URL updated: $imageUrl");
        */

        Helper.toastMessage(message: "Image selected", color: AppColors.grey);
      }
    } catch (e) {
      print("Error picking image: $e");
      Helper.toastMessage(
        message: "Failed to pick image: $e",
        color: AppColors.red,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Placeholder method to simulate image upload to server
  Future<String> _uploadImageToServer(File image) async {
    // Replace with actual API call to upload image (e.g., to Firebase Storage)
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return "https://example.com/profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg";
  }

  // Example Firebase Storage implementation (uncomment when ready)
  /*
  Future<String> _uploadImageToServer(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pics/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
      throw Exception('Failed to upload image: $e');
    }
  }
  */

  // Remove profile picture
  Future<void> removeProfilePicture() async {
    try {
      _localImage = null;
      profilePicController.clear();
      Helper.toastMessage(
        message: "Profile picture removed",
        color: AppColors.grey,
      );
    } catch (e) {
      print("Error removing profile picture: $e");
      Helper.toastMessage(
        message: "Failed to remove profile picture: $e",
        color: AppColors.red,
      );
    } finally {
      notifyListeners();
    }
  }

  // Save profile data
  Future<void> saveProfile(BuildContext context) async {
    try {
      isLoading = true;

      // If local image exists, upload it to server
      String? imageUrl;
      if (_localImage != null) {
        imageUrl = await _uploadImageToServer(_localImage!);
        profilePicController.text = imageUrl;
      }

      final updatedData = Data(
        email: emailController.text.trim(),
        userName: userNameController.text.trim(),
        bio: bioController.text.trim(),
        profilePic: profilePicController.text.trim().isEmpty
            ? null
            : profilePicController.text.trim(),
        role: context.read<UserDetailViewmodel>().profiledata?.data?.role,
      );

      // Update UserDetailViewmodel
      final userDetailViewModel = context.read<UserDetailViewmodel>();
      userDetailViewModel.setProfileData({
        'status': true,
        'message': 'Profile updated',
        'data': updatedData.toJson(),
      });

      await Future.delayed(Duration(seconds: 10));

      // Optionally, send data to backend API
      await AuthRepository().updateProfile({
        'email': emailController.text,
        'username': userNameController.text,
        'bio': bioController.text,
        'profile_picture': profilePicController.text,
      });

      Helper.toastMessage(
        message: 'Profile updated successfully',
        color: AppColors.grey,
      );

      // if (context.mounted) {
      //   Navigator.pop(context);
      // }
    } catch (e) {
      print("Error saving profile: $e");
      Helper.toastMessage(
        message: 'Failed to update profile: $e',
        color: AppColors.red,
      );
    } finally {
      isLoading = false;
    }
  }

  // Clear all controllers
  void clear() {
    emailController.clear();
    userNameController.clear();
    bioController.clear();
    profilePicController.clear();
    _localImage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    bioController.dispose();
    profilePicController.dispose();
    emailFocusNode.dispose();
    usernamenameFocusNode.dispose();
    bioFocusNode.dispose();
    super.dispose();
  }

  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    BuildContext context,
  ) async {
    try {
      isLoading = true;

      Map<String, String> data = {
        'email': oldPassword,
        'password': newPassword,

        //  passwordController.text.trim(),
      };

      final response = await AuthRepository().changepassword(data);

      if (response['status'] = true) {
        Helper.toastMessage(
          message: response['message'] ?? 'Something went wrong',
          color: AppColors.themecolor,
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

      // Error handling (e.g., display a snackbar)
    } finally {
      isLoading = false;
    }
  }
}
