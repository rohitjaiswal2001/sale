import 'package:bid4style/Utils/Appcolor.dart';
import 'package:bid4style/utils/ValidationHelper.dart';
import 'package:bid4style/view/Auth/widgets/authsmallwidgets.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/editprofileviewmodal.dart';
import 'package:bid4style/widgets/ButtonWidget.dart';
import 'package:bid4style/widgets/TextFieldWidget.dart';
import 'package:bid4style/widgets/apploader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfileViewModel(),
      child: const _EditProfileScreen(),
    );
  }
}

class _EditProfileScreen extends StatefulWidget {
  const _EditProfileScreen();

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final viewModel = context.read<EditProfileViewModel>();
          viewModel.initializeControllers(context);
        } catch (e) {
          print("Error initializing controllers: $e");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditProfileViewModel>();

    return LoadingOverlay(
      isLoading: viewModel.isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Edit Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                if (viewModel.formKey.currentState!.validate()) return;

                viewModel.saveProfile(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: viewModel.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Circular container for profile picture
                  GestureDetector(
                    onTap: () => _showImageOptions(context, viewModel),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.grey,
                      backgroundImage:
                          viewModel.profilePicController.text.isNotEmpty
                          ? CachedNetworkImageProvider(
                              viewModel.profilePicController.text,
                            )
                          : null,
                      child: viewModel.profilePicController.text.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextDeclarationWidget(text: "Email"),
                  TexfieldWidget(
                    color: AppColors.white,
                    controller: viewModel.emailController,
                    validator: ValidationHelper.validateEmail,
                    hint: "Enter your email",
                    focusNode: viewModel.emailFocusNode,
                    nextFocusNode: viewModel.userNameFocusNode,
                  ),
                  TextDeclarationWidget(text: "Username"),
                  TexfieldWidget(
                    color: AppColors.white,
                    controller: viewModel.userNameController,
                    validator: ValidationHelper.validateName,
                    hint: "Enter Username",
                    focusNode: viewModel.userNameFocusNode,
                    nextFocusNode: viewModel.bioFocusNode,
                  ),
                  TextDeclarationWidget(text: "Bio (Optional)"),
                  TexfieldWidget(
                    controller: viewModel.bioController,
                    hint: "Bio",
                    focusNode: viewModel.bioFocusNode,
                    maxLine: 5,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageOptions(BuildContext context, EditProfileViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(context, ImageSource.gallery);
                },
              ),
              if (viewModel.profilePicController.text.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.removeProfilePicture();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
