import 'package:bid4style/Utils/Helper.dart';
import 'package:flutter/material.dart';
import '../Utils/Appcolor.dart';

class AppContainer extends StatelessWidget {
  final columnWidget;
  final color;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? fontwidth;
  final Color? bordercolor;
  const AppContainer({
    this.color,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.fontwidth,
    this.bordercolor,
    required this.columnWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(10),
      padding: padding ?? const EdgeInsets.all(10),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Helper().hexToColor("#F5F5F5"),
        border: Border.all(
          color: bordercolor ?? AppColors.themecolor,
          width: fontwidth ?? 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: columnWidget,
    );
  }
}
