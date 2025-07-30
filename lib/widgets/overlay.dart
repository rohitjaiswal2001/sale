import 'package:flutter/material.dart';

class CustomLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final double opacity;
  final Color backgroundColor;
  final Color spinnerColor;

  const CustomLoadingOverlay({
    super.key,
    required this.isLoading,
    this.opacity = 0.3,
    this.backgroundColor = Colors.black,
    this.spinnerColor = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: backgroundColor.withOpacity(opacity),
            child: Center(
              child: CircularProgressIndicator(color: spinnerColor),
            ),
          )
        : const SizedBox.shrink();
  }
}
