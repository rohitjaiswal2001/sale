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
  late ForgotPasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ForgotPasswordViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Start timer when OTP screen loads
      _viewModel.startTimerIfNeeded();
    });
  }

  @override
  void dispose() {
    _viewModel.disposeTimer();
    super.dispose();
  }

  Widget _buildResendSection(
    ForgotPasswordViewModel viewModel,
    BuildContext context,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Didn't receive code? "),
            TextButton(
              onPressed: viewModel.canResend
                  ? () => viewModel.resendOtp(context)
                  : null,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                  viewModel.canResend ? AppColors.themecolor : AppColors.grey,
                ),
              ),
              child: viewModel.isLoadingResend
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.themecolor,
                      ),
                    )
                  : const Text("Resend"),
            ),
          ],
        ),
        if (!viewModel.canResend)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              viewModel.remainingSeconds > 0
                  ? "Please wait ${viewModel.remainingSeconds} seconds before resending."
                  : "Please wait before resending.",
              style: TextStyle(color: AppColors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Dispose the timer when navigating away
          _viewModel.disposeTimer();
        }
      },
      child: Scaffold(
        body: CommonStartLayout(
          WidgetList: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("We have emailed you a", style: CustomTextStyle.heading18),
              Text("verification code", style: CustomTextStyle.heading30),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 100,
                child: Consumer<ForgotPasswordViewModel>(
                  builder: (context, viewModel, child) {
                    return PinCodeTextField(
                      blinkWhenObscuring: false,
                      useHapticFeedback: false,
                      autoDismissKeyboard: true,
                      animationType: AnimationType.none,
                      pinTheme: PinTheme(
                        inactiveColor: AppColors.themecolor,
                        selectedColor: AppColors.themecolor,
                        shape: PinCodeFieldShape.box,
                        activeBorderWidth: 2,
                        borderRadius: BorderRadius.circular(10),
                        borderWidth: 2,
                        inactiveBorderWidth: 2,
                        selectedBorderWidth: 2,
                        disabledBorderWidth: 2,
                        disabledColor: AppColors.themecolor,
                        activeColor: AppColors.themecolor,
                      ),
                      keyboardType: TextInputType.number,
                      appContext: context,
                      length: 6,
                      onCompleted: (value) {
                        viewModel.otpText = value;
                        viewModel.otpCheck(context);
                      },
                      onSubmitted: (String code) {
                        viewModel.otpText = code;
                        viewModel.otpCheck(context);
                      },
                      onChanged: (value) {
                        // Don't trigger rebuilds on every character change
                        viewModel.otpTextSilent = value;
                      },
                    );
                  },
                ),
              ),
              Consumer<ForgotPasswordViewModel>(
                builder: (context, viewModel, child) {
                  return _buildResendSection(viewModel, context);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Consumer<ForgotPasswordViewModel>(
                builder: (context, viewModel, child) {
                  return ButtonWidget(
                    loading: viewModel.isLoading,
                    name: "Verify",
                    ontap: () {
                      viewModel.isLoading ? null : viewModel.otpCheck(context);
                    },
                    width: MediaQuery.of(context).size.width * 0.8,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
