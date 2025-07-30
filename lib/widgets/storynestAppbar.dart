import 'package:flutter/material.dart';

import '../Utils/Appcolor.dart';

class StoryNextAppBar extends StatelessWidget {
  const StoryNextAppBar(
      {super.key, this.actions, this.leadingWidget, this.centreWidget});

  final Widget? actions;
  final Widget? centreWidget;
  final Widget? leadingWidget;
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final appBarHeight = isPortrait
        ? MediaQuery.of(context).size.height * 0.15
        : MediaQuery.of(context).size.height * 0.3;

    return Container(
      height: appBarHeight,
      decoration: BoxDecoration(
        color: AppColors.themecolor,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageWidth = constraints.maxWidth * 0.5; // Fixed size
                final imageheight = appBarHeight * 0.4; //
                return ListTile(
                  leading: leadingWidget ??
                      IconButton(
                        onPressed: () {
                          // Open the drawer without using a GlobalKey
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: AppColors.white,
                        ),
                      ),
                  title: Center(
                    child: centreWidget ??
                        Image.asset(
                          "assets/images/storynext.png",
                          width: imageWidth,
                          height: imageheight,
                          fit: BoxFit.contain,
                        ),
                  ),
                  trailing: Padding(
                    padding:
                        EdgeInsets.only(right: constraints.maxWidth * 0.02),
                    child: actions ??
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.12,
                        ),
                  ),
                  contentPadding:
                      EdgeInsets.zero, // Remove default padding from ListTile
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
