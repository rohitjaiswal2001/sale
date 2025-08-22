import 'package:bid4style/Models/profileModal.dart';
import 'package:bid4style/repo/authRepo.dart';
import 'package:bid4style/repo/userRepo.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/Helper.dart';

import 'package:bid4style/utils/permissions.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'userDetailViewMode.dart';

class EditProfileViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final profilePicController = TextEditingController();
  bool _isProfileImageLoading = false;
  String _profileimgUrl = "";
  File? _localImage; // Store local image file

  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phnoFocusNode = FocusNode();

  String? _profileimgPath;

  String? get imgurl => _profileimgUrl;

  set imgurl(String? value) {
    _profileimgUrl = value ?? '';
    notifyListeners();
  }

  File? get selectedImage => _localImage;

  set selectedImage(File? value) {
    _localImage = value;
    notifyListeners();
  }

  final PermissionHandler _permissionHandler = PermissionHandler();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String get profileimgUrl => _profileimgUrl;

  set profileimgUrl(String value) {
    _profileimgUrl = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? get profileimgPath => _profileimgPath;

  set profileimgPath(String? value) {
    _profileimgPath = value;
    notifyListeners();
  }

  bool get isProfileImageLoading => _isProfileImageLoading;

  set isProfileImageLoading(bool value) {
    _isProfileImageLoading = value;
    notifyListeners();
  }

  Future<void> initializeControllers(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userDetailViewModel = context.read<UserDetailViewmodel>();
      print("UserDetailViewmodel accessed: $userDetailViewModel");
      final profileData = userDetailViewModel.profiledata;
      print("Profile data: ${profileData?.toJson()}");

      if (profileData?.data != null) {
        emailController.text = profileData!.data!.email ?? '';
        userNameController.text = profileData!.data!.userName ?? '';
        phoneController.text = profileData.data!.phoneNo ?? '';
        profilePicController.text = profileData!.data!.profilePic ?? '';
        _localImage = null;
        print("Profile data initialized: ${profileData.data!.toJson()}");
        // Mark fields as dirty after initialization
        _markFieldsAsDirty();
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

  void _markFieldsAsDirty() {
    if (formKey.currentState != null) {
      formKey.currentState!
          .validate(); // Triggers validation and marks fields as dirty
    }
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    try {
      bool hasPermission = source == ImageSource.camera
          ? await _permissionHandler.requestCameraPermission(context)
          : await _permissionHandler.requestGalleryPermission(context);

      if (!hasPermission) return;

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        _isLoading = true;
        _localImage = File(pickedFile.path);
        notifyListeners();
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

  Future<String> _uploadImageToServer(File image) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Initialize lists properly
      final files = <MapEntry<String, File>>[MapEntry('image', image)];
      final fields = <MapEntry<String, String>>[
        MapEntry('type', 'Profile_pic'),
      ];

      // Simulate API call to upload profile picture
      final response = await ProfileRepository().uploadProfilePicture(
        fields,
        files,
      );

      // Check if response is valid (assuming it returns a Map or String)
      if (response['status'] == true) {
        print("Image uploaded successfully");
        return response['data'];
      } else {
        print("Image upload failed: ${response['message'] ?? 'Unknown error'}");
        throw Exception(
          'Image upload failed: ${response['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print("Error uploading image: $e");
      return ''; // Return a default value to indicate failure
    }
  }

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

  Future<void> saveEditedProfile(BuildContext context) async {
    try {
      isLoading = true;
      String? imageUrl;
      if (_localImage != null) {
        print("Datain Local---${_localImage}");
        imageUrl = await _uploadImageToServer(_localImage!);
        if (imageUrl.isNotEmpty) {
          profilePicController.text = imageUrl;
        } else {
          throw Exception('Image upload failed');
        }
      }

      final updatedData = Data(
        email: emailController.text.trim(),
        userName: userNameController.text.trim(),
        phoneNo: phoneController.text.trim(),
        profilePic: profilePicController.text.trim().isEmpty
            ? null
            : profilePicController.text.trim(),
        role: context.read<UserDetailViewmodel>().profiledata?.data?.role,
      );

      final userDetailViewModel = context.read<UserDetailViewmodel>();
      userDetailViewModel.setProfileData({
        'status': true,
        'message': 'Profile updated',
        'data': updatedData.toJson(),
      });

      await ProfileRepository().updateProfile({
        'email': emailController.text.trim(),
        'user_name': userNameController.text.trim(),
        'phone_no': phoneController.text.trim(),
        if (_localImage != null) 'profile_pic': profilePicController.text,
      });

      Helper.toastMessage(
        message: 'Profile updated successfully',
        color: AppColors.grey,
      );
      if (context.mounted) Navigator.pop(context);
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

  void clear() {
    emailController.clear();
    userNameController.clear();
    phoneController.clear();
    profilePicController.clear();
    _localImage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    phoneController.dispose();
    profilePicController.dispose();
    userNameFocusNode.dispose();
    emailFocusNode.dispose();
    phnoFocusNode.dispose();
    super.dispose();
  }

  Future<void> changePassword(
    TextEditingController oldController,
    TextEditingController newController,
    TextEditingController confirmController,
    BuildContext context,
  ) async {
    try {
      isLoading = true;
      Map<String, String> data = {
        'old_password': oldController.text,
        'new_password': newController.text,
      };
      final response = await AuthRepository().changepassword(data);
      if (response['status'] == true) {
        Helper.toastMessage(
          message: response['message'] ?? 'Password changed successfully',
          color: AppColors.themecolor,
        );
        oldController.clear();
        newController.clear();
        confirmController.clear();
        if (context.mounted) Navigator.pop(context);
      } else {
        Helper.toastMessage(
          message: response['message'] ?? 'Something went wrong',
          color: AppColors.red,
        );
      }
    } catch (e) {
      print("e-Updatepassword--->>$e");
      Helper.toastMessage(message: e.toString(), color: AppColors.red);
    } finally {
      isLoading = false;
    }
  }

  Future<String?> cacheProfileImage(String imageUrl) async {
    if (imageUrl.isEmpty) return null;
    try {
      isProfileImageLoading = true;
      final tempDir = await getTemporaryDirectory();
      final fileName = 'profile_${imageUrl.hashCode}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      if (await file.exists()) return filePath;
      await clearOldCachedImages(tempDir, fileName);
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        print("Failed to download image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error caching profile image: $e");
      Helper.toastMessage(
        message: 'Error downloading profile image',
        color: AppColors.red,
      );
      return null;
    } finally {
      isProfileImageLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearOldCachedImages(
    Directory tempDir,
    String currentFileName,
  ) async {
    try {
      final files = tempDir.listSync();
      for (var file in files) {
        if (file is File &&
            file.path.contains('profile_') &&
            file.path != '${tempDir.path}/$currentFileName') {
          await file.delete();
        }
      }
    } catch (e) {
      print("Error clearing old cached images: $e");
    }
  }

  Future<void> clearCachedProfileImage() async {
    if (_profileimgPath != null) {
      try {
        final file = File(_profileimgPath!);
        if (await file.exists()) await file.delete();
        _profileimgPath = null;
      } catch (e) {
        print("Error deleting cached profile image: $e");
      } finally {
        notifyListeners();
      }
    }
  }

  ImageProvider getProfileImageProvider({File? selectedImage}) {
    if (selectedImage != null && selectedImage.existsSync())
      return FileImage(selectedImage);
    else if (_profileimgPath != null && File(_profileimgPath!).existsSync())
      return FileImage(File(_profileimgPath!));
    else if (_profileimgUrl.isNotEmpty && _profileimgUrl != "null")
      return NetworkImage(_profileimgUrl);
    else
      return const AssetImage('assets/images/created.png');
  }

  ImageProvider? getProfileImageProviderProfileView({File? selectedImage}) {
    if (selectedImage != null && selectedImage.existsSync())
      return FileImage(selectedImage);
    else if (_profileimgPath != null && File(_profileimgPath!).existsSync())
      return FileImage(File(_profileimgPath!));
    else if (profileimgUrl.isNotEmpty && profileimgUrl != "null")
      return NetworkImage(_profileimgUrl);
    else
      return null;
  }

  Future<void> refreshProfileImage() async {
    if (_profileimgUrl.isNotEmpty) {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'profile_${_profileimgUrl.hashCode}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      if (await file.exists()) await file.delete();
      await cacheProfileImage(_profileimgUrl);
    }
  }

  Future<bool> pickImageProfile(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _localImage = File(pickedImage.path);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> clickImage(BuildContext context) async {
    final clicker = ImagePicker();
    final clickedImage = await clicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
      requestFullMetadata: false,
    );
    if (clickedImage != null) {
      _localImage = File(clickedImage.path);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> removeImageoption() async {
    isLoading = true;
    try {
      _localImage = null;
      profileimgUrl = '';
      imgurl = null;
      await clearCachedProfileImage();
    } catch (e) {
      print("Error removing image: $e");
    } finally {
      _profileimgPath = null;
      isLoading = false;
      notifyListeners();
    }
  }
}
