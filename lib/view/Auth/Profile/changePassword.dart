import 'package:bid4style/Utils/ValidationHelper.dart';
import 'package:bid4style/view/Auth/widgets/authsmallwidgets.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/editprofileviewmodal.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';
import 'package:bid4style/viewModal/profileviewModal/profileviewmodal.dart';
import 'package:bid4style/widgets/TextFieldWidget.dart';
import 'package:bid4style/widgets/apploader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfileViewModel(),
      builder: (context, child) {
        // Access EditProfileViewModel within the builder's context
        final editProfileViewModel = Provider.of<EditProfileViewModel>(context);

        return LoadingOverlay(
          isLoading: editProfileViewModel.isLoading,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: editProfileViewModel.isLoading
                    ? null
                    : () => Navigator.pop(context),
              ),
              title: const Text('Change Password'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: editProfileViewModel.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await editProfileViewModel
                                .changePassword(
                                  _oldPasswordController.text,
                                  _newPasswordController.text,
                                  context,
                                )
                                .then((_) {
                                  _oldPasswordController.clear();
                                  _newPasswordController.clear();
                                  _confirmPasswordController.clear();
                                });
                          }
                        },
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextDeclarationWidget(text: "Old Password"),
                        TexfieldWidget(
                          hint: 'Old Password',
                          controller: _oldPasswordController,
                          suffix: const Icon(Icons.lock),
                          validator: ValidationHelper.validatePassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        const TextDeclarationWidget(text: 'New Password'),
                        TexfieldWidget(
                          hint: 'New Password',
                          controller: _newPasswordController,
                          suffix: const Icon(Icons.lock),
                          validator: ValidationHelper.validatePassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        const TextDeclarationWidget(text: 'Confirm Password'),
                        TexfieldWidget(
                          hint: 'Confirm Password',
                          controller: _confirmPasswordController,
                          validator: (value) =>
                              ValidationHelper.confirmValidatePassword(
                                _newPasswordController.text,
                                value,
                              ),
                          suffix: const Icon(Icons.lock),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
