import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/viewModal/AuthviewModel/UpdatepasswordViewModel.dart';
import 'package:bid4style/widgets/Appcontainer.dart';
import 'package:bid4style/widgets/CommonStartLayout.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:provider/provider.dart';

import '../../Utils/ValidationHelper.dart';
import '../../viewModal/AuthviewModel/SignupViewModel.dart';
import '../../widgets/ButtonWidget.dart';
import '../../widgets/TextFieldWidget.dart';

class UpdateAccount extends StatelessWidget {
  UpdateAccount({required this.email, super.key});
  String otp = "";
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonStartLayout(
        multiplier: 1.4,
        WidgetList: AppContainer(
          width: MediaQuery.of(context).size.width * 0.9,
          columnWidget: SizedBox(
            // height: context.mediaQueryHeight * 0.55,
            child: SingleChildScrollView(
              child: ChangeNotifierProvider(
                create: (context) => UpdateAccountViewModel(),
                child: Consumer<UpdateAccountViewModel>(
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
                              "Update Your\n Account",
                              textAlign: TextAlign.center,
                              style: CustomTextStyle.heading16.copyWith(
                                height: 1.2,
                                fontSize: 35,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: context.mediaQueryHeight * 0.01,
                              horizontal: 2,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Password",
                                style: CustomTextStyle.text15,
                              ),
                            ),
                          ),
                          TexfieldWidget(
                            focusNode: viewModel.passwordFocusNode,
                            nextFocusNode: viewModel.confirmPasswordFocusNode,
                            validator: ValidationHelper.validatePassword,
                            controller: viewModel.passwordController,
                            obscureText: true,
                            hint: "Enter your password",
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: context.mediaQueryHeight * 0.01,
                              horizontal: 2,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Confirm Password",
                                style: CustomTextStyle.text15,
                              ),
                            ),
                          ),
                          TexfieldWidget(
                            validator: (value) =>
                                ValidationHelper.confirmValidatePassword(
                                  viewModel
                                      .passwordController
                                      .text, // Capture the original password from the controller
                                  value, // The value entered in the confirm password field
                                ),
                            //validator: ValidationHelper.confirmvalidatePassword("GF","f"),
                            controller: viewModel.confirmpasswordController,
                            obscureText: true,
                            hint: "Enter your confirm password",
                            focusNode: viewModel.confirmPasswordFocusNode,
                          ),
                          const SizedBox(height: 20),
                          ButtonWidget(
                            loading: viewModel.isLoading,
                            name: "Update Account",
                            ontap: () {
                              viewModel.isLoading
                                  ? null
                                  : viewModel.validateForm(
                                      email,
                                      viewModel.passwordController.text.trim(),
                                      context,
                                    );

                                    
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (_) => ChoosePlan()));
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
