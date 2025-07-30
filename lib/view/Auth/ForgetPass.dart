import 'package:bid4style/Utils/ValidationHelper.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/view/Auth/widgets/authsmallwidgets.dart';
import 'package:bid4style/widgets/Appcontainer.dart';
import 'package:bid4style/widgets/CommonStartLayout.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModal/AuthviewModel/ForgotPasswordViewModel.dart';
import '../../widgets/ButtonWidget.dart';
import '../../widgets/TextFieldWidget.dart';

class ForgetPass extends StatelessWidget {
  const ForgetPass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonStartLayout(
        WidgetList: AppContainer(
          width: MediaQuery.of(context).size.width * 0.9,
          columnWidget: SizedBox(
            //   height: context.mediaQueryHeight * 0.55,
            child: SingleChildScrollView(
              child: ChangeNotifierProvider(
                create: (context) => ForgotPasswordViewModel(),
                child: Consumer<ForgotPasswordViewModel>(
                  builder: (context, viewModel, child) {
                    return Form(
                      key: viewModel.formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: context.mediaQueryHeight * 0.01,
                            ),
                            child: Text(
                              "Forgot\nPassword",
                              textAlign: TextAlign.center,
                              style: CustomTextStyle.authHeading,
                            ),
                          ),
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
                              viewModel.isLoading
                                  ? null
                                  : viewModel.validateForm(context);
                            },
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
