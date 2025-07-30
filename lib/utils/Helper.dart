
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:url_launcher/url_launcher.dart';

class Helper {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  // static void flushBarErrorMessage(String message, BuildContext context) {
  //   showFlushbar(
  //     context: context,
  //     flushbar: Flushbar(
  //       forwardAnimationCurve: Curves.decelerate,
  //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //       padding: const EdgeInsets.all(15),
  //       message: message,
  //       duration: const Duration(seconds: 3),
  //       borderRadius: BorderRadius.circular(8),
  //       flushbarPosition: FlushbarPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       reverseAnimationCurve: Curves.easeInOut,
  //       positionOffset: 20,
  //       icon: const Icon(
  //         Icons.error,
  //         size: 28,
  //         color: Colors.white,
  //       ),
  //     )..show(context),
  //   );
  // }

  static toastMessage({String message = "", Color? color = Colors.black}) {
    Fluttertoast.showToast(
      gravity: ToastGravity.CENTER_LEFT,
      toastLength: Toast.LENGTH_LONG,
      msg: message,
      backgroundColor: color,
      textColor: Colors.white,
    );
  }

  // we will utilise this for showing errors or success messages
  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

// Add elipsis
  static String truncateString(String input) {
    int maxLength = 10; // Set your desired length here

    if (input.length <= maxLength) {
      return input; // No need to truncate
    }

    int partLength = (maxLength - 3) ~/ 2;
    String start = input.substring(0, partLength);
    String end = input.substring(input.length - partLength);

    return '$start...$end';
  }

  // void openLink(String? url) async {
  //   if (url == null) return;

  //   try {
  //     final Uri uri = Uri.parse(url);

  //     if (url.contains('@')) {
  //       print("Email");
  //       final Uri emailLaunchUri = Uri(
  //         scheme: 'mailto',
  //         path: url.replaceFirst('mailto:', ''),
  //         query: encodeQueryParameters(<String, String>{
  //           'subject': '',
  //         }),
  //       );
  //       launchUrl(emailLaunchUri);
  //     } else {
  //       if (await canLaunchUrl(uri)) {
  //         await launchUrl(uri, mode: LaunchMode.externalApplication);
  //       } else {
  //         Helper.toastMessage(
  //             message: 'Could not launch $url', color: AppColors.red);
  //       }
  //     }
  //   } catch (e) {
  //     print('Error launching URL: $e');
  //   }
  // }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
