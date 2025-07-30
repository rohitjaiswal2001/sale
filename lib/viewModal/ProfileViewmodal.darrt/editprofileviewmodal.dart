import 'package:bid4style/Utils/Helper.dart';
import 'package:bid4style/repo/userRepo.dart';
import 'package:bid4style/services/session_manager.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/imagecropper.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:convert';
import 'dart:io';


import '../../Models/UserDetailModal.dart';


class UpdateProfileViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? _imgurl;

  String? get imgurl => _imgurl;

  set imgurl(String? value) {
    _imgurl = value;
    notifyListeners();
  }

  File? selectedImage;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Method to pick an image
  Future<bool> pickImageProfile(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      // selectedImage = File(pickedImage.path);

      selectedImage = await cropImage(context, pickedImage.path, false);

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  // Method to pick an image
  Future<bool> clickImage(BuildContext context) async {
    final clicker = ImagePicker();
    final clickedImage = await clicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
        requestFullMetadata: false);

    if (clickedImage != null) {
      // selectedImage = File(clickedImage.path);

      selectedImage = await cropImage(context, clickedImage.path, false);

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

// Remove image

  Future<void> removeImageoption() async {
    isLoading = true;
    try {
      selectedImage = null; // Or set the image URL to a default or empty value
      Userdetailviewmodel().profileimgUrl = '';
      imgurl = null;
      Userdetailviewmodel().clearCachedProfileImage();
      // function for Api call to remove photo
      notifyListeners();
    } finally {
      Userdetailviewmodel().profileimgPath == null;
      selectedImage == null;
      isLoading = false;

      notifyListeners();
    }
  }

// Method to submit data to the API
  Future<void> submitForm() async {
    try {
      isLoading = true;

      // Prepare form fields
      List<MapEntry<String, String>> fields = [
        MapEntry('email', emailController.text.trim()),
        MapEntry('name', nameController.text.trim()),
        // Add additional fields if required
        // MapEntry('phone', phoneController.text.trim()),
        // MapEntry('age', ageController.text.trim()),
      ];

      // Prepare files
      List<MapEntry<String, File>> files = [];
      if (selectedImage != null) {
        files.add(MapEntry('profile_image', selectedImage!));
      }

      // Call API
      final response = await ProfileRepository().editProfileApI(fields, files);

      print("Response-----${response["status"]}");

      if (response['status'] == true) {
        // Fetch updated user details and save locally
        final response1 = await ProfileRepository().userdetail();
        UserDetailModal details = UserDetailModal.fromJson(response1);
        await SharedPreferencesHelper.saveUserToPrefs(details);

        // Show success toast
        Helper.toastMessage(
            message:
                response['data']['message'] ?? "Profile Updated Successfully",
            color: AppColors.themecolor);

        // Clear form inputs
        Allclear();

        // Navigate to the homepage (if applicable)
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));
      } else {
        Helper.toastMessage(
            message: "Failed to Update", color: AppColors.themecolor);
      }
    } on DioException catch (e) {
      print("Error----$e");
      if (e.response != null) {
        print("Response data: ${e.response?.data}");
        Helper.toastMessage(
            message: "Failed to Update - $e", color: AppColors.red);
      }
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // // Validate form fields
  // bool validateForm() {
  //   if (emailController.text.isEmpty ||
  //       nameController.text.isEmpty ||
  //       phoneController.text.isEmpty ||
  //       !emailController.text.contains('@')) {
  //     return false;
  //   }
  //   return true;
  // }

  void Allclear() {
    emailController.clear();
    nameController.clear();
    ageController.clear();
    phoneController.clear();

    // selectedImage = null;
    // imgurl = null;
    //
  }

  void getEditDetail() async {
    UserDetailModal? usrdata = await SharedPreferencesHelper.getUserFromPrefs();
    print("User data ---${jsonEncode(usrdata)}");
    nameController.text = (usrdata?.data?.user?.name).toString();
    emailController.text = (usrdata?.data?.user?.email).toString();
    ageController.text = (usrdata?.data?.user?.age).toString();
    phoneController.text = (usrdata?.data?.user?.phone).toString();
    imgurl = (usrdata?.data?.user?.profileImage).toString();
    // selectedImage = (usrdata?.data?.user?.profileImage).toString();

    notifyListeners();
  }
}
