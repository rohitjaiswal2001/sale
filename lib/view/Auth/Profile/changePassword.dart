import 'package:bid4style/Utils/ValidationHelper.dart';
import 'package:bid4style/view/Auth/widgets/authsmallwidgets.dart';
import 'package:bid4style/viewModal/profileviewModal/profileviewmodal.dart';
import 'package:bid4style/widgets/TextFieldWidget.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
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


    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Change Password'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {


                _formKey.currentState!.validate(){


                  
                }
                final oldPassword = _oldPasswordController.text;
                final newPassword = _newPasswordController.text;
                final confirmPassword = _confirmPasswordController.text;
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  TextDeclarationWidget(text: "Old Password"),
                  TexfieldWidget(
                    hint: 'Old Password',
                    controller: _oldPasswordController,
                    suffix: const Icon(Icons.lock),
                    validator: ValidationHelper.validatePassword,
                    obscureText: true,
                  ),
                  TextDeclarationWidget(text: 'New Password'),
                  TexfieldWidget(
                    hint: 'New Password',
                    controller: _newPasswordController,
                    suffix: const Icon(Icons.lock),
                    validator: ValidationHelper.validatePassword,
                    obscureText: true,
                  ),
                  TextDeclarationWidget(text: 'Confirm Password'),
                  TexfieldWidget(
                    hint: 'Confirm Password',
                    controller: _confirmPasswordController,
                    // validator: ValidationHelper.confirmValidatePassword(
                    //   _newPasswordController.text,
                    //   _confirmPasswordController.text,
                    // ),
                    suffix: const Icon(Icons.lock),
                    obscureText: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
