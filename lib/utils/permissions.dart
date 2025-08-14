import 'dart:io';

import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/Helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  // Check and request camera permission
  Future<bool> requestCameraPermission(BuildContext context) async {
    try {
      final status = await Permission.camera.status;
      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        _showPermissionDeniedDialog(context, 'Camera');
        return false;
      }

      final result = await Permission.camera.request();
      if (result.isGranted) {
        return true;
      } else {
        Helper.toastMessage(
          message: 'Camera permission denied',
          color: AppColors.red,
        );
        return false;
      }
    } catch (e) {
      print("Error requesting camera permission: $e");
      Helper.toastMessage(
        message: 'Failed to request camera permission: $e',
        color: AppColors.red,
      );
      return false;
    }
  }

  // Check and request gallery (photos) permission
  Future<bool> requestGalleryPermission(BuildContext context) async {
    try {
      // Use Permission.photos for iOS and Android API 33+, fallback to Permission.storage for older Android
      final permission = await _getGalleryPermission();
      final status = await permission.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isPermanentlyDenied) {
        _showPermissionDeniedDialog(context, 'Gallery');
        return false;
      }

      final result = await permission.request();
      if (result.isGranted) {
        return true;
      } else {
        Helper.toastMessage(
          message: 'Gallery permission denied',
          color: AppColors.red,
        );
        return false;
      }
    } catch (e) {
      print("Error requesting gallery permission: $e");
      Helper.toastMessage(
        message: 'Failed to request gallery permission: $e',
        color: AppColors.red,
      );
      return false;
    }
  }

  // Determine the appropriate gallery permission based on platform
  Future<Permission> _getGalleryPermission() async {
    if (Platform.isAndroid) {
      // Check Android SDK version for API 33+ (Android 13)
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return Permission.photos;
      } else {
        return Permission.storage;
      }
    }
    return Permission.photos; // iOS or default
  }

  // Show dialog for permanently denied permissions
  void _showPermissionDeniedDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permissionName Permission Required'),
        content: Text(
          'The $permissionName permission is permanently denied. Please enable it in your device settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings(); // Open device settings
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}