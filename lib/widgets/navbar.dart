import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/view/Auth/Profile/viewprofile.dart';
import 'package:bid4style/view/Auth/Profile/changePassword.dart';
import 'package:bid4style/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();

    
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const AuctionPage(),
      const AuctionPage(),
      const AuctionPage(), // Placeholder for another screen
      const ProfileScreen(), // Placeholder for another screen
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        // title: "Home",
        activeColorPrimary: AppColors.themecolor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite),
        // title: "Like",
        activeColorPrimary: AppColors.themecolor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.list),
        // title: "List",
        activeColorPrimary: AppColors.themecolor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        // title: "Edit Profile",
        activeColorPrimary: AppColors.themecolor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      // confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      // hideNavigationBarWhenKeyboardShows: true,
      decoration: const NavBarDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        colorBehindNavBar: Colors.white,
      ),
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,

      confineToSafeArea: true,
      hideNavigationBarWhenKeyboardAppears: true,
      bottomScreenMargin: 5,

      // hideOnScrollSettings: HideOnScrollSettings(hideNavBarOnScroll: true),
      // animationSettings: NavBarAnimationSettings(
      //   navBarItemAnimation: ItemAnimationSettings(
      //     curve: Curves.,
      //     duration: Duration(seconds: 2),
      //   ),

      //   screenTransitionAnimation: ScreenTransitionAnimationSettings(
      //     animateTabTransition: true,
      //     curve: Curves.easeIn,
      //     duration: Duration(milliseconds: 200),
      //   ),
      //   onNavBarHideAnimation: OnHideAnimationSettings(
      //     curve: Curves.bounceIn,
      //     duration: Duration(seconds: 2),
      //   ),
      // ),
      navBarStyle: NavBarStyle.style12, // Use Style 2
    );
  }
}
