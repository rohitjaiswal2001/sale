import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/widgets/Appcontainer.dart';
import 'package:bid4style/widgets/CommonStartLayout.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewModal/AuthviewModel/ForgotPasswordViewModel.dart';
import '../../widgets/ButtonWidget.dart';
import '../../widgets/TextFieldWidget.dart';

class CheckEmail extends StatelessWidget {
  const CheckEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CommonStartLayout(
      WidgetList: AppContainer(
        width: MediaQuery.of(context).size.width * 0.9,
        columnWidget: SizedBox(
          //   height: context.mediaQueryHeight * 0.55,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.mediaQueryHeight * 0.01),
                  child: Text(
                    "Check Your\n Email",
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.heading16.copyWith(
                      height: 1.2,
                      fontSize: 35,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: context.mediaQueryHeight * 0.01, horizontal: 2),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "We have sent you a password reset link to your email with further instructions. Please check your mail to rest your password.",
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.text15
                          .copyWith(color: AppColors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonWidget(
                    name: "Open email",
                    ontap: () {
                      // context.read<ForgotPasswordViewModel>().openEmailInbox();
                    }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
