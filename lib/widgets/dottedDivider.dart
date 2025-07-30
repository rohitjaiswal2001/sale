import 'package:flutter/material.dart';

class CustomDottedDivider extends StatelessWidget {
  const CustomDottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(40, (index) {
        return Container(
          width: 3, // width of each dot
          height: 1.5, // height of each dot
          decoration: const BoxDecoration(
            color: Colors.grey, // dot color
            shape: BoxShape.rectangle,
          ),
        );
      }),
    );
  }
}
