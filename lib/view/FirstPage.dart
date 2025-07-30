import 'package:bid4style/services/session_manager.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/view/Auth/Signup.dart';
import 'package:bid4style/view/Auth/LoginPage.dart';
import 'package:bid4style/viewModal/AuthviewModel/SignupViewModel.dart';
import 'package:bid4style/widgets/ButtonWidget.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("DATA CLEAR FORM FIRST PAGE");
    SharedPreferencesHelper.clearAllData();

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset("assets/images/image.png", fit: BoxFit.cover),
          ),

          // Leaf decorations
          // Positioned(
          //   top: height * 0.15,
          //   left: -width * 0.2,
          //   child: Image.asset(
          //     "assets/icons/leaf1.png",
          //     width: width * 0.5,
          //     height: height * 0.5,
          //   ),
          // ),
          // Positioned(
          //   top: height * 0.2,
          //   right: -width * 0.1,
          //   child: Image.asset("assets/icons/leaf2.png", scale: 1.3),
          // ),

          // Center content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/bid1.png",
                        width: 160,
                        height: 130,
                      ),
                      const SizedBox(height: 10),
                      // Image.asset(
                      //   "assets/icons/bid1.png",
                      //   width: 160,
                      //   height: 80,
                      // ),
                    ],
                  ),
                ),

                const Spacer(),

                // SVG and buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // SvgPicture.asset(
                      //   "assets/images/Group.svg",
                      //   height: height * 0.3,
                      // ),
                      const SizedBox(height: 20),
                      ButtonWidget(
                        name: "Sign in",
                        width: width * 0.9,
                        nameWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sign in", style: CustomTextStyle.buttontext),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.arrow_circle_right_outlined,
                              color: AppColors.white,
                              size: 30,
                            ),
                          ],
                        ),
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () {
                          Provider.of<SignupViewModel>(
                            context,
                            listen: false,
                          ).clearController();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CreateAccount()),
                          );
                        },
                        child: Text(
                          "Create an account",
                          style: CustomTextStyle.heading18w400,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
