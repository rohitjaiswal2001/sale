import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/utils/ValidationHelper.dart';
import 'package:bid4style/widgets/Appcontainer.dart';
import 'package:bid4style/widgets/CommonStartLayout.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:bid4style/widgets/ButtonWidget.dart';
import 'package:bid4style/widgets/TextFieldWidget.dart';
import 'package:bid4style/viewModal/AuthviewModel/ForgotPasswordViewModel.dart';
import '../Auth/widgets/authsmallwidgets.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  late ForgotPasswordViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ForgotPasswordViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<ForgotPasswordViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: CommonStartLayout(
              WidgetList: AppContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                columnWidget: SingleChildScrollView(
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        SizedBox(height: context.mediaQueryHeight * 0.05),
                        Text(
                          "Forgot\nPassword",
                          textAlign: TextAlign.center,
                          style: CustomTextStyle.authHeading,
                        ),
                        SizedBox(height: 20),
                        TextDeclarationWidget(text: "Email"),
                        TexfieldWidget(
                          color: AppColors.white,
                          controller: viewModel.emailController,
                          validator: ValidationHelper.validateEmail,
                          hint: "Enter your email",
                        ),
                        const SizedBox(height: 20),
                        ButtonWidget(
                          loading: viewModel.isLoading,
                          name: "Send Request",
                          ontap: () {
                            if (!viewModel.isLoading) {
                              viewModel.validateForm(context);
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
