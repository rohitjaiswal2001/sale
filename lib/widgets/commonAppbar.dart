import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import '../Utils/Appcolor.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actionList;
  const CommonAppbar(
      {super.key, this.leading, this.actionList, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.themecolor,
      foregroundColor: AppColors.white,
      leading: leading ??
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
      title: Text(title),
      actions: actionList,
      titleTextStyle:
          CustomTextStyle.heading18.copyWith(color: AppColors.white),
      toolbarHeight: 60, // You can still set toolbarHeight
      centerTitle: true,
    );
  }

  // This defines the preferred size of the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(60); // Adjust this if necessary
}
