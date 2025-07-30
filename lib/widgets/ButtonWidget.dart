import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';


import '../Utils/Appcolor.dart';

class ButtonWidget extends StatefulWidget {
  final VoidCallback ontap;
  final Color? color;
  bool loading;
  final String name;
  final double? width;
  final double? height;
  final Widget? nameWidget;
  final Color bordercolor;
  final double? radius;
  final TextStyle? textstyle;
  ButtonWidget(
      {this.nameWidget,
      this.loading = false,
      this.height,
      this.radius,
      this.textstyle,
      required this.name,
      required this.ontap,
      this.width,
      super.key,
      this.color,
      this.bordercolor = Colors.transparent});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      child: Container(
          width: widget.width ?? MediaQuery.of(context).size.width,
          height: widget.height ?? MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
            border: Border.all(color: widget.bordercolor),
            borderRadius: BorderRadius.circular(widget.radius ?? 10),
            color: widget.color ?? AppColors.themecolor,
          ),
          child: Center(
            child: widget.loading
                ? CircularProgressIndicator(
                    color: AppColors.white,
                  )
                : widget.nameWidget ??
                    Text(
                      widget.name,
                      style: widget.textstyle ?? CustomTextStyle.buttontext,
                      textAlign: TextAlign.center,
                    ),
          )),
    );
  }
}
