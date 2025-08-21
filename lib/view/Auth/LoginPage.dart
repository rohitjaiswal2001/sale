import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/view/Auth/ForgetPass.dart';
import 'package:bid4style/view/Auth/widgets/textsmallwidgets.dart';
import 'package:bid4style/widgets/Appcontainer.dart';
import 'package:bid4style/widgets/CommonStartLayout.dart';
import 'package:bid4style/widgets/CustomTextstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../Utils/ValidationHelper.dart';
import '../../viewModal/AuthviewModel/LoginViewModel.dart';
import '../../widgets/ButtonWidget.dart';
import '../../widgets/TextFieldWidget.dart';
import 'Signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    LoginViewModel().clear();
    // context.watch()<LoginViewModel>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CommonStartLayout(
          multiplier: 1.0,
          WidgetList: AppContainer(
            width: MediaQuery.of(context).size.width * 0.9,
            columnWidget: SizedBox(
              // height: context.mediaQueryHeight * 0.55,
              child: ChangeNotifierProvider(
                create: (context) => LoginViewModel(),
                child: Consumer<LoginViewModel>(
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
                              "Login",
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
                            focusNode: viewModel.emailFocusNode,
                            nextFocusNode: viewModel.passwordFocusNode,
                          ),
                          TextDeclarationWidget(text: "Password"),
                          TexfieldWidget(
                            color: AppColors.white,
                            obscureText: true,
                            controller: viewModel.passwordController,
                            validator: ValidationHelper.validatePassword,
                            focusNode: viewModel.passwordFocusNode,
                            hint: "Enter your password",
                          ),
                          const SizedBox(height: 20),
                          ButtonWidget(
                            name: "Login",
                            loading: viewModel.isLoading,
                            ontap: () {
                              viewModel.isLoading
                                  ? null
                                  : viewModel.validateForm(context);
                            },
                          ),
                          const SizedBox(height: 20),
                          ButtonWidget(
                            name: "Login with Google",
                            nameWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/google.svg",
                                  height: 25,
                                  width: 25,
                                ),

                                SizedBox(width: 8),
                                Text(
                                  "Login with Google",
                                  style: CustomTextStyle.text14.copyWith(),
                                ),
                              ],
                            ),

                            loading: viewModel.isLoading,
                            color: AppColors.white,
                            bordercolor: AppColors.black,
                            textstyle: CustomTextStyle.text16.copyWith(
                              color: AppColors.black,
                            ),
                            ontap: () {
                              viewModel.isLoading
                                  ? null
                                  : viewModel.signInWithGoogle(context: context);
                            },
                          ),

                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 12.0,
                              bottom: 10,
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ForgetPass(),
                                  ),
                                ).then((_) => viewModel.clear());
                              },
                              child: Text(
                                "Forgot Password?",
                                style: CustomTextStyle.heading16w400,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CreateAccount(),
                                    ),
                                  ).then((_) => viewModel.clear());
                                },
                                child: Text(
                                  "Don't have an account",
                                  style: CustomTextStyle.text16.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
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
