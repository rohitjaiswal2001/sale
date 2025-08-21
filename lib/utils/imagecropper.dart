// import 'dart:io';

// import 'package:bid4style/utils/Appcolor.dart';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';


// Future<File?> cropImage(BuildContext context, String imagePath, bool isfolder) async {
//   try {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: imagePath,
//       aspectRatio:
//           const CropAspectRatio(ratioX: 3, ratioY: 3), // Custom aspect ratio
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: '',
//             toolbarColor: AppColors.themecolor,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false,
//             showCropGrid: true,
//             activeControlsWidgetColor: AppColors.themecolor),
//         IOSUiSettings(
//           title: '',cropStyle:
          
//           isfolder?CropStyle.rectangle: CropStyle.circle,

//           aspectRatioLockDimensionSwapEnabled: true,
//           aspectRatioLockEnabled: true,
//           minimumAspectRatio: 1.1,
//         ),
//         WebUiSettings(
//           context: context,
//         ),
//       ],
//     );

//     if (croppedFile != null) {
//       // Handle the cropped file (e.g., save or display)
//       print('Cropped file path: ${croppedFile.path}');
//     }
//     return File(croppedFile!.path);
//   } catch (e) {
//     print('Error cropping image: $e');
//     return null;
//   }
// }
