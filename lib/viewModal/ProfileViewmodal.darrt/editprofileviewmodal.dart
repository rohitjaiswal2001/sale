import 'package:bid4style/Models/profileModal.dart';
import 'package:bid4style/repo/authRepo.dart';
import 'package:bid4style/repo/userRepo.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/Helper.dart';
import 'package:bid4style/utils/imagecropper.dart';
import 'package:bid4style/utils/permissions.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class EditProfileViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final phoneController = TextEditingController();
  final profilePicController = TextEditingController();
  bool _isProfileImageLoading = false;
  String _profileimgUrl = "";
  File? _localImage; // Store local image file

  final FocusNode usernamenameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phnoFocusNode = FocusNode();
  final FocusNode userNameFocusNode = FocusNode();
  String? _profileimgPath;

  String? _imgurl;

  String? get imgurl => _imgurl;

  set imgurl(String? value) {
    _imgurl = value;
    notifyListeners();
  }

  File? selectedImage;

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

  File? get localImage => _localImage;

  // Initialize controllers with existing profile data from UserDetailViewmodel
  Future<void> initializeControllers(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userDetailViewModel = context.read<UserDetailViewmodel>();
      print(
        "UserDetailViewmodel accessed in EditProfileViewModel:--- $userDetailViewModel",
      );
      final profileData = userDetailViewModel.profiledata;
      print(
        "Profile data in EditProfileViewModel:---- ${profileData?.toJson()}",
      );

      if (profileData?.data != null) {
        emailController.text = profileData!.data!.email ?? '';
        userNameController.text = profileData!.data!.userName ?? '';
        // bioController.text = profileData!.data!.bio ?? '';
        phoneController.text = profileData.data!.phoneNo ?? "";
        profilePicController.text = profileData!.data!.profilePic ?? '';
        _localImage = null; // Reset local image
        print("Profile data initialized:----- ${profileData.data!.toJson()}");
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

    List<MapEntry<String, File>>? files;
    List<MapEntry<String, String>>? fields;
    files!.add(MapEntry('image', image));

    final response = await ProfileRepository().uploadProfilePicture(
      fields,
      files,
    );

    Helper.toastMessage(message: response['message'] ?? response['error']);

    return response['data'];
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
        phoneNo: phoneController.text.trim(),
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

      // await Future.delayed(Duration(seconds: 10));

      // Optionally, send data to backend API
      await ProfileRepository().updateProfile({
        'profile_pic'
                'email':
            emailController.text,
        'username': userNameController.text,
        'phone_no.': phoneController.text,
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
    emailFocusNode.dispose();
    usernamenameFocusNode.dispose();
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
        // ✅ Success
        Helper.toastMessage(
          message: response['message'] ?? 'Password changed successfully',
          color: AppColors.themecolor,
        );

        // Clear controllers only on success
        oldController.clear();
        newController.clear();
        confirmController.clear();

        if (context.mounted) {
          Navigator.pop(context); // Close screen/dialog
        }
      } else {
        // ❌ Failure
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

  /// Downloads the profile image from the URL, caches it, and returns the local file path
  Future<String?> cacheProfileImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      print("Profile image URL is empty");
      return null;
    }

    try {
      isProfileImageLoading = true;
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      // Create a unique filename based on the URL or user ID
      final fileName = 'profile_${imageUrl.hashCode}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);

      // Check if the image is already cached
      if (await file.exists()) {
        print("Using cached profile image: $filePath");
        return filePath;
      }

      // Clear old cached images for this user
      await clearOldCachedImages(tempDir, fileName);

      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Save the image to the cache
        await file.writeAsBytes(response.bodyBytes);
        print("Profile image cached: $filePath");
        return filePath;
      } else {
        print("Failed to download image: ${response.statusCode}");
        // Helper.toastMessage(
        //     message: 'Failed to download profile image', color: AppColors.red);
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

  /// Clears old cached profile images for the user
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
          print("Deleted old cached image: ${file.path}");
        }
      }
    } catch (e) {
      print("Error clearing old cached images: $e");
    }
  }

  /// Clears the cached profile image
  Future<void> clearCachedProfileImage() async {
    if (_profileimgPath != null) {
      try {
        final file = File(_profileimgPath!);
        if (await file.exists()) {
          await file.delete();
          print("Cached profile image deleted: $_profileimgPath");
        }
        _profileimgPath = null;
        notifyListeners();
      } catch (e) {
        print("Error deleting cached profile image: $e");
      }
    }
  }

  /// Returns the appropriate ImageProvider for the profile image
  ImageProvider getProfileImageProvider({File? selectedImage}) {
    // Prioritize locally selected image
    if (selectedImage != null && selectedImage.existsSync()) {
      print("Using Selected FileImage: ${selectedImage.path}");
      return FileImage(selectedImage);
    }
    // Check for cached image
    else if (_profileimgPath != null && File(_profileimgPath!).existsSync()) {
      print("Using Cached FileImage: $_profileimgPath");
      return FileImage(File(_profileimgPath!));
    }
    // Use profile URL if available and non-empty
    else if (_profileimgUrl.isNotEmpty && _profileimgUrl != "null") {
      print("Using NetworkImage: $_profileimgUrl");
      return NetworkImage(_profileimgUrl);
    }
    // Fallback to default asset
    else {
      print("Using AssetImage: assets/images/created.png");
      return AssetImage('assets/images/created.png');
    }
  }

  ImageProvider? getProfileImageProviderProfileView({File? selectedImage}) {
    // Prioritize locally selected image
    if (selectedImage != null && selectedImage.existsSync()) {
      print("Using Selected FileImage: ${selectedImage.path}");
      return FileImage(selectedImage);
    }
    // Check for cached image
    else if (_profileimgPath != null && File(_profileimgPath!).existsSync()) {
      print("Using Cached FileImage: $_profileimgPath");
      return FileImage(File(_profileimgPath!));
    }
    // Use profile URL if available and non-empty
    else if (profileimgUrl.isNotEmpty && profileimgUrl != "null") {
      print("Using NetworkImage: $_profileimgUrl");
      return NetworkImage(_profileimgUrl);
    }
    // Fallback to default asset
    else {
      // print("Using AssetImage: assets/images/created.png");
      return null;
      // AssetImage('assets/images/created.png');
    }
  }

  /// Forces a refresh of the cached profile image
  Future<void> refreshProfileImage() async {
    if (_profileimgUrl.isNotEmpty) {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'profile_${_profileimgUrl.hashCode}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print("Cleared cached image for refresh: $filePath");
      }
      await cacheProfileImage(_profileimgUrl);
    }
  }

  // Method to pick an image
  Future<bool> pickImageProfile(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      selectedImage = File(pickedImage.path);

      // selectedImage = await cropImage(context, pickedImage.path, false);

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
      requestFullMetadata: false,
    );

    if (clickedImage != null) {
      selectedImage = File(clickedImage.path);

      // selectedImage = await cropImage(context, clickedImage.path, false);

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
      profileimgUrl = '';
      imgurl = null;
      clearCachedProfileImage();
      // function for Api call to remove photo
      notifyListeners();
    } finally {
      profileimgPath == null;
      selectedImage == null;
      isLoading = false;

      notifyListeners();
    }
  }
}
