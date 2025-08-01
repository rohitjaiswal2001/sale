import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/viewModal/AuthviewModel/ForgotPasswordViewModel.dart';
import 'package:bid4style/widgets/ButtonWidget.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../widgets/CommonStartLayout.dart';

class OtpCreate extends StatelessWidget {
  const OtpCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordViewModel(),
      child: _OtpCreate(),
    );
  }
}

class _OtpCreate extends StatefulWidget {
  const _OtpCreate();

  @override
  State<_OtpCreate> createState() => _OtpCreateState();
}

class _OtpCreateState extends State<_OtpCreate> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<ForgotPasswordViewModel>().onlyStartTimer();
    });
  }

  @override
  void dispose() {
    // context.read<ForgotPasswordViewModel>().disposeTimer();
    super.dispose();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Dispose the timer when navigating away
        context.read<ForgotPasswordViewModel>().disposeTimer();
        return true; // Allow the page to pop
      },
      child: Scaffold(
        body: CommonStartLayout(
          WidgetList: Consumer<ForgotPasswordViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "We have emailed you a",
                    style: CustomTextStyle.heading18,
                  ),
                  Text("verification code", style: CustomTextStyle.heading30),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 100,
                    child: PinCodeTextField(
                      blinkWhenObscuring: false,
                      useHapticFeedback: false,
                      autoDismissKeyboard: true,
                      animationType: AnimationType.none,
                      pinTheme: PinTheme(
                        inactiveColor: AppColors.themecolor,
                        selectedColor: AppColors.themecolor,
                        shape: PinCodeFieldShape.box,
                        activeBorderWidth: 2,
                        // activeFillColor: AppColors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        borderWidth: 2,
                        inactiveBorderWidth: 2,
                        selectedBorderWidth: 2,
                        disabledBorderWidth: 2,
                        disabledColor: AppColors.themecolor,
                        activeColor: AppColors.themecolor,
                      ),
                      // enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      appContext: context,
                      length: 6,

                      onCompleted: (value) {
                        viewModel.otpText = value;
                        print("OTP oncomplete: ${viewModel.otpText}");

                        viewModel.otpCheck(context);
                      },
                      onSubmitted: (String code) {
                        viewModel.otpText = code;
                        print("OTP onsubmited: ${viewModel.otpText}");
                        viewModel.otpCheck(context);
                      },

                      onChanged: (value) {
                        viewModel.otpText = value;
                        print("OTP onChange: ${viewModel.otpText}");
                      },
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't receive code? "),
                      TextButton(
                        onPressed: viewModel.remainingTime > 0
                            ? null
                            : () => viewModel.resendOtp(context),
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(
                            viewModel.remainingTime > 0
                                ? AppColors.grey
                                : AppColors.themecolor,
                          ),
                        ),
                        child: const Text("Resend"),
                      ),
                    ],
                  ),
                  if (viewModel.remainingTime > 0)
                    Text(
                      "Wait for ${viewModel.remainingTime} seconds to resend the link.",
                    ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  ButtonWidget(
                    loading: viewModel.isLoading,
                    name: "Verify",
                    ontap: () {
                      viewModel.isLoading ? null : viewModel.otpCheck(context);
                    },
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
