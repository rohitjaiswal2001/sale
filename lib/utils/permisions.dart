import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Request a single permission
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true; // Permission already granted
    } else if (status.isDenied || status.isRestricted) {
      // Request permission
      final result = await permission.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permanently denied
      await openAppSettings();
      return false;
    }
    return false; // Permission denied
  }

  // Function for microphone permission
  Future<bool> requestMicPermission() async {
    return await requestPermission(Permission.microphone);
  }

  // Function for camera permission
  Future<bool> requestCameraPermission() async {
    return await requestPermission(Permission.camera);
  }

  // Request gallery (photos/videos) permission
  Future<bool> requestGalleryPermission() async {
    if (Platform.isIOS) {
      // Check both photos and media library permissions
      final photoStatus = await Permission.photos.status;
      final mediaStatus = await Permission.mediaLibrary.status;

      if (photoStatus.isGranted || photoStatus.isLimited || mediaStatus.isGranted) {
        return true;
      }

      final photoResult = await Permission.photos.request();
      final mediaResult = await Permission.mediaLibrary.request();

      return photoResult.isGranted || photoResult.isLimited || mediaResult.isGranted;
    } else if (Platform.isAndroid) {
      // Android 13+ needs separate permissions for images, videos, audio
      if (await Permission.photos.isGranted ||
          await Permission.videos.isGranted ||
          await Permission.audio.isGranted) {
        return true;
      }

      // Request permissions based on Android version
      final photoResult = await Permission.photos.request();
      final videoResult = await Permission.videos.request();
      final audioResult = await Permission.audio.request();

      if (photoResult.isGranted || videoResult.isGranted || audioResult.isGranted) {
        return true;
      }

      // Fallback for older Android versions (<= Android 12)
      return await requestPermission(Permission.storage);
    }
    return false; // Permission denied
  }

  // Request permission for accessing audio files
  Future<bool> requestAudioPermission() async {
    if (Platform.isIOS) {
      return await requestPermission(Permission.mediaLibrary);
    } else if (Platform.isAndroid) {
      return await requestPermission(Permission.audio);
    }
    return false;
  }

  
}
