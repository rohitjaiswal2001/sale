import 'package:bid4style/Utils/ValidationHelper.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/Helper.dart';
import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/view/Auth/LoginPage.dart';
import 'package:bid4style/view/Auth/widgets/textsmallwidgets.dart';
import 'package:bid4style/viewModal/AuthviewModel/SignupViewModel.dart';
import 'package:bid4style/widgets/Appcontainer.dart';
import 'package:bid4style/widgets/ButtonWidget.dart';
import 'package:bid4style/widgets/CommonStartLayout.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:bid4style/widgets/TextFieldWidget.dart';
import 'package:bid4style/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  void dispose() {
    // Provider.of<SignupViewModel>(context, listen: false).clearController();
    print("object---SignupviewModel--------");
    // context.watch()<LoginViewModel>().clear();
    super.dispose();
  }

  final ValueNotifier<bool> isCheckedNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonStartLayout(
        multiplier: 1.7,
        WidgetList: AppContainer(
          width: MediaQuery.of(context).size.width * 0.9,
          columnWidget: SizedBox(
            // height: context.mediaQueryHeight * 0.55,
            child: SingleChildScrollView(
              child: ChangeNotifierProvider(
                create: (context) => SignupViewModel(),
                child: Consumer<SignupViewModel>(
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
                              "Create New\n Account",
                              textAlign: TextAlign.center,
                              style: CustomTextStyle.authHeading,
                            ),
                          ),
                          TextDeclarationWidget(text: "Select Role"),
                          DropdownWidget<String>(
                            hint: "Select role",
                            value: viewModel.selectedRole,
                            items: ["Buyer", "Seller"]
                                .map(
                                  (gender) => DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                viewModel.selectedRole = value!;
                              });
                            },
                            validator: (value) =>
                                value == null ? "Please select a role" : null,
                            focusNode: viewModel.dropdownFocusNode,
                            nextFocusNode: viewModel.nameFocusNode,
                            isDisabled: false,
                            readOnly: false,
                          ),

                          TextDeclarationWidget(text: "Name"),
                          TexfieldWidget(
                            color: AppColors.white,
                            validator: ValidationHelper.validateName,
                            controller: viewModel.nameController,
                            hint: "Enter your name",
                            focusNode: viewModel.nameFocusNode,
                            nextFocusNode: viewModel.emailFocusNode,
                          ),
                          TextDeclarationWidget(text: "Email"),
                          TexfieldWidget(
                            focusNode: viewModel.emailFocusNode,
                            nextFocusNode: viewModel.phoneFocusNode,
                            validator: ValidationHelper.validateEmail,
                            controller: viewModel.emailController,
                            hint: "Enter your email",
                          ),
                          TextDeclarationWidget(text: "Phone no."),
                          TexfieldWidget(
                            focusNode: viewModel.phoneFocusNode,
                            nextFocusNode: viewModel.passwordFocusNode,
                            validator:
                                ValidationHelper.validatePhoneInternational,
                            controller: viewModel.phoneController,
                            hint: "Enter your phone no.",
                          ),
                          TextDeclarationWidget(text: "Password"),
                          TexfieldWidget(
                            focusNode: viewModel.passwordFocusNode,
                            nextFocusNode: viewModel.confirmPasswordFocusNode,
                            validator: ValidationHelper.validatePassword,
                            controller: viewModel.passwordController,
                            obscureText: true,
                            hint: "Enter your password",
                          ),
                          TextDeclarationWidget(text: "Confirm Password"),
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
                            hint: "Enter your confirm password",
                            focusNode: viewModel.confirmPasswordFocusNode,
                            // nextFocusNode: viewModel.biofocus,
                            obscureText: true,
                          ),
                          // TextDeclarationWidget(text: "Bio"),
                          // TexfieldWidget(
                          //   controller: viewModel.bioController,
                          //   maxLine: 3,
                          //   hint: "Bio(Optional)",
                          //   focusNode: viewModel.biofocus,
                          // ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ValueListenableBuilder<bool>(
                                valueListenable: isCheckedNotifier,
                                builder: (context, isChecked, child) {
                                  return Checkbox(
                                    activeColor: AppColors.themecolor,
                                    value: isChecked,
                                    onChanged: (value) {
                                      isCheckedNotifier.value = value!;
                                    },
                                  );
                                },
                              ),
                              Row(
                                children: [
                                  Text("I agree to "),
                                  TextButton(
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                        EdgeInsets.zero,
                                      ),
                                    ),
                                    onPressed: () {
                                      Helper.toastMessage(
                                        message: "Terms and conditions clicked",
                                      );
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (_) =>
                                      //             TermsAndConditionpage()));
                                    },
                                    child: Text(
                                      "Terms and conditions",
                                      style: CustomTextStyle.text15.copyWith(
                                        color: AppColors.blue,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors
                                            .blue, // Underline color same as text
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          ButtonWidget(
                            loading: viewModel.isLoading,
                            name: "Create Account",
                            ontap: () {
                              viewModel.isLoading
                                  ? null
                                  : viewModel.validateForm(
                                      context,
                                      isCheckedNotifier.value,
                                    );

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (_) => ChoosePlan()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 12.0,
                              bottom: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?  ",
                                  style: CustomTextStyle.text14.copyWith(),
                                ),
                                InkWell(
                                  radius: 30,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                    );

                                    // viewModel.clearController();
                                  },
                                  child: Text(
                                    "Login",
                                    style: CustomTextStyle.heading16,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
