import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';

class TextDeclarationWidget extends StatelessWidget {
  final String text;

  const TextDeclarationWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),

        Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.mediaQueryHeight * 0.01,
            horizontal: 2,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(text, style: CustomTextStyle.text15),
          ),
        ),
      ],
    );
  }
}
