import 'package:flutter/material.dart';

import '../Utils/Appcolor.dart';

class CustomGradientDivider extends StatelessWidget {
  final double? height;
  final List<Color>? colors;
  final double? indent;
  final double? endIndent;
  final double? verticalpadding;

  const CustomGradientDivider({
    super.key,
    this.verticalpadding,
    this.height,
    this.colors,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalpadding ?? 0),
      child: Container(
        height: height ?? 0.2,
        margin: EdgeInsetsDirectional.only(
          start: indent ?? 45.0,
          end: endIndent ?? 45.0,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            colors: colors ??
                [
                  AppColors.transparent,
                  Colors.grey.shade500.withOpacity(0.7),
                  AppColors.transparent,
                ],
          ),
        ),
      ),
    );
  }
}
