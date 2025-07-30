import 'package:bid4style/utils/Appcolor.dart';
import 'package:flutter/material.dart';

class CommonStartLayout extends StatelessWidget {
  final Widget WidgetList;
  final double multiplier;
  final bool backbool;

  const CommonStartLayout({
    required this.WidgetList,
    this.multiplier = 1,
    super.key,
    this.backbool = true,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: AppColors.transparent,
          leading: backbool
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    color: AppColors.themecolor,
                    size: 40,
                  ),
                )
              : const SizedBox(),
        ),
        body: SingleChildScrollView(
          // child: Container(
          //   width: width,
          //   height: height * multiplier,
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/image.png"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          child: Column(
            children: [
              const SizedBox(height: 40), // Add spacing from top if needed
              Image.asset("assets/icons/bid1.png", width: 150, height: 140),
              const SizedBox(height: 20), // Space between image and content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: WidgetList,
              ),
            ],
          ),
          // ),
        ),
      ),
    );
  }
}
