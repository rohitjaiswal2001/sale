import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';
import 'package:bid4style/widgets/ButtonWidget.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AccountCreated extends StatelessWidget {
  const AccountCreated({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Userdetailviewmodel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: SizedBox(
            height: context.mediaQueryHeight,
            width: context.mediaQueryWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: context.mediaQueryHeight * 0.07),
                Image.asset(
                  alignment: Alignment.center,
                  "assets/images/created.png",
                  height: context.mediaQueryHeight * 0.3,
                ),
                Text(
                  "Account Created\n successfully !!!",
                  style: CustomTextStyle.heading30,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    // maxLines: 10,
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.text14.copyWith(
                      color: AppColors.grey,
                    ),
                    "We're so excited to have you here. Ready to start building your digital legacy? You can opt in for our 1-week free trial to explore all our features or choose from one of our subscription tiers starting at just \$2.99/month—no pressure, just the freedom to create and share memories at your own pace.\n\n Let’s begin your journey of capturing and preserving life’s precious moments! 💖\n",
                  ),
                ),
                // ButtonWidget(
                //     width: 90,
                //     name: "Okay!!",
                //     loading: viewModel.checkSubscriptionLoading,
                //     ontap: () async {
                //       await viewModel.ckeckSubscription().then((val) {
                //         if (val == '1' || val == '3') {

                //           print("Go to Home Page");
                //           // Navigator.pushAndRemoveUntil(
                //           //     context,
                //           //     MaterialPageRoute(builder: (_) => Homepage()),
                //           //     (Route<dynamic> route) => false);
                //         } else {

                //                              print("Go to plabn page");
                //           // Navigator.push(
                //           //     context,
                //           //     MaterialPageRoute(
                //           //         builder: ((_) => const ChoosePlan())));
                //         }
                //       });
                //     })
              ],
            ),
          ),
        );
      },
    );
  }
}
